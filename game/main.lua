local lib = require("libs.lib")
local debug = require("libs.debug")
local performance = require("libs.performance")
local suit = require("libs.suit")
local sand = require("elements.sand")
local water = require("elements.water")
local button = require("libs.ui.button")
local textLabel = require("libs.ui.textLabel")

local input = { text = "" }
local debugInfo = "[F5] - Save Grid\n[F6] - Pause/Play\n[F7] - Save Avg DT\n"

IsPaused = false
Grid = {}

BLACK = { 0, 0, 0, 1 }
CurrentMode = "sand"
Buttons = { "empty", "sand", "water", "wall", "plant", "test", "Test", "TTest", "TTTETS" }
Regular = love.graphics.newFont("fonts/Rubik-Regular.ttf")
Medium = love.graphics.newFont("fonts/Rubik-Medium.ttf")
Light = love.graphics.newFont("fonts/Rubik-Light.ttf")
Bold = love.graphics.newFont("fonts/Rubik-Bold.ttf")

--Config
DEBUG = true
GridFactor = 100
MovedGrid = {}

--UI
ButtonWidth = 90
ButtonHeight = 30
ButtonPadding = 10
local labelStyle = {
    normal  = { bg = { 0.25, 0.25, 0.25 }, fg = { 0.1, 0.1, 0.1 } },
    hovered = { bg = { 0.19, 0.6, 0.73 }, fg = { 1, 1, 1 } },
    active  = { bg = { 1, 0.6, 0 }, fg = { 1, 1, 1 } }
}

local buttonStyle = {
    normal  = { bg = { 0.25, 0.25, 0.25 }, fg = { 0.73, 0.73, 0.73 } },
    hovered = { bg = { 0.19, 0.6, 0.73 }, fg = { 1, 1, 1 } },
    active  = { bg = { 1, 0.6, 0 }, fg = { 1, 1, 1 } }
}

local screenWidth, screenHeight, minSize
local padding = 0.
local waitTime = 0.
local cursorSize = 5
local cursorRadius = (cursorSize - 1) / 2

screenWidth, screenHeight = love.graphics.getDimensions()
minSize = (screenHeight < screenWidth) and screenHeight or screenWidth
local cellSize = {
    x = ((minSize - padding * (GridFactor + 1)) / GridFactor),
    y = ((minSize - padding * (GridFactor + 1)) / GridFactor)
}
local xCenter, xStart = 0, 0

ResetMovementGrid = function()
    for y = 1, GridFactor do
        MovedGrid[y] = {}
        for x = 1, GridFactor do
            MovedGrid[y][x] = 0
        end
    end
end

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
    for y = 1, GridFactor + 1 do
        for x = 1, GridFactor + 1 do
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

function love.load()
    drawGrid(true)
    love.graphics.setFont(Regular)
end

function love.update(dt)
    if IsPaused then return end
    performance.addEntry(dt)
    ResetMovementGrid()
    for y = GridFactor - 1, 1, -1 do
        for x = 1, GridFactor do
            sand.sandCalculation(x, y)
            water.waterCalculation(x, y)
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

local function drawUi()
    local availableWidth = minSize - 300
    local buttonsPerRow = math.floor((availableWidth + ButtonPadding) / (ButtonWidth + ButtonPadding))
    if buttonsPerRow < 1 then buttonsPerRow = 1 end
    --Element Buttons
    suit.layout:reset(
        ((screenWidth - minSize) / 2) +
        ((minSize - (buttonsPerRow * ButtonWidth + (buttonsPerRow - 1) * ButtonPadding)) / 2),
        0, ButtonPadding)
    suit.theme.color.normal.fg = { 0.73, 0.73, 0.73 }
    local RowCount = 0
    for i, v in ipairs(Buttons) do
        if RowCount > 0 and RowCount % buttonsPerRow == 0 then
            
        end
        RowCount = RowCount + 1
        if suit.Button(v, suit.layout:col(ButtonWidth, ButtonHeight)).hit then
            CurrentMode = v
        end
    end
    --Text Labels
    suit.theme.color.normal.fg = { 0, 0, 0 }
    suit.layout:reset((screenWidth - minSize) / 2, 0, ButtonPadding)
    suit.Label(performance.getFPS(), { align = "left" }, suit.layout:row(200, 30))
    suit.layout:reset((screenWidth - minSize) / 2, 0, ButtonPadding)
    suit.Label("Current Mode: " .. CurrentMode, { align = "right" }, suit.layout:row(minSize, 30))
    if not DEBUG then return end
    suit.Label(debugInfo, { align = "left" }, suit.layout:row())
end

function love.draw()
    drawGrid()
    drawUi()
    suit.draw()
end
