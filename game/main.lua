local lib = require("game.libs.lib")
local button = require("game.libs.button")

--Config Drawing
local gridFactor = 200
local padding = 0.
local waitTime = 0.0
local cursorSize = 5
local cursorRadius = (cursorSize - 1) / 2

--Config Mode
CurrentMode = "sand"
Buttons = { "empty", "sand" }

ButtonPadding = 10
ButtonHeight = 30
ButtonWidth = 100
ButtonY = 10

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
                love.graphics.setColor(250 / 255, 220 / 255, 137 / 255)
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
                grid[y + 1][x] = "sand"
                grid[y][x] = "empty"
            end
            if grid[y][x] == "sand" and grid[y+1][x] == "sand" then
                if grid[y + 1][x + 1] == "empty" then
                    grid[y][x] = "empty"
                    grid[y + 1][x + 1] = "sand"
                end
                if grid[y+1][x-1] == "empty" then
                    grid[y][x] = "empty"
                    grid[y + 1][x-1] = "sand"
                end
            end
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
        local cy, cx = getGridElementAtCursor(mx, my)
        --Draw in Cursor Radius
        if cy and cx then
            for dy = -cursorRadius, cursorRadius do
                for dx = -cursorRadius, cursorRadius do
                    if dx * dx + dy * dy <= cursorRadius * cursorRadius then
                        local ny, nx = cy + dy, cx + dx
                        if ny >= 1 and ny <= gridFactor and nx >= 1 and nx <= gridFactor then
                            grid[ny][nx] = CurrentMode
                        end
                    end
                end
            end
        end
    end
    lib.wait(waitTime)
end

drawGrid(true)
function love.draw()
    drawGrid()
    button.DrawButtons(screenWidth)
end