local M = {}

local lsp_shortcuts = {
  { 'K', 'Hover docs', 'textDocument/hover' },
  { 'Ctrl-]', 'Go to definition (LSP tag)', 'textDocument/definition' },
  { 'grr', 'Find references', 'textDocument/references' },
  { 'gri', 'Go to implementation', 'textDocument/implementation' },
  { 'grt', 'Go to type definition', 'textDocument/typeDefinition' },
  { 'grn', 'Rename symbol', 'textDocument/rename' },
  { 'gra', 'Code actions', 'textDocument/codeAction' },
  { 'gO', 'Document symbols', 'textDocument/documentSymbol' },
}

local lsp_card_win
function M.toggle()
  if lsp_card_win and vim.api.nvim_win_is_valid(lsp_card_win) then
    vim.api.nvim_win_close(lsp_card_win, true)
    return
  end

  local lines = {}
  for _, shortcut in ipairs(lsp_shortcuts) do
    local key, label, method = unpack(shortcut)
    if #vim.lsp.get_clients({ bufnr = 0, method = method }) > 0 then
      lines[#lines + 1] = ('  %-7s %s  '):format(key, label)
    end
  end

  if #lines == 0 then
    vim.notify('No LSP actions available in this buffer', vim.log.levels.INFO)
    return
  end

  local width = 1
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(width, math.max(1, vim.o.columns - 2))
  local height = math.min(#lines, math.max(1, vim.o.lines - 4))

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'wipe'
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.max(0, math.floor((vim.o.lines - height - 2) / 2)),
    col = math.max(0, math.floor((vim.o.columns - width - 2) / 2)),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = ' LSP shortcuts ',
    title_pos = 'center',
    footer = ' q / Esc to close ',
    footer_pos = 'center',
  })
  lsp_card_win = win
  vim.wo[win].wrap = false

  for _, key in ipairs({ 'q', '<Esc>' }) do
    vim.keymap.set('n', key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf, desc = 'Close LSP shortcut card' })
  end
end

return M
