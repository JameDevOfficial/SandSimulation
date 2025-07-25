local M = {}
--[[local _minSize, _xStart

local function getButtonRects()
    local totalWidth
    if ManualSizes then 
        totalWidth = #Buttons * ButtonWidth + (#Buttons - 1) * ButtonPadding
    else
        totalWidth = #Buttons * ButtonWidth + (#Buttons - 1) * ButtonPadding
    end
    local startX = (_minSize - totalWidth) / 2
    local rects = {}
    for i, btn in ipairs(Buttons) do
        if ManualSizes then 
            local x = startX + (i - 1) * (ButtonWidth + ButtonPadding)
            rects[i] = { x = x + _xStart, y = ButtonY, w = ButtonWidth, h = ButtonHeight, label = btn }
        end
    end
    return rects
end

function M.DrawButtons(minSize, xStart)
    _minSize = minSize
    _xStart = xStart
    local rects = getButtonRects()
    for i, rect in ipairs(rects) do
        if Buttons[i] == CurrentMode then
            love.graphics.setColor(0.8, 0.8, 0.2)
        else
            love.graphics.setColor(0.7, 0.7, 0.7)
        end
        love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h, 6, 6)
        love.graphics.setColor(0, 0, 0)
        local font = love.graphics.getFont()
        local textW = font:getWidth(rect.label)
        local textH = font:getHeight()
        love.graphics.print(rect.label, rect.x + (rect.w - textW) / 2, rect.y + (rect.h - textH) / 2)
    end
end

local function handleButtonClick(mx, my)
    local rects = getButtonRects()
    for i, rect in ipairs(rects) do
        if mx >= rect.x and mx <= rect.x + rect.w and my >= rect.y and my <= rect.y + rect.h then
            CurrentMode = Buttons[i]
            return
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        handleButtonClick(x, y)
    end
end
--]]
return M