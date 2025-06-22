M = {}

function M.sandCalculation(grid, gridFactor)
    for y = gridFactor - 1, 1, -1 do
        for x = 1, gridFactor do
            if grid[y][x] == "sand" and grid[y + 1][x] == "empty" then --sand floating
                grid[y + 1][x] = "sand"
                grid[y][x] = "empty"
            end
            if grid[y][x] == "sand" and grid[y + 1][x] == "sand" then --double sand stack
                if grid[y + 1][x + 1] == "empty" then               --diagonal right
                    grid[y][x] = "empty"
                    grid[y + 1][x + 1] = "sand"
                end
                if grid[y + 1][x - 1] == "empty" then --diagonal left
                    grid[y][x] = "empty"
                    grid[y + 1][x - 1] = "sand"
                end
            end
        end
    end
end

return M