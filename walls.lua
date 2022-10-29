
-- Create wall type in order to resolve collisions with it
Wall = Entity:extend()

function Wall:new(x, y)
    -- From https://free-game-assets.itch.io/free-industrial-zone-tileset-pixel-art
    Wall.super.new(self, x, y, "wall.jpg")
end