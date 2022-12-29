require("tokyonight").setup({
  on_highlights = function(hl, c)
    local prompt = "#2d3149"
    hl.TelescopeNormal = {
      bg = c.terminal_black,
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = c.terminal_black,
      fg = c.terminal_black,
    }
    hl.TelescopePromptNormal = {
      bg = prompt,
    }
    hl.TelescopePromptBorder = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePromptTitle = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePreviewTitle = {
      bg = c.terminal_black,
      fg = c.terminal_black,
    }
    hl.TelescopeResultsTitle = {
      bg = c.terminal_black,
      fg = c.terminal_black,
    }
  end,
})

vim.cmd.colorscheme('tokyonight-storm')

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
