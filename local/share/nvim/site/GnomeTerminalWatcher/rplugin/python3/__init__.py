import logging
import logging.config
import os
import rpdb
import subprocess
import threading
from typing import Any, Callable, NewType, Optional
from uuid import UUID

import pynvim
from gi.repository import Gio, GLib


ProfileChangeHandler = NewType('ProfileChangeHandler', Callable[[UUID], None])


def configure_logging():
    config = {
        'version': 1,
        'disable_existing_loggers': False,
        'formatters': {
            'default': {
                'datefmt': '%Y-%m-%d %H:%M:%S',
                'format': '%(process)s [%(asctime)s %(name)s] %(levelname)-1.1s %(message)s',
            }
        },
        'handlers': {
            'stdout': {
                'class': 'logging.FileHandler',
                'formatter': 'default',
                'filename': '/tmp/gnome-terminal-profile.nvim.log',
            }
        },
        'loggers': {
            '': {
                'handlers': ['stdout'],
                'level': 'DEBUG',
                'propagate': True
            },
            'pynvim': {
                'handlers': ['stdout'],
                'level': 'WARN',
                'propagate': True
            }
        }
    }
    logging.config.dictConfig(config)


@pynvim.plugin
class GnomeTerminalProfilePlugin(object):
    def __init__(self, nvim: pynvim.api.Nvim):
        try:
            self.nvim = nvim
            self.watcher: Optional[GnomeTerminalWatcher] = None
            configure_logging()

            self.colorschemes = {UUID(k): v for k, v in self.nvim.vars.get('gnome_terminal_colorschemes').items()}
            if self.watcher is None:
                self.watcher = GnomeTerminalWatcher(self.nvim)
                self.watcher.on_profile_changed(self.change_colorscheme)
            # rpdb.set_trace()
            self.logger.info("began plugin")
        except Exception:
            self.logger.exception("caught exception")
            with open('/tmp/gnome-terminal-profile.errors.log', 'w') as f:
                import traceback
                traceback.print_exc(file=f)

    @property
    def logger(self) -> logging.Logger:
        return logging.getLogger('gnome-terminal-profile')

    @pynvim.function('GnomeTerminalWatchProfile', sync=True)
    def watch(self, args: str) -> bool:
        if not self.watcher.is_alive():
            self.watcher.start()
        return self.watcher.is_alive()

    @pynvim.autocmd('QuitPre', sync=True)
    def stop(self, *args, **kwargs):
        if self.watcher:
            self.watcher.quit()
            self.watcher.join()

    def change_colorscheme(self, profile_id: UUID):
        try:
            self.logger.debug(f"nvim caught profile_id change: {profile_id}")
            if profile_id in self.colorschemes:
                colorscheme = self.colorschemes[profile_id]
                self.logger.debug(f"changing colorscheme: {colorscheme}")
                self.nvim.async_call(lambda: self.nvim.command(f'colorscheme {colorscheme}'))
        except:
            self.logger.exception("unhandled change in change_colorscheme")
            raise


class GnomeTerminalWatcher(threading.Thread):
    def __init__(self, nvim: pynvim.api.Nvim, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.nvim = nvim
        self.loop: Optional[GLib.MainLoop] = None
        self.handlers: list[ProfileChangeHandler] = []
        self.bus_subscriber_id: int = None

    @property
    def logger(self) -> logging.Logger:
        return logging.getLogger('gnome-terminal-profile')

    def get_bus(self):
        return Gio.bus_get_sync(Gio.BusType.SESSION)

    def run(self):
        bus = self.get_bus()
        window_id = get_window_id(bus)
        profile_id = UUID(describe(bus, 'org.gnome.Terminal', window_id, 'profile', '(bgav)'))
        self.handle_profile_changed(profile_id)

        self.subscriber_id = bus.signal_subscribe(None, 'org.gtk.Actions', 'Changed',
                                                  None, None, Gio.DBusCallFlags.NONE,
                                                  self.handle_changed, None)
        try:
            self.loop = GLib.MainLoop()
            self.logger.debug(f"entering main loop, {self.subscriber_id=}")
            self.loop.run()
        except:
            self.logger.exception("failed to start main loop")

    def quit(self):
        self.loop.quit()

    def on_profile_changed(self, handler: ProfileChangeHandler):
        self.handlers.append(handler)

    def handle_changed(self, bus: Gio.DBusConnection, addr: str, window_id: str, interface_name: str,
                       signal_name: str, params: tuple[Any, Any, dict[str, str], Any], user_data: None):
        try:
            _, _, props, _ = params
            self.logger.debug(f"({get_window_id(bus)}) watcher handling change: {window_id=!r}, {interface_name=!r}, "
                              f"{signal_name=!r}, {params=!r}")
            if 'profile' in props and window_id == get_window_id(bus):
                profile_id = UUID(props['profile'])
                self.handle_profile_changed(profile_id)
        except Exception:
            self.logger.exception("unhandled exception in change handler")
            raise

    def handle_profile_changed(self, profile_id: UUID):
        for cb in self.handlers:
            cb(profile_id)


def get_screen_id() -> UUID:
    path = None
    if 'TMUX' in os.environ:
        rs = subprocess.run(['/usr/bin/tmux',
                             'show-environment',
                             'GNOME_TERMINAL_SCREEN'],
                            capture_output=True)
        out = rs.stdout.decode('utf8').strip()
        _, path = out.split('=', 1)
    else:
        path = os.getenv('GNOME_TERMINAL_SCREEN')
    if path is not None:
        hex = path.rsplit('/', 1)[-1]
        return UUID(hex.replace('_', '-'))
    raise RuntimeError(f"could not get screen ID: {path=}, {out=}")


def get_window_id(bus: Gio.DBusConnection) -> str:
    windows = []
    for path, _ in introspect_tree(bus, 'org.gnome.Terminal', '/org/gnome/Terminal'):
        if path.startswith('/org/gnome/Terminal/window/'):
            windows.append(path)

    screen_id = get_screen_id()
    this_window = None
    for path in windows:
        screens = {UUID(s) for s in describe(bus, 'org.gnome.Terminal', path, 'screens', '(bgav)')}
        if screen_id in screens:
            this_window = path
            break

    if this_window is None:
        raise RuntimeError(f"could not determine our window: {screen_id=}, {windows=}")

    return this_window


def describe(bus: Gio.DBusConnection, name: str, object_path: str, param: Any, vtype: str):
    res = bus.call_sync(name,
                        object_path,
                        'org.gtk.Actions',
                        'Describe',
                        GLib.Variant('(s)', [param]),
                        GLib.VariantType(f'({vtype})'),
                        Gio.DBusCallFlags.NONE,
                        -1,
                        None)
    return res[0][2][0]


def introspect(bus: Gio.DBusConnection, name: str, object_path: str):
    res = bus.call_sync(name,  # bus_name
                        object_path,  # object_path
                        'org.freedesktop.DBus.Introspectable',  # interface_name
                        'Introspect',  # method_name
                        None,  # parameters
                        GLib.VariantType("(s)"),  # reply_type
                        Gio.DBusCallFlags.NONE,  # flags
                        -1,  # timeout_msecs
                        None)  # cancellable

    if not res:
        return None

    return Gio.DBusNodeInfo.new_for_xml(res[0])


def introspect_tree(bus: Gio.DBusConnection, name: str, object_path: str):
    node = introspect(bus, name, object_path)

    if node:
        yield object_path, node

        if object_path == '/':
            object_path = ''

        for child in node.nodes:
            yield from introspect_tree(bus, name, f'{object_path}/{child.path}')
