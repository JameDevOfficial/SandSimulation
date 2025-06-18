local lib = require("lib")

local gridFactor = 100
local padding = 1
local waitTime = 0.01

local grid = {}
local screenWidth, screenHeight, minSize

screenWidth, screenHeight = love.graphics.getDimensions()
minSize = (screenHeight < screenWidth) and screenHeight or screenWidth
local cellSize = {
    x = ((minSize - padding * (gridFactor + 1)) / gridFactor),
    y = ((minSize - padding * (gridFactor + 1)) / gridFactor)
}

local drawGrid = function(emptyAll)
    for y = 1, gridFactor do
        grid[y] = grid[y] or {}
        for x = 1, gridFactor do
            grid[y][x] = grid[y][x] or "empty"
            local drawX = (x - 1) * (cellSize.x + padding) + padding
            local drawY = (y - 1) * (cellSize.y + padding) + padding
            if grid[y][x] == "sand" then
                love.graphics.setColor(250/255, 220/255, 137/255)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.rectangle("fill", drawX, drawY, cellSize.x, cellSize.y)
            if emptyAll == true then
                grid[y][x] = "empty"
            end
        end
    end
end

local sandCalculation = function()
    for y = gridFactor - 1, 1, -1 do
        for x = 1, gridFactor do
            if grid[y][x] == "sand" and grid[y + 1][x] == "empty" then
                grid[y+1][x] = "sand"
                grid[y][x] = "empty"
            end
        end
    end
end

--[[
function love.mousepressed(x, y, button)
    if button ~= 1 then
        return
    end
    for row = 1, gridFactor do
        for col = 1, gridFactor do
            local cellX = (col - 1) * (cellSize.x + padding) + padding
            local cellY = (row - 1) * (cellSize.y + padding) + padding
            if x >= cellX and x <= cellX + cellSize.x and y >= cellY and y <= cellY + cellSize.y then
                grid[row][col] = "sand"
                print("set ("..row.."|"..col..") to sand")
            end
        end
    end
end
]]

function love.resize()
    screenWidth, screenHeight = love.graphics.getDimensions()
    minSize = (screenHeight < screenWidth) and screenHeight or screenWidth
    cellSize = {
        x = ((minSize - padding * (gridFactor + 1)) / gridFactor),
        y = ((minSize - padding * (gridFactor + 1)) / gridFactor)
    }
    drawGrid()
end

local function getGridElementAtCursor(mx, my)
    for y = 1, gridFactor do
        for x = 1, gridFactor do
            local cellX = (x - 1) * (cellSize.x + padding) + padding
            local cellY = (y - 1) * (cellSize.y + padding) + padding
            if mx >= cellX and mx <= cellX + cellSize.x and my >= cellY and my <= cellY + cellSize.y then
                print("(" .. y .. "|" .. x .. ")")
                return y, x
            end
        end
    end
end

function love.update(dt)
    sandCalculation()
    if love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        local y, x = getGridElementAtCursor(mx, my)
        if y and x then
            grid[y][x] = "sand"
        end
    end
    lib.wait(waitTime)
end

drawGrid(true)
function love.draw()
    drawGrid()
end