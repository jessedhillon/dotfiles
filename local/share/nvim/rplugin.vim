" perl plugins


" node plugins


" python3 plugins
call remote#host#RegisterPlugin('python3', '/home/jesse/Devel/dotfiles/local/share/nvim/site/GnomeTerminalWatcher/rplugin/python3/__init__.py', [
      \ {'sync': v:true, 'name': 'QuitPre', 'type': 'autocmd', 'opts': {'pattern': '*'}},
      \ {'sync': v:true, 'name': 'GnomeTerminalWatchProfile', 'type': 'function', 'opts': {}},
     \ ])


" ruby plugins


" python plugins


