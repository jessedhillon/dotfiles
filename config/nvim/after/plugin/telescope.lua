local telescope = require('telescope')
local builtin = require('telescope.builtin')
local conf = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { table.unpack(conf.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")

-- I want to follow symbolic links
table.insert(vimgrep_arguments, "-L")

telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", "__pycache__", ".git" },
		vimgrep_arguments = vimgrep_arguments,
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      find_command = { 'rg', '--ignore', '-L', '--hidden', '--files' },
    }
  },
})

-- require('telescope').load_extension('fzf')

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
vim.keymap.set('n', '<C-q>', builtin.quickfix, {})
vim.keymap.set('n', '<C-a>', builtin.loclist, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
