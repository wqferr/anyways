local M = {}

CALLBACK_ERRORED_ERROR = "scope callbacks must not error, but this occurred: %s"

local function new_context()
  return {
    fail_callbacks = {},
    succ_callbacks = {},
    exit_callbacks = {}
  }
end

local function context_wrapper(ctx)
  return {
    on_failure = function(f) table.insert(ctx.fail_callbacks, f) end,
    on_success = function(f) table.insert(ctx.succ_callbacks, f) end,
    on_exit = function(f) table.insert(ctx.exit_callbacks, f) end
  }
end

local function run_all(list, arg)
  for _, f in ipairs(list) do
    f(arg)
  end
end

local function safe_run_all(list, arg)
  local ok, ret = pcall(run_all, list, arg)
  if not ok then
    error(CALLBACK_ERRORED_ERROR:format(ret), 3)
  end
end

function M.scope(body)
  local ctx = new_context()
  local ctx_funcs = context_wrapper(ctx)
  local ok, ret = pcall(body, ctx_funcs)
  safe_run_all(ok and ctx.succ_callbacks or ctx.fail_callbacks, ret)
  safe_run_all(ctx.exit_callbacks)
end


return M
