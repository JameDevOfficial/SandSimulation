io.stdout:setvbuf("no")
if arg[2] == "debug" then
    require("lldebugger").start()
end