local lib = require("game.libs.lib")
local debug = require("game.libs.debug")
local performance = require("game.libs.performance")

local sand = require("game.elements.sand")
local water = require("game.elements.water")
local button = require("game.libs.ui.button")
local textLabel = require("game.libs.ui.textLabel")

local BLACK = {0,0,0,1}
local debugInfo = "[F5] - Save Grid\n[F6] - Pause/Play\n[F7] - Save Avg DT\n"

DEBUG = true

--Config Drawing
GridFactor = 100
local padding = 0.
local waitTime = 0.
local cursorSize = 5
local cursorRadius = (cursorSize - 1) / 2

--Config Mode
CurrentMode = "sand"
Buttons = { "empty", "sand", "water", "wall" }
Elements = {
    ["empty"] = nil,
    ["sand"] = sand.sandCalculation,
    ["water"] = water.waterCalculation,
    ["wall"] = nil,
}

ButtonPadding = 10
ButtonHeight = 30
ButtonWidth = 100
ButtonY = 10

IsPaused = false
Grid = {}
local screenWidth, screenHeight, minSize

screenWidth, screenHeight = love.graphics.getDimensions()
minSize = (screenHeight < screenWidth) and screenHeight or screenWidth
local cellSize = {
    x = ((minSize - padding * (GridFactor + 1)) / GridFactor),
    y = ((minSize - padding * (GridFactor + 1)) / GridFactor)
}
local xCenter, xStart = 0,0

local drawGrid = function(emptyAll)
    for y = 1, GridFactor do
        Grid[y] = Grid[y] or {}
        for x = 1, GridFactor do
            if emptyAll == true then
                Grid[y][x] = "empty"
                goto continue
            end
            Grid[y][x] = Grid[y][x] or "empty"
            local drawX = (x - 1) * (cellSize.x + padding) + padding + xStart
            local drawY = (y - 1) * (cellSize.y + padding) + padding
            if Grid[y][x] == "sand" then
                love.graphics.setColor(250 / 255, 220 / 255, 137 / 255)
            elseif Grid[y][x] == "water" then
                love.graphics.setColor(84 / 255, 151 / 255, 240 / 255)
            elseif Grid[y][x] == "wall" then
                love.graphics.setColor(199 / 255, 200 / 255, 201 / 255)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.rectangle("fill", drawX, drawY, cellSize.x, cellSize.y)
            ::continue::
        end
    end
end

function love.resize()
    screenWidth, screenHeight = love.graphics.getDimensions()
    minSize = (screenHeight < screenWidth) and screenHeight or screenWidth
    cellSize = {
        x = ((minSize - padding * (GridFactor + 1)) / GridFactor),
        y = ((minSize - padding * (GridFactor + 1)) / GridFactor)
    }
    xCenter = math.floor(screenWidth / 2)
    xStart = xCenter - (GridFactor / 2) * cellSize.x
    drawGrid()
end

local function getGridElementAtCursor(mx, my)
    for y = 1, GridFactor+1 do
        for x = 1, GridFactor+1 do
            local cellX = (x - 1) * (cellSize.x + padding) + padding
            local cellY = (y - 1) * (cellSize.y + padding) + padding
            if mx >= cellX and mx <= cellX + cellSize.x and my >= cellY and my <= cellY + cellSize.y then
                return y, x
            end
        end
    end
end

local function drawAtCursor()
    local mx, my = love.mouse.getPosition()
    mx = mx - xStart
    local cy, cx = getGridElementAtCursor(mx, my)
    --Draw in Cursor Radius
    if mx > minSize or mx < 0 or my > minSize or my < 0 then
        return
    end
    if not cy and cx then return end
    for dy = -cursorRadius, cursorRadius do
        for dx = -cursorRadius, cursorRadius do
            if dx * dx + dy * dy <= cursorRadius * cursorRadius then
                local ny, nx = cy + dy, cx + dx
                if ny >= 1 and ny <= GridFactor and nx >= 1 and nx <= GridFactor then
                    Grid[ny] = Grid[ny] or {}
                    if Grid[ny][nx] ~= "empty" and CurrentMode ~= "empty" then return end
                    Grid[ny][nx] = CurrentMode
                end
            end
        end
    end
end

function love.update(dt)
    if IsPaused then return end
    performance.addEntry(dt)
    for y = GridFactor - 1, 1, -1 do
        for x = 1, GridFactor do
            local elementFunc = Elements[Grid[y][x]]
            if elementFunc then
                elementFunc(x,y)
            end
        end
    end

    if love.mouse.isDown(1) then
        drawAtCursor()
    end
    lib.wait(waitTime)
end

function love.keypressed(k)
    debug.keypressed(k, GridFactor, Grid)
end

drawGrid(true)
function love.draw()
    drawGrid()
    button.DrawButtons(minSize, xStart)
    textLabel.drawText(performance.getFPS(), xStart, 0, nil, BLACK)
    if not DEBUG then return end
    textLabel.drawText(debugInfo, xStart, 20, nil, BLACK)
end

