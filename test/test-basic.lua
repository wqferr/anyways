require "reqpath"
local sniper = require "sniper"

local open = function(file) print("opening "..file); return file end
local close = function(file) print("closing "..file) end

sniper.scope(
  function(ctx)
    local f = open("my_file.lua")
    ctx.on_exit(function() close(f) end)
    ctx.on_success(function() print("success!") end)
    ctx.on_failure(function(e) print("failure! "..e) end)
    print("reading "..f)
    print("done reading")
  end
)

print()

sniper.scope(
  function(ctx)
    local f = open("my_file.lua")
    ctx.on_exit(function() close(f) end)
    ctx.on_success(function() print("success!") end)
    ctx.on_failure(function(e) print("failure! "..e) end)
    print("reading "..f)
    print("uh oh!")
    local x = nil + 2
    print("done reading")
  end
)
