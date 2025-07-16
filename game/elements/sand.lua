M = {}

local element = "sand"
local replaceElements = {"empty", "water"}

function M.sandCalculation(x, y)
    if Grid[y][x] ~= element then return end

    for i, v in ipairs(replaceElements) do

        if y < GridFactor and Grid[y + 1][x] == v then --sand floating
            Grid[y + 1][x] = element
            Grid[y][x] = v
            return
        end

        if y < GridFactor and Grid[y + 1][x] == element then --double sand stack
            if x < GridFactor and Grid[y + 1][x + 1] == v then               --diagonal right
                Grid[y][x] = v
                Grid[y + 1][x + 1] = element
                return 
            elseif x > 1 and Grid[y + 1][x - 1] == v then --diagonal left
                Grid[y][x] = v
                Grid[y + 1][x - 1] = element
                return 
            end
        end
    end
end

return M