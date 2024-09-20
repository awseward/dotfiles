local lspconfig = require('lspconfig')

lspconfig.gleam.setup({})

-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#modules
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  }
}
