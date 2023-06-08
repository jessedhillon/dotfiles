local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()

local on_attach = function(client, bufnr)
  local desc = function(desc)
    return { buffer = bufnr, remap = false, desc = desc }
  end
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, desc("[G]oto [D]efinition"))
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, desc("Hover Documentation"))
  vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, desc("View [W]orkspace Symbol"))
  vim.keymap.set('n', 'K', vim.diagnostic.open_float, desc("View Diagnostic"))
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, desc("Previous [D]iagnostic"))
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, desc("Next [D]iagnostic"))
  vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, desc("View [C]ode [A]ction"))
  vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, desc("View [R]eferences"))
  vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, desc("[R]e[N]ame"))
  vim.keymap.set('i', '<c-K>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', desc("[S]ignature"))
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  -- sumneko_lua = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  --     diagnostics = {
  --       globals = { 'vim' }
  --     }
  --   },
  -- },
  pylsp = {
    pylsp = {
      configurationSources = { 'flake8' },
      plugins = {
        flake8 = { enabled = true },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = true },
        pylint = { enabled = false } ,
      }
    }
  }
}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local conf = servers[server_name]
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = conf
    }
  end,
}

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
--   vim.lsp.handlers.hover, {
--     border = 'single'
--   }
-- )
-- 
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
--   vim.lsp.handlers.signature_help, {
--     border = 'single'
--   }
-- )
-- 
-- vim.diagnostic.config{
--   float={border='single'}
-- }
