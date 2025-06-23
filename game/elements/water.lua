M = {}
local element = "water"
local replaceElements = { "empty" }
local waterDirections = {}

function M.waterCalculation(grid, gridFactor, x, y)
    if grid[y][x] ~= element then return end

    for i, v in ipairs(replaceElements) do
        if y<gridFactor and grid[y + 1][x] == v then -- floating
            grid[y + 1][x] = element
            grid[y][x] = v
            waterDirections[x..","..(y+1)] = waterDirections[x..","..y] or "r"
            waterDirections[x..","..y] = nil
            return
        end

        local dir = waterDirections[x..","..y] or "r"
        local moved = false
        if dir == "r" and grid[y][x + 1] == v and x < gridFactor then
            grid[y][x + 1] = element
            grid[y][x] = v
            moved = true
            waterDirections[(x+1)..","..y] = dir
            print("move right")
        elseif dir == "l" and x>1 and grid[y][x - 1] == v then
            grid[y][x - 1] = element
            grid[y][x] = v
            moved = true
            waterDirections[(x-1)..","..y] = dir
            print("move left")
        end

        if moved then
           waterDirections[x..","..y] = nil
        else
            if dir == "r" and (x == gridFactor or grid[y][x+1] ~= v) then
                waterDirections[x..","..y] = "l"
            elseif dir == "l" and (x == 1 or grid[y][x-1] ~= v) then
                waterDirections[x..","..y] = "r"
            end
        end
    end
end

return M