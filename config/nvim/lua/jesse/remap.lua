vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)

-- drag selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- better join behavior
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor position when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste without replacing buffer
vim.keymap.set("v", "p", '"_dP')

-- yank into system buffer
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- paste from system buffer
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>P", '"+P')

-- window navigation
vim.keymap.set("n", "<space>", "<c-W>w")
-- vim.keymap.set("n", "<c-j>", "<C-W>j<C-W>_")
-- vim.keymap.set("n", "<c-k>", "<C-W>k<C-W>_")
vim.keymap.set("n", "<c-k>", ":res -5<CR>")
vim.keymap.set("n", "<c-j>", ":res +5<CR>")

-- navigate apparent lines, i.e. wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("v", "j", "gj")
vim.keymap.set("v", "k", "gk")
vim.keymap.set("n", "<Down>", "gj")
vim.keymap.set("n", "<Up>", "gk")
vim.keymap.set("v", "<Down>", "gj")
vim.keymap.set("v", "<Up>", "gk")
vim.keymap.set("i", "<Down>", "<C-o>gj")
vim.keymap.set("i", "<Up>", "<C-o>gk")

-- unshift
vim.keymap.set("i", "<s-tab>", "<c-d>")
vim.keymap.set("v", "<tab>", ">gv")
vim.keymap.set("v", "<s-tab>", "<gv")

-- tab navigation
vim.keymap.set("n", "t%", ":tabedit %<CR>")
vim.keymap.set("n", "t-", ":tabclose<CR>")
vim.keymap.set("n", "t+", ":tabnew<CR>")
vim.keymap.set("n", "t=", ":tabnew<CR>")
vim.keymap.set("n", "tt", ":tabs<CR>")

vim.keymap.set("n", "<c-l>", ":tabnext<CR>")
vim.keymap.set("n", "<c-h>", ":tabprev<CR>")
vim.keymap.set("n", "th", ":tabprev<CR>")
vim.keymap.set("n", "tl", ":tabnext<CR>")

vim.keymap.set("n", "t<", ":tabmove -1<CR>")
vim.keymap.set("n", "t>", ":tabmove +1<CR>")

-- quickfix list
vim.keymap.set("n", "]q", ":cnext<CR>")
vim.keymap.set("n", "[q", ":cprev<CR>")
vim.keymap.set("n", "]Q", ":cnf<CR>")
vim.keymap.set("n", "[Q", ":cpf<CR>")

vim.opt.timeoutlen = 250
vim.opt.ttimeoutlen = 0

-- insert a single char
vim.keymap.set("n", "<silent> s", ':exec "normal i".nr2char(getchar()).""<CR>')
vim.keymap.set("n", "<silent> S", ':exec "normal a".nr2char(getchar()).""<CR>')

-- treesitter-context
vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context()
end, { silent = true })
