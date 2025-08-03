M = {}
local colors = require("libs.colors")

local element = "water"
local replaceElements = { "empty", "fire" }
local tempGrid

function M.waterCalculation(x, y)
    if Grid[y][x] ~= element then return end
    if MovedGrid[y][x] == 1 then return end

    if y < GridFactor then
        local below = Grid[y + 1][x]
        if below == "empty" or below == "fire" then
            Grid[y + 1][x] = element
            Grid[y][x] = "empty"
            MovedGrid[y + 1][x] = 1
            return
        end
    end

    local canMoveDownLeft = y < GridFactor and x > 1 and
        (Grid[y + 1][x - 1] == "empty" or Grid[y + 1][x - 1] == "fire")
    local canMoveDownRight = y < GridFactor and x < GridFactor and
        (Grid[y + 1][x + 1] == "empty" or Grid[y + 1][x + 1] == "fire")

    if canMoveDownLeft and canMoveDownRight then
        if math.random(0, 1) == 0 then
            Grid[y + 1][x - 1] = element
            Grid[y][x] = "empty"
            MovedGrid[y + 1][x - 1] = 1
        else
            Grid[y + 1][x + 1] = element
            Grid[y][x] = "empty"
            MovedGrid[y + 1][x + 1] = 1
        end
        return
    elseif canMoveDownLeft then
        Grid[y + 1][x - 1] = element
        Grid[y][x] = "empty"
        MovedGrid[y + 1][x - 1] = 1
        return
    elseif canMoveDownRight then
        Grid[y + 1][x + 1] = element
        Grid[y][x] = "empty"
        MovedGrid[y + 1][x + 1] = 1
        return
    end

    local canMoveLeft = x > 1 and (Grid[y][x - 1] == "empty" or Grid[y][x - 1] == "fire")
    local canMoveRight = x < GridFactor and (Grid[y][x + 1] == "empty" or Grid[y][x + 1] == "fire")

    if canMoveLeft and canMoveRight then
        if math.random(0, 1) == 0 then
            Grid[y][x + 1] = element
            Grid[y][x] = "empty"
            MovedGrid[y][x + 1] = 1
        else
            Grid[y][x - 1] = element
            Grid[y][x] = "empty"
            MovedGrid[y][x - 1] = 1
        end
    elseif canMoveRight then
        Grid[y][x + 1] = element
        Grid[y][x] = "empty"
        MovedGrid[y][x + 1] = 1
    elseif canMoveLeft then
        Grid[y][x - 1] = element
        Grid[y][x] = "empty"
        MovedGrid[y][x - 1] = 1
    end
end

return M
