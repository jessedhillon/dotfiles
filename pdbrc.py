# pdbpp styling
try:
    import pdb
    import pygments.formatters
    from pygments.styles.material import MaterialStyle
    from pygments.token import Name

    class MyMaterialStyle(MaterialStyle):
        styles = {
            **MaterialStyle.styles,
            Name.Tag: MaterialStyle.orange
        }

    class Config(pdb.DefaultConfig):
        formatter =\
            pygments.formatters.TerminalTrueColorFormatter(style=MyMaterialStyle)
        use_pygments = True
except ModuleNotFoundError:
    pass

# history
import atexit
import os
import readline

history_path = os.path.expanduser("~/.pdbhistory")


def save_history(history_path=history_path):
    import readline
    readline.write_history_file(history_path)


if os.path.exists(history_path):
    readline.read_history_file(history_path)

atexit.register(save_history, history_path=history_path)
