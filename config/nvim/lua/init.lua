-- Allow startup before :PlugInstall has installed Blink.
local ok, blink = pcall(require, 'blink.cmp')
if ok then
  vim.o.autocomplete = false

  blink.setup({
    keymap = {
      preset = 'default',
      ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
    },
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
    },
    fuzzy = { implementation = 'lua' },
    sources = {
      per_filetype = { gitcommit = { 'buffer', 'commit_predict' } },
      providers = {
        commit_predict = {
          name = 'Commit prediction',
          module = 'commit_predict',
          async = true,
          min_keyword_length = 2,
        },
      },
    },
  })
end

-- nvim-lspconfig supplies the command, filetype, and root markers for Gleam.
for _, server in ipairs({ 'gleam', 'bashls' }) do
  if ok then
    vim.lsp.config(server, { capabilities = blink.get_lsp_capabilities() })
  end
  vim.lsp.enable(server)
end

-- -- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#modules
-- require('nvim-treesitter.configs').setup {
--   highlight = {
--     enable = true,
--   }
-- }

vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float({ scope = 'line' })
end, { desc = 'Show diagnostics for current line' })

vim.keymap.set('n', '<leader>l', require('lsp_shortcuts').toggle, { desc = 'Toggle LSP shortcut card' })
