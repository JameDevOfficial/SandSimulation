M = {}

local element = "sand"
local replaceElements = {"empty", "water"}

function M.sandCalculation(grid, gridFactor, x, y)
    for i, v in ipairs(replaceElements) do
        if grid[y][x] ~= element then return end

        if y < gridFactor and grid[y + 1][x] == v then --sand floating
            grid[y + 1][x] = element
            grid[y][x] = v
            return
        end

        if y < gridFactor and grid[y + 1][x] == element then --double sand stack
            if x < gridFactor and grid[y + 1][x + 1] == v then               --diagonal right
                grid[y][x] = v
                grid[y + 1][x + 1] = element
                return 
            elseif x > 1 and grid[y + 1][x - 1] == v then --diagonal left
                grid[y][x] = v
                grid[y + 1][x - 1] = element
                return 
            end
        end
    end
end

return M