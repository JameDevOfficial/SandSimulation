local lib = require("libs.lib")
local debug = require("libs.debug")
local performance = require("libs.performance")
local suit = require("libs.suit")
local elements = {
    sand = require("elements.sand"),
    water = require("elements.water"),
    plant = require("elements.plant"),
    fire = require("elements.fire"),
    ash = require("elements.ash"),
    dust = require("elements.dust"),
    -- Add new elements here
}
local colors = require("libs.colors")

local debugInfo = "[F5] - Save Grid\n[F6] - Pause/Play\n[F7] - Save Avg DT\n"

IsPaused = false
Grid = {}
ButtonRows = 0
ButtonHovered = false

ActiveGrid = {}
NewActiveGrid = {}
ActiveCount = 0
NewActiveCount = 0

BLACK = { 0, 0, 0, 1 }
CurrentMode = "sand"
Buttons = { "empty", "sand", "water", "wall", "plant", "fire", "ash", "dust" }
ButtonColors = {
    ["empty"] = { 0.8, 0.8, 0.8 },
    ["sand"] = { 0.9, 0.8, 0.5 },
    ["water"] = { 0.3, 0.6, 0.9 },
    ["wall"] = { 0.5, 0.5, 0.5 },
    ["plant"] = { 0.2, 0.5, 0.2 },
    ["fire"] = { 0.7, 0.2, 0.2 },
    ["ash"] = { 0.6, 0.6, 0.6 },
    ["dust"] = { 240 / 255, 155 / 255, 250 / 255 },
}
Regular = love.graphics.newFont("fonts/Rubik-Regular.ttf")
Medium = love.graphics.newFont("fonts/Rubik-Medium.ttf")
Light = love.graphics.newFont("fonts/Rubik-Light.ttf")
Bold = love.graphics.newFont("fonts/Rubik-Bold.ttf")

--Config
DEBUG = false
GridFactor = 150
MovedGrid = {}

--UI
ButtonWidth = 90
ButtonHeight = 30
ButtonPadding = 10

local screenWidth, screenHeight, minSize
local padding = 0.
local waitTime = 0.
local cursorSize = 5
local input = { text = "" }

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

local setPixelImageData = love.image.newImageData(GridFactor + 1, GridFactor + 1)
local setPixelImage = love.graphics.newImage(setPixelImageData)
local elementPixels = minSize / GridFactor
local actualImageSize, pixelsPerElement

setPixelImage:setFilter("nearest", "nearest")
print(elementPixels, minSize, GridFactor)

