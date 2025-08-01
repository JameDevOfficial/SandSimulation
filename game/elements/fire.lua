M = {}
local colors = require("libs.colors")

local tempGrid
local element = "fire"
local replaceElements = { "plant" }
local replaceChance = 0.1

local function replaceElement(y, x, replace)
    if replace then
        Grid[y][x] = "fire"
    else
        Grid[y][x] = "empty"
    end
end

function M.fireCalculation(x, y)
    if Grid[y][x] ~= element then return end
    if MovedGrid[y][x] == 1 then return end
    local replace = math.random() <= replaceChance and true or false
    for _, v in ipairs(replaceElements) do
        -- above
        if y > 1 and Grid[y - 1][x] == v then
            replaceElement(y - 1, x, replace)
            -- below
        elseif y < #Grid and Grid[y + 1][x] == v then
            replaceElement(y + 1, x, replace)
            -- left
        elseif x > 1 and Grid[y][x - 1] == v then
            replaceElement(y, x - 1, replace)
            -- right
        elseif x < #Grid[1] and Grid[y][x + 1] == v then
            replaceElement(y, x + 1, replace)
            -- top left
        elseif y > 1 and x > 1 and Grid[y - 1][x - 1] == v then
            replaceElement(y - 1, x - 1, replace)
            -- top right
        elseif y > 1 and x < #Grid[1] and Grid[y - 1][x + 1] == v then
            replaceElement(y - 1, x + 1, replace)
            -- bottom left
        elseif y < #Grid and x > 1 and Grid[y + 1][x - 1] == v then
            replaceElement(y + 1, x - 1, replace)
            -- bottom right
        elseif y < #Grid and x < #Grid[1] and Grid[y + 1][x + 1] == v then
            replaceElement(y + 1, x + 1, replace)
        end
    end
end

function M.generateColorMapFire(Grid, GridFactor)
    tempGrid = {}
    for y = 1, GridFactor do
        tempGrid[y] = {}
        for x = 1, GridFactor do
            tempGrid[y][x] = colors.setColorInRange({ 24, 73, 48 }, { 44, 93, 68 })
        end
    end
end

function M.getColorFire(x, y)
    if tempGrid and tempGrid[y] then
        return tempGrid[y][x]
    end
    return nil
end

return M
