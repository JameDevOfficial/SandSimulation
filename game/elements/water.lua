M = {}
local colors = require("libs.colors")

local element = "water"
local replaceElements = { "empty" }
local tempGrid

function M.waterCalculation(x, y)
    if Grid[y][x] ~= element then return end
    if MovedGrid[y][x] == 1 then return end

    for i, v in ipairs(replaceElements) do
        if y < GridFactor and Grid[y + 1][x] == v then
            Grid[y + 1][x] = element
            Grid[y][x] = v
            MovedGrid[y + 1][x] = 1
            return
        end

        local canMoveLeft = x > 1 and Grid[y][x - 1] == "empty"
        local canMoveRight = x < GridFactor and Grid[y][x + 1] == "empty"
    
        if canMoveLeft and canMoveRight then
            if math.random(0,1) == 0 then
                Grid[y][x + 1] = element
                Grid[y][x] = v
                MovedGrid[y][x + 1] = 1
            else
                Grid[y][x - 1] = element
                Grid[y][x] = v
                MovedGrid[y][x - 1] = 1
            end
        elseif canMoveRight then
            Grid[y][x + 1] = element
            Grid[y][x] = v
            MovedGrid[y][x+1] = 1
        elseif canMoveLeft then
            Grid[y][x - 1] = element
            Grid[y][x] = v
            MovedGrid[y][x-1] = 1
        end
    end
end

return M