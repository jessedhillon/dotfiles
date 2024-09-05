vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.cursorline = true
-- vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"

-- vim.opt.completeopt = "menuone,noinsert,noselect"

-- stay in same column when traveling lines
vim.opt.startofline = false

-- autocommands for filetypes
vim.cmd[[
    au BufRead,BufNewFile *.jinja2 set ft=htmldjango
    " au FileType * let &colorcolumn=""
    au FileType python,javascript,typescript let &colorcolumn="80,".join(range(121,999),",")
    au FileType python,java,javascript,typescript,c,cc,cpp,ruby,htmljinja,css,scss,yaml set number
    au FileType python set ts=4 sw=4 sts=0 et
    au FileType ruby,htmljinja,html,yaml,scss,css,c,cc,cpp,ledger,lua,javascript,typescript,soy set ts=2 sw=2 sts=0
    au FileType scss set iskeyword+=-
    au FileType markdown set wrap lbr
    au FileType markdown setlocal textwidth=120
    " hack because cmp window.documentation = false config is not respected currently
    au FileType * lua require('cmp.config').get().window.documentation = false
]]

-- catch trailing space
vim.cmd[[
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
]]
