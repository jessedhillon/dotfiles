local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", "__pycache__" },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      find_command = { 'rg', '--ignore', '-L', '--hidden', '--files' },
    }
  },
})

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
vim.keymap.set('n', '<C-q>', builtin.quickfix, {})
vim.keymap.set('n', '<C-a>', builtin.loclist, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
