local lib = require("libs.lib")
local debug = require("libs.debug")
local performance = require("libs.performance")
local suit = require("libs.suit")
local sand = require("elements.sand")
local water = require("elements.water")
local plant = require("elements.plant")
local colors = require("libs.colors")

local debugInfo = "[F5] - Save Grid\n[F6] - Pause/Play\n[F7] - Save Avg DT\n"

IsPaused = false
Grid = {}
ButtonRows = 0

BLACK = { 0, 0, 0, 1 }
CurrentMode = "sand"
Buttons = { "empty", "sand", "water", "wall", "plant" }
ButtonColors = {
    ["empty"] = {0.9, 0.9, 0.9},  -- Light gray
    ["sand"] = {0.9, 0.8, 0.5},   -- Sandy color
    ["water"] = {0.3, 0.6, 0.9},  -- Blue
    ["wall"] = {0.4, 0.4, 0.4},   -- Dark gray
    ["plant"] = {0.2, 0.5, 0.2},  -- Green
}

Regular = love.graphics.newFont("fonts/Rubik-Regular.ttf")
Medium = love.graphics.newFont("fonts/Rubik-Medium.ttf")
Light = love.graphics.newFont("fonts/Rubik-Light.ttf")
Bold = love.graphics.newFont("fonts/Rubik-Bold.ttf")

--Config
DEBUG = true
GridFactor = 150
MovedGrid = {}

--UI
ButtonWidth = 90
ButtonHeight = 30
ButtonPadding = 10

local screenWidth, screenHeight, minSize
local padding = 0.
local waitTime = 0.
local cursorSize = 13
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
            else
                Grid[y][x] = Grid[y][x] or "empty"
                local drawX = (x - 1) * (cellSize.x + padding) + padding + xStart
                local drawY = (y - 1) * (cellSize.y + padding) + padding
                if Grid[y][x] == "sand" then
                    local sandColor = sand.getColorSand(x, y) or { 194 / 255, 178 / 255, 128 / 255, 1 }
                    love.graphics.setColor(sandColor)
                elseif Grid[y][x] == "water" then
                    local waterColor = colors.setColorInRange({ 84, 151, 235 }, { 104, 171, 255 })
                    love.graphics.setColor(waterColor)
                elseif Grid[y][x] == "wall" then
                    love.graphics.setColor(199 / 255, 200 / 255, 201 / 255)
                elseif Grid[y][x] == "plant" then
                    local plantColor = plant.getColorPlant(x, y) or { 24 / 255, 163 / 255, 8 / 255, 1 }
                    love.graphics.setColor(plantColor)
                else
                    love.graphics.setColor(1, 1, 1)
                end
                love.graphics.rectangle("fill", drawX, drawY, cellSize.x, cellSize.y)
            end
        end
    end
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
            if (dx + 0.5) ^ 2 + (dy + 0.5) ^ 2 <= cursorRadius * cursorRadius then
                local ny, nx = cy + dy, cx + dx
                if ny >= 1 and ny <= GridFactor and nx >= 1 and nx <= GridFactor then
                    Grid[ny] = Grid[ny] or {}
                    if Grid[ny][nx] == "empty" or CurrentMode == "empty" then
                        Grid[ny][nx] = CurrentMode
                    end
                end
            end
        end
    end
end

local function drawUi()
    local availableWidth = minSize - 300
    local buttonsPerRow = math.floor((availableWidth + ButtonPadding) / (ButtonWidth + ButtonPadding))
    if buttonsPerRow < 1 then buttonsPerRow = 1 end

    --Element Buttons
    local buttonCount = 0
    ButtonRows = 0

    suit.layout:reset(
        ((screenWidth - minSize) / 2) +
        ((minSize - (buttonsPerRow * ButtonWidth + (buttonsPerRow - 1) * ButtonPadding)) / 2),
        0, ButtonPadding)

    for i, v in ipairs(Buttons) do
        if buttonCount > 0 and buttonCount % buttonsPerRow == 0 then
            ButtonRows = ButtonRows + 1
            suit.layout:reset(
                ((screenWidth - minSize) / 2) +
                ((minSize - (buttonsPerRow * ButtonWidth + (buttonsPerRow - 1) * ButtonPadding)) / 2),
                ButtonRows * (ButtonHeight + ButtonPadding), ButtonPadding)
        end
        buttonCount = buttonCount + 1

        if suit.Button(v, colors.getButtonOpt(v), suit.layout:col(ButtonWidth, ButtonHeight)).hit then
            CurrentMode = v
        end
    end

    --Text Labels
    suit.layout:reset((screenWidth - minSize) / 2, 0, ButtonPadding)
    suit.Label(performance.getFPS(), { align = "left" }, suit.layout:row(200, 30))
    suit.layout:reset((screenWidth - minSize) / 2, 0, ButtonPadding)
    suit.Label("Current Mode: " .. CurrentMode, { align = "right" }, suit.layout:row(minSize, 30))
    if not DEBUG then return end
    suit.Label(debugInfo, { align = "left" }, suit.layout:row())
end

--Load
function love.load()
    sand.generateColorMapSand(Grid, GridFactor)
    plant.generateColorMapPlant(Grid, GridFactor)
    drawGrid(true)
    love.graphics.setFont(Regular)
    suit.theme.color.normal.fg = { 0, 0, 0 }
end

--Draw
function love.draw()
    drawGrid()
    drawUi()
    suit.draw()
end

--Update
local direction = -1
function love.update(dt)
    if IsPaused then return end
    performance.addEntry(dt)
    ResetMovementGrid()
    local startValue = direction == -1 and GridFactor - 1 or 1
    local endValue = direction == -1 and 1 or GridFactor
    for y = startValue, endValue, direction do
        local xStart, xEnd, xStep
        if y % 2 == 0 then
            xStart, xEnd, xStep = 1, GridFactor, 1
        else
            xStart, xEnd, xStep = GridFactor, 1, -1
        end

        for x = xStart, xEnd, xStep do
            local cell = Grid[y] and Grid[y][x]
            if cell == "sand" then
                sand.sandCalculation(x, y)
            elseif cell == "water" then
                water.waterCalculation(x, y)
            elseif cell == "plant" then
                plant.plantCalculation(x, y)
            end
        end
    end

    direction = -direction
    if love.mouse.isDown(1) and not suit.mouseInRect(0, 0, screenWidth, (ButtonRows + 1) * (ButtonHeight + ButtonPadding)) then
        drawAtCursor()
    end
    lib.wait(waitTime)
end

--Keypressed
function love.keypressed(k)
    debug.keypressed(k, GridFactor, Grid)
end

--Resized
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
