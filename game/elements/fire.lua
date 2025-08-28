M = {}
local colors = require("libs.colors")

local tempGrid
local element = "fire"
local replaceElements = { "plant" }
local replaceChance = 0.1
local vanishChance = 0.1

local function replaceElement(y, x, replace)
    if replace then
        Grid[y][x] = "fire"
    else
        Grid[y][x] = "plant"
    end
end

function M.fireCalculation(x, y)
    if Grid[y][x] ~= element then return end
    if MovedGrid[y][x] == 1 then return end
    
    local replaceRandom = math.random()
    local vanishRandom = math.random()
    
    local replace = replaceRandom <= replaceChance
    
    local neighbors = {}
    if y > 1 and Grid[y - 1][x] == "plant" then
        table.insert(neighbors, {y - 1, x})
    end
    if y < GridFactor and Grid[y + 1][x] == "plant" then
        table.insert(neighbors, {y + 1, x})
    end
    if x > 1 and Grid[y][x - 1] == "plant" then
        table.insert(neighbors, {y, x - 1})
    end
    if x < GridFactor and Grid[y][x + 1] == "plant" then
        table.insert(neighbors, {y, x + 1})
    end
    if y > 1 and x > 1 and Grid[y - 1][x - 1] == "plant" then
        table.insert(neighbors, {y - 1, x - 1})
    end
    if y > 1 and x < GridFactor and Grid[y - 1][x + 1] == "plant" then
        table.insert(neighbors, {y - 1, x + 1})
    end
    if y < GridFactor and x > 1 and Grid[y + 1][x - 1] == "plant" then
        table.insert(neighbors, {y + 1, x - 1})
    end
    if y < GridFactor and x < GridFactor and Grid[y + 1][x + 1] == "plant" then
        table.insert(neighbors, {y + 1, x + 1})
    end

    if #neighbors > 0 then
        local targetNeighbor = neighbors[math.random(1, #neighbors)]
        replaceElement(targetNeighbor[1], targetNeighbor[2], replace)
        MovedGrid[y][x] = 1
        return
    end
    
    local vanish = vanishRandom <= vanishChance
    if y >= 2 and Grid[y - 1][x] == "empty" and not vanish then
        Grid[y - 1][x] = "fire"
        Grid[y][x] = "empty"
        MovedGrid[y - 1][x] = 1
    elseif vanish then
        Grid[y][x] = "empty"
    end
    
    MovedGrid[y][x] = 1
end

function M.generateColorMapFire(Grid, GridFactor)
    tempGrid = {}
    for y = 1, GridFactor do
        tempGrid[y] = {}
        for x = 1, GridFactor do
            tempGrid[y][x] = colors.setColorInRange({ 181, 66, 13 }, { 222, 146, 31 })
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
