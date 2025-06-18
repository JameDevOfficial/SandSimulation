local M = {}
M.wait = function(s)
    local ntime = os.clock() + s / 10
    repeat until os.clock() > ntime
end

return M