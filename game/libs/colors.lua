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
    return {r / 255, g / 255, b / 255}
end

function M.getButtonOpt(v)
    return {
        draw = function(text, opt, x, y, w, h)
            local radius = 8
            local baseColor = ButtonColors[v] or { 0.5, 0.5, 0.5 }
            local buttonColor = baseColor

            if v == CurrentMode then
                
            elseif opt.state == "hovered" then
                buttonColor = {
                    math.min(baseColor[1] + 0.2, 1),
                    math.min(baseColor[2] + 0.2, 1),
                    math.min(baseColor[3] + 0.2, 1)
                }
            else
                buttonColor = {
                    math.min(baseColor[1] + 0.2, 1),
                    math.min(baseColor[2] + 0.2, 1),
                    math.min(baseColor[3] + 0.2, 1)
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

return M
