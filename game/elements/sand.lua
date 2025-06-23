M = {}

local element = "sand"
local replaceElements = {"empty", "water"}

function M.sandCalculation(grid, gridFactor, x, y)
    for i, v in ipairs(replaceElements) do
        if grid[y][x] == element and grid[y + 1][x] == v then --sand floating
            grid[y + 1][x] = element
            grid[y][x] = v
        end

        if grid[y][x] == element and grid[y + 1][x] == element then --double sand stack
            if grid[y + 1][x + 1] == "empty" then               --diagonal right
                grid[y][x] = "empty"
                grid[y + 1][x + 1] = element
            elseif grid[y + 1][x - 1] == "empty" then --diagonal left
                grid[y][x] = "empty"
                grid[y + 1][x - 1] = element
            end
        end
    end
end

return M