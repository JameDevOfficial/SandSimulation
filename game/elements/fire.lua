M = {}
local colors = require("libs.colors")

local tempGrid
local element = "fire"
local vanishChance = 0.2

local function replaceElement(y, x, replace, oldElement)
    if replace then
        Grid[y][x] = element
    else
        Grid[y][x] = oldElement
    end
end

function M.fireCalculation(x, y)
    if Grid[y][x] ~= element then return end
    if MovedGrid[y][x] == 1 then return end
    for i, v in ipairs(Data[element].replaceElements) do
        local replaceRandom = math.random()
        local vanishRandom = math.random()
        local replace = replaceRandom <= Data[v].burnChance

        local neighbors = {}
        for dy = -1, 1 do
            for dx = -1, 1 do
                if not (dy == 0 and dx == 0) then
                    local ny, nx = y + dy, x + dx
                    if ny >= 1 and ny <= GridFactor and nx >= 1 and nx <= GridFactor then
                        if Grid[ny][nx] == v then
                            table.insert(neighbors, { ny, nx })
                        end
                    end
                end
            end
        end

        if #neighbors > 0 then
            local targetNeighbor = neighbors[math.random(1, #neighbors)]
            replaceElement(targetNeighbor[1], targetNeighbor[2], replace, v)
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
            local spawnAsh = math.random(0, 10)
            if spawnAsh == 0 then
                if y < GridFactor and Grid[y + 1][x] == "empty" then
                    Grid[y][x] = "ash"
                end
            end
        end

        MovedGrid[y][x] = 1
    end
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
