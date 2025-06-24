local M = {}

TimeHistory = {}
Entries = 0

M.addEntry = function(dt)
    Entries = Entries + 1
    TimeHistory[Entries] = dt
    if Entries >= 1000 then
        M.clearEntries()
    end
end

M.getAvg = function()
    if Entries == 0 then return 0 end
    local sum = 0
    print("Entries: ".. Entries)
    for i = 1, Entries do
        sum = sum + TimeHistory[i]
    end
    local avg = sum / Entries
    return avg
end

M.saveToFile = function()
    local filename = "avg_times_history.txt"
        local file, err = io.open("game/" .. filename, "a")
        if not file then
            print("Failed to open file for writing: " .. tostring(err))
            return
        end
    local output = tostring(M.getAvg()).."\n"

    file:write(output)
    file:close()
    local fullPath = love.filesystem.getSaveDirectory() .. "/" .. filename
    print("Grid saved to " .. fullPath .. ":\n" .. output)
end

M.getEntriesCount = function()
    return Entries
end

M.clearEntries = function ()
    TimeHistory = {}
    Entries = 0
end

M.getFPS = function ()
    local totalTime, i = 0, 0
    while totalTime < 1 and i < Entries do
        totalTime = totalTime + TimeHistory[Entries - i]
        i = i + 1
    end
    return i
end

return M