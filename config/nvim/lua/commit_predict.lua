local Source = {}
Source.__index = Source

local native = vim.fn.stdpath('cache') .. '/omp-predict/node_modules/@oh-my-pi/pi-natives/native/index.js'
local job, failed, next_id = nil, false, 0
local pending = {}

function Source.new()
  return setmetatable({}, Source)
end

function Source.enabled()
  return not failed
    and vim.fn.executable('bun') == 1
    and vim.fn.filereadable(native) == 1
    and #vim.api.nvim_get_runtime_file('omp-predict/helper.mjs', false) > 0
end

local function start()
  if job then return job end
  if not Source.enabled() then return end

  local helper = vim.api.nvim_get_runtime_file('omp-predict/helper.mjs', false)[1]
  local partial = ''
  local channel = vim.fn.jobstart({ 'bun', helper, native }, {
    on_stdout = function(_, chunks)
      for i = 1, #chunks - 1 do
        local ok, reply = pcall(vim.json.decode, partial .. chunks[i])
        partial = ''
        if ok and type(reply) == 'table' and pending[reply.id] then
          pending[reply.id](reply.suffix)
        end
      end
      partial = partial .. chunks[#chunks]
    end,
    on_exit = function(_, code)
      job = nil
      local inflight = pending
      pending = {}
      for _, finish in pairs(inflight) do finish() end
      if code ~= 0 and vim.v.exiting == vim.NIL then
        failed = true
        vim.notify('Commit prediction helper exited (' .. code .. '); using buffer words', vim.log.levels.WARN)
      end
    end,
  })
  if channel > 0 then job = channel end
  return job
end

function Source:get_completions(ctx, callback)
  local typed = ctx.line:sub(1, ctx.cursor[2])
  local before, prefix = typed:match("^(.-)([A-Za-z]+)$")
  local id, done
  local function finish(suffix)
    if done then return end
    done = true
    if id then pending[id] = nil end
    local items = {}
    if type(suffix) == 'string' and suffix:match('^[A-Za-z]+$') then
      items[1] = {
        label = prefix .. suffix,
        kind = require('blink.cmp.types').CompletionItemKind.Text,
      }
    end
    callback({ items = items, is_incomplete_forward = true, is_incomplete_backward = true })
  end

  -- Stay at the end of ordinary prose words; ignore Git's comment lines.
  if not prefix or #prefix < 2 or typed:match('^%s*#')
      or before:match("[%w_']$") or ctx.line:sub(ctx.cursor[2] + 1):match('^[%w_]') then
    finish()
    return
  end

  vim.defer_fn(function()
    if done then return end
    local channel = start()
    if not channel then finish(); return end
    next_id = next_id + 1
    id = next_id
    pending[id] = finish
    local query = vim.json.encode({ id = id, before = before, prefix = prefix })
    local ok, sent = pcall(vim.fn.chansend, channel, query .. '\n')
    if not ok or sent == 0 then finish(); return end
    vim.defer_fn(finish, 2000)
  end, 90)

  return function()
    done = true
    if id then pending[id] = nil end
  end
end

return Source