local drawGrid = function(emptyAll)
    for y = 1, GridFactor do
        Grid[y] = Grid[y] or {}
        for x = 1, GridFactor do
            if emptyAll == true then
                Grid[y][x] = "empty"
            else
                Grid[y][x] = Grid[y][x] or "empty"
                -- Experimental rendering inspired by https://github.com/KINGTUT10101/PixelRenderingComparison
                local color
                if Grid[y][x] == "sand" then
                    color = elements.sand.getColorSand(x, y) or { 194 / 255, 178 / 255, 128 / 255, 1 }
                elseif Grid[y][x] == "water" then
                    color = colors.setColorInRange({ 84, 151, 235 }, { 104, 171, 255 })
                elseif Grid[y][x] == "wall" then
                    color = { 199 / 255, 200 / 255, 201 / 255, 1 }
                elseif Grid[y][x] == "plant" then
                    color = elements.plant.getColorPlant(x, y) or { 24 / 255, 163 / 255, 8 / 255, 1 }
                elseif Grid[y][x] == "fire" then
                    color = elements.fire.getColorFire(x, y) or { 24 / 255, 163 / 255, 8 / 255, 1 }
                elseif Grid[y][x] == "ash" then
                    color = elements.ash.getColorAsh(x, y) or { 24 / 255, 163 / 255, 8 / 255, 1 }
                elseif Grid[y][x] == "dust" then
                    color = elements.dust.getColorDust(x, y) or { 24 / 255, 163 / 255, 8 / 255, 1 }
                else
                    color = { 1, 1, 1, 1 }
                end

                setPixelImageData:setPixel(x - 1, y - 1, color[1], color[2], color[3], color[4] or 1)
            end
        end
    end
    setPixelImage:replacePixels(setPixelImageData)
    local scale = minSize / GridFactor
    love.graphics.draw(setPixelImage, xStart, 0, 0, scale, scale)
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

    local radius = math.floor(cursorSize / 2)
    local radiusSquared = radius * radius
    for dy = -radius, radius do
        for dx = -radius, radius do
            if (dx) ^ 2 + (dy) ^ 2 <= radiusSquared then
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
        local text = v
        text = v:sub(1, 1):upper() .. v:sub(2)
        local btn = suit.Button(text, colors.getButtonOpt(v), suit.layout:col(ButtonWidth, ButtonHeight))
        if btn.hit then
            CurrentMode = v
        end
        if btn.hovered then
            ButtonHovered = true
        end
    end

    suit.layout:reset((screenWidth - minSize) / 2 + ButtonPadding, 0, ButtonPadding)
    local btnPlus = suit.Button("+", colors.getButtonOpt(), suit.layout:col(ButtonHeight, ButtonHeight))
    local cursorSizeLabel = suit.Label(cursorSize, suit.layout:col(ButtonHeight, ButtonHeight))
    local btnMinus = suit.Button("-", colors.getButtonOpt(), suit.layout:col(ButtonHeight, ButtonHeight))
    if btnPlus.hit then
        if cursorSize >= 50 then
            return
        end
        cursorSize = cursorSize + 1
    end
    if btnMinus.hit then
        if cursorSize <= 1 then
            return
        end
        cursorSize = cursorSize - 1
    end
    if btnPlus.hovered then
        ButtonHovered = true
    end
    if btnMinus.hovered then
        ButtonHovered = true
    end
    --Text Labels
    suit.layout:reset((screenWidth - minSize) / 2, 0, ButtonPadding)
    suit.layout:reset((screenWidth - minSize) / 2, 0, 0)
    suit.Label(performance.getFPS(), { align = "right" }, suit.layout:row(minSize, 30))
    if not DEBUG then return end
    suit.Label("Current Mode: " .. CurrentMode, { align = "left" }, suit.layout:row(minSize, 30))
    suit.Label(debugInfo, { align = "left" }, suit.layout:row())
end

--Load
function love.load()
    elements.sand.generateColorMapSand(Grid, GridFactor)
    elements.plant.generateColorMapPlant(Grid, GridFactor)
    elements.fire.generateColorMapFire(Grid, GridFactor)
    elements.ash.generateColorMapAsh(Grid, GridFactor)
    elements.dust.generateColorMapDust(Grid, GridFactor)
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
    -- Accumulate time for fixed updates
    love.accumulatedTime = (love.accumulatedTime or 0) + dt
    local fixedDt = 1 / 60 -- Target 60 updates per second
    while love.accumulatedTime >= fixedDt do
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
                    elements.sand.sandCalculation(x, y)
                elseif cell == "water" then
                    elements.water.waterCalculation(x, y)
                elseif cell == "plant" then
                    elements.plant.plantCalculation(x, y)
                elseif cell == "ash" then
                    elements.ash.ashCalculation(x, y)
                elseif cell == "dust" then
                    elements.dust.dustCalculation(x, y)
                elseif cell == "fire" then
                    elements.fire.fireCalculation(x, y)
                end
            end
        end
        direction = -direction
        love.accumulatedTime = love.accumulatedTime - fixedDt
    end
    ActiveGrid = NewActiveGrid
    NewActiveGrid = {}
    if love.mouse.isDown(1) and not ButtonHovered then
        drawAtCursor()
    end
    ButtonHovered = false
    lib.wait(waitTime)
end

--Keypressed
function love.keypressed(k)
    debug.keypressed(k, GridFactor, Grid)
    suit.keypressed(k)
end

-- forward keyboard events
function love.textinput(t)
    suit.textinput(t)
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
