local M = {}

function M.drawText(text, x, y, font, color)
    font = font or love.graphics.getFont()
    color = color or {1, 1, 1, 1}
    love.graphics.setFont(font)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(color[1], color[2], color[3], color[4])
    love.graphics.print(text, x, y)
    love.graphics.setColor(r, g, b, a)
end

return M