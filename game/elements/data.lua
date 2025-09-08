return {
    --[[["example"] = {
        color = {r, g, b} (0-255),
        burnChance = float (0-1),
        replaceElements = {"empty"},
        vanishChance = float (0-1),
        buttonColor = {r, g, b} (0-255),
        hasColorMap = boolean,
    }]]
    sand = { 
        buttonColor = { 230, 204, 128 },
        color = function(x, y)
            return Elements.sand.getColorSand(x, y) or { 194, 178, 128 }
        end,
        replaceElements = {"empty", "water"},
        hasColorMap = true,
        ... 
    },
    plant = { 
        buttonColor = { 51, 128, 51 },
        color = function(x, y)
            return Elements.plant.getColorPlant(x, y) or { 24, 163, 8 }
        end,
        replaceElements = {"water"},
        hasColorMap = true,
        burnChance = 0.1,
        replaceChance = 0.3,
        ... 
    },
    water = {
        buttonColor = { 77, 153, 230 },
        color = Colors.setColorInRange({ 84, 151, 235 }, { 104, 171, 255 }),
        replaceElements = {"empty", "fire"},
        ...
    },
    fire = {
        buttonColor = { 179, 51, 51 },
        color = function(x, y)
            return Elements.fire.getColorFire(x, y) or { 179, 51, 51 }
        end,
        replaceElements = {"plant", "dust"},
        hasColorMap = true,
        ...
    },
    ash = { 
        buttonColor = { 153, 153, 153 },
        color = function(x, y) 
            return Elements.ash.getColorAsh(x, y) or { 153, 153, 153 }
        end,
        replaceElements = {"empty", "water", "fire"},
        hasColorMap = true,
        ... 
    },
    dust = { 
        buttonColor = { 240, 155, 250 },
        color = function(x, y)
            return Elements.dust.getColorDust(x, y) or { 240, 155, 250 }
        end,
        replaceElements = {"empty", "water"},
        hasColorMap = true,
        burnChance = 1,
        ... 
    },
    empty = { 
        buttonColor = { 255, 255, 255 },
        color = {255, 255, 255},
        replaceElements = {"empty"},
        ... 
    },
    wall = {
        buttonColor = { 128, 128, 128 },
        color = { 199, 200, 201 },
        replaceElements = { "empty" },
        ...
    },
}

--fire, dust, ash