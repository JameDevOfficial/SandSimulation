M = {}
local colors = require("libs.colors")

local tempGrid
local element = "plant"
local replaceElements = { "empty" }

function M.plantCalculation(x, y)
    if Grid[y][x] ~= element then return end
    if MovedGrid[y][x] == 1 then return end

    for i, v in ipairs(replaceElements) do
        if y < GridFactor and Grid[y + 1][x] == v then 
            Grid[y + 1][x] = element
            Grid[y][x] = v
            MovedGrid[y + 1][x] = 1
            return
        end

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

function M.generateColorMapPlant(Grid, GridFactor)
    tempGrid = {}
    for y = 1, GridFactor do
        tempGrid[y] = {}
        for x = 1, GridFactor do
            tempGrid[y][x] = colors.setColorInRange({ 24, 123, 8 }, { 4, 163, 28 })
        end
    end
end

function M.getColorPlant(x, y)
    if tempGrid and tempGrid[y] then
        return tempGrid[y][x]
    end
    return nil
end

return M
