M = {}
local element = "water"
local replaceElements = { "empty" }
local waterDirections = {}

function M.clearDirections()
    waterDirections = {}
end

function M.waterCalculation(x, y)
    if Grid[y][x] ~= element then return end
    if MovedGrid[y][x] == 1 then return end

    for i, v in ipairs(replaceElements) do
        if y < GridFactor and Grid[y + 1][x] == v then
            Grid[y + 1][x] = element
            Grid[y][x] = v
            waterDirections[x..","..(y+1)] = waterDirections[x..","..y] or "r"
            waterDirections[x .. "," .. y] = nil
            MovedGrid[y+1][x] = 1
            print("move down")
            return
        end

        local dir = waterDirections[x..","..y] or "r"
        local moved = false
        if dir == "r" and x < GridFactor and Grid[y][x + 1] == v then
            Grid[y][x + 1] = element
            Grid[y][x] = v
            moved = true
            waterDirections[(x + 1) .. "," .. y] = dir
            MovedGrid[y][x+1] = 1
            print("move right")
        elseif dir == "l" and x > 1 and Grid[y][x - 1] == v then
            Grid[y][x - 1] = element
            Grid[y][x] = v
            moved = true
            waterDirections[(x-1)..","..y] = dir
            MovedGrid[y][x-1] = 1
            print("move left")
        end

        if moved then
            waterDirections[x..","..y] = nil
        else
            if dir == "r" then
                waterDirections[x..","..y] = "l"
            else
                waterDirections[x..","..y] = "r"
            end
        end
    end
end

return M