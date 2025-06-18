local gridFactor = 10
local padding = 10

local grid = {}
local screenWidth, screenHeight, minSize

screenWidth, screenHeight = love.graphics.getDimensions()
minSize = (screenHeight < screenWidth) and screenHeight or screenWidth
local cellSize = {
    x = ((minSize - padding * (gridFactor + 1)) / gridFactor),
    y = ((minSize - padding * (gridFactor + 1)) / gridFactor)
}

local drawGrid = function()
    for y = 1, gridFactor do
        grid[y] = {}
        for x = 1, gridFactor do
            local drawX = (x - 1) * (cellSize.x + padding) + padding
            local drawY = (y - 1) * (cellSize.y + padding) + padding
            love.graphics.rectangle("fill", drawX, drawY, cellSize.x, cellSize.y)
            grid[y][x] = "empty"
        end
    end
end

function love.resize()
    screenWidth, screenHeight = love.graphics.getDimensions()
    minSize = (screenHeight < screenWidth) and screenHeight or screenWidth
    cellSize = {
        x = ((minSize - padding * (gridFactor + 1)) / gridFactor),
        y = ((minSize - padding * (gridFactor + 1)) / gridFactor)
    }
    drawGrid()
end

function love.draw()
    drawGrid()
end