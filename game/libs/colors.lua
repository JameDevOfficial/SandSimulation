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
    love.graphics.setColor(r / 255, g / 255, b / 255)
end
return M