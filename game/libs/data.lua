return {
    empty = { -- 1
        buttonColor = { 255, 255, 255 },
        color = { 255, 255, 255 },
        replaceElements = { "empty" },
        ...
    },
    wall = {
        buttonColor = { 128, 128, 128 },
        color = { 199, 200, 201 },
        replaceElements = { "empty" },
        ...
    },
    sand = {
        buttonColor = { 230, 204, 128 },
        color = function(x, y)
            return Elements.sand.getColorSand(x, y) or { 194, 178, 128 }
        end,
        replaceElements = { "empty", "water", "oil" },
        hasColorMap = true,
        ...
    },
    plant = {
        buttonColor = { 51, 128, 51 },
        color = function(x, y)
            return Elements.plant.getColorPlant(x, y) or { 24, 163, 8 }
        end,
        replaceElements = { "water" },
        hasColorMap = true,
        burnChance = 0.5,
        replaceChance = 0.3,
        textColor = {255, 255, 255},
        ...
    },
    water = {
        buttonColor = { 77, 153, 230 },
        color = function()
            return Colors.setColorInRange({ 84, 151, 235 }, { 104, 171, 255 })
        end,
        replaceElements = { "empty", "fire" },
        ...
    },
    fire = {
        buttonColor = { 179, 51, 51 },
        color = function(x, y)
            return Elements.fire.getColorFire(x, y) or { 179, 51, 51 }
        end,
        replaceElements = { "plant", "dust", "oil" },
        hasColorMap = true,
        textColor = { 255, 255, 255 },
        ...
    },
    ash = {
        buttonColor = { 153, 153, 153 },
        color = function(x, y)
            return Elements.ash.getColorAsh(x, y) or { 153, 153, 153 }
        end,
        replaceElements = { "empty", "water", "oil" },
        hasColorMap = true,
        ...
    },
    dust = {
        buttonColor = { 240, 155, 250 },
        color = function(x, y)
            return Elements.dust.getColorDust(x, y) or { 240, 155, 250 }
        end,
        replaceElements = { "empty", "water", "oil" },
        hasColorMap = true,
        burnChance = 1,
        ...
    },
    oil = {
        buttonColor = { 0, 0, 0 },
        textColor = { 255, 255, 255 },
        color = function()
            return Colors.setColorInRange({ 0, 0, 0 }, { 50, 50, 50 })
        end,
        replaceElements = { "empty", "fire" },
        hasColorMap = false,
        burnChance = 0.9,
        ...
    },

}

--fire, dust, ash
