local M = {}

function M.setColor(r, g, b)
    love.graphics.setColor(r / 255, g / 255, b / 255)
end

--Set Random Color in Range from color1 - color2
--Both colors have to be a table containing 3 values (r, g, b)
function M.setColorInRange(color1, color2)
    local r, g, b =
        math.random(color1[1], color2[1]),
        math.random(color1[2], color2[2]),
        math.random(color1[3], color2[3])
    return { r / 255, g / 255, b / 255 }
end

local function normalizeColor(color)
    if color[1] <= 1 and color[2] <= 1 and color[3] <= 1 then
        return color
    end
    return { color[1] / 255, color[2] / 255, color[3] / 255 }
end

function M.getButtonOpt(v, baseColor)
    return {
        draw = function(text, opt, x, y, w, h)
            local radius = 8
            baseColor = baseColor or
                (type(Data[v].buttonColor) == "function" and Data[v].buttonColor(x, y) or Data[v].buttonColor)
            local buttonColor = normalizeColor(baseColor)

            if opt.state == "hovered" then
                buttonColor = {
                    math.min(buttonColor[1] + 0.15, 1),
                    math.min(buttonColor[2] + 0.15, 1),
                    math.min(buttonColor[3] + 0.15, 1)
                }
            else
                buttonColor = {
                    math.min(buttonColor[1] + 0.15, 1),
                    math.min(buttonColor[2] + 0.15, 1),
                    math.min(buttonColor[3] + 0.15, 1)
                }
            end

            love.graphics.setColor(buttonColor)
            love.graphics.rectangle("fill", x, y, w, h, radius, radius)

            -- Draw button border (darker when hovered/active)
            if opt.state == "hovered" or v == CurrentMode then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle("line", x, y, w, h, radius, radius)
            end

            -- Draw button text
            love.graphics.setColor(0, 0, 0) -- Black text
            local font = love.graphics.getFont()
            local textW = font:getWidth(text)
            local textH = font:getHeight()
            love.graphics.print(text, x + (w - textW) / 2, y + (h - textH) / 2)
        end,
    }
end

M.GlobalBackgroundColor = { 0.1, 0.1, 0.1 }

return M
