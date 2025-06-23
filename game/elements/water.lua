M = {}
local element = "water"
local replaceElements = {"empty"}

function M.waterCalculation(grid, gridFactor, x, y)
    for i, v in ipairs(replaceElements) do
        if grid[y][x] == element and grid[y + 1][x] == v then -- floating
            grid[y + 1][x] = element
            grid[y][x] = v
        end
        if  grid[y][x] == element and grid[y][x + 1] == v and x < gridFactor then
            grid[y][x+1] = element
            grid[y][x] = v      
            
        elseif grid[y][x] == element and grid[y][x-1] == v and x > 0 then
            grid[y][x-1] = element
            grid[y][x] = v
        end
    end
end

return M