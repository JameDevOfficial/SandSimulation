M = {}
local colors = require("libs.colors")

local tempGrid
local element = "sand"

function M.sandCalculation(x, y)
    if Grid[y][x] ~= element then return end
    if MovedGrid[y][x] == 1 then return end
    --Prioritize falling down
    for i, v in ipairs(Data[element].replaceElements) do
        if y < GridFactor and Grid[y + 1][x] == v then
            Grid[y + 1][x] = element
            Grid[y][x] = v
            MovedGrid[y + 1][x] = 1
            NewActiveGrid[NewActiveCount] = { y + 1, x }
            NewActiveGrid[NewActiveCount] = { y, x }
            return
        end
    end
    --Falling diagonal
    for i, v in ipairs(Data[element].replaceElements) do
        if y < GridFactor and Grid[y + 1][x] == element then
            if x < GridFactor and Grid[y + 1][x + 1] == v then
                Grid[y][x] = v
                Grid[y + 1][x + 1] = element
                MovedGrid[y + 1][x + 1] = 1
                return
            elseif x > 1 and Grid[y + 1][x - 1] == v then
                Grid[y][x] = v
                Grid[y + 1][x - 1] = element
                MovedGrid[y + 1][x - 1] = 1
                return
            end
        end
    end
end

function M.generateColorMapSand(Grid, GridFactor)
    tempGrid = {}
    for y = 1, GridFactor do
        tempGrid[y] = {}
        for x = 1, GridFactor do
            tempGrid[y][x] = colors.setColorInRange({ 230, 200, 103 }, { 250, 220, 123 })
        end
    end
    return 1
end

function M.getColorSand(x, y)
    if tempGrid and tempGrid[y] then
        return tempGrid[y][x]
    end
    return nil
end

return M
