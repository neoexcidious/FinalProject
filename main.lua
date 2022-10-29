
function love.load()
    -- Load Objects
    Object = require "classic"
    require "entity"
    require "player"
    require "walls"
    player = Player(30, 390)

    objects = {}
    table.insert(object, player)
    -- Load tileset
    -- From https://free-game-assets.itch.io/free-industrial-zone-tileset-pixel-art
    image = love.graphics.newImage("wall.jpg")
    -- Get tileset dimensions
    local image_width = image:getWidth()
    local image_height = image:getHeight()
    -- Divide tileset into each tile
    width = image_width - 4
    height = image_height -4 

    -- Create quads to extract each tile
    quads = {}

    for i = 0, 1 do
        for j = 0, 2 do
            table.insert(quads, love.graphics.newQuad(
                1 + j * (width),
                1 + i * (height),
                width, height, image_width, image_height))
        end
    end
    tilemap = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1},
        {1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}    
    }

end

function love.update(dt)  
    player:update(dt)
    wall:update(dt)
    player:resolveCollision(wall)
end

function love.draw()
    for i, row in ipairs(tilemap) do
        for j, tile in ipairs(row) do
            -- build blocks if not 0
            if tile ~= 0 then
                love.graphics.draw(image, quads[tile], (j - 1) * width, (i - 0.6) * height, 0, 1, 1)
            end
        end
    end
    player:draw()
end

