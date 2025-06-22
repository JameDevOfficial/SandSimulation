M = {}
local pressedDebug, lastPressedDebug = 0,0

function M.keypressed(k, gridFactor, grid)
    local bypassLimit = false
    if k == 'f5' then
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
end

return M