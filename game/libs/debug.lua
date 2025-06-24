local performance = require("game.libs.performance")

M = {}
local pressedDebug, lastPressedDebug = 0,0

local function saveGrid(gridFactor, grid)
    local bypassLimit = false

    print(pressedDebug .. ", " .. lastPressedDebug)
    if lastPressedDebug and (os.time() - lastPressedDebug) <= 1 and pressedDebug > 0 then
        bypassLimit = true
    else
        pressedDebug = 0
    end
    pressedDebug = pressedDebug + 1
    lastPressedDebug = os.time()

    if gridFactor <= 10 or bypassLimit then
        local filename = "grid_dump.txt"
        local file, err = io.open("game/" .. filename, "w")
        if not file then
            print("Failed to open file for writing: " .. tostring(err))
            return
        end
        local output = ""
        for y = 1, gridFactor do
            local row = {}
            for x = 1, gridFactor do
                table.insert(row, grid[y][x])
            end
            output = output .. table.concat(row, ",") .. "\n"
        end
        file:write(output)
        file:close()
        local fullPath = love.filesystem.getSaveDirectory() .. "/" .. filename
        print("Grid saved to " .. fullPath .. ":\n" .. output)
    else
        print("Grid too large to save (max 10x10).")
    end
end

local function pauseGame()
    if IsPaused ~= nil then
        IsPaused = not IsPaused
        print("Game paused:", IsPaused)
    end
end

function M.keypressed(k, gridFactor, grid)
    if k == 'f5' then
        saveGrid(gridFactor, grid)
    elseif k == 'f6' then
        pauseGame()
    elseif k == 'f7' then
        local avg = performance.getAvg()
        print("Avg: "..avg)
    elseif k == 'f8' then
        performance.saveToFile()
        performance.clearEntries()
        print("Performance entries saved and cleared.")
    end
end

return M