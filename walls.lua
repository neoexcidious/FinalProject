
-- Create wall type in order to resolve collisions with it
Wall = Entity:extend()

function Wall:new(x, y)
    -- From https://free-game-assets.itch.io/free-industrial-zone-tileset-pixel-art
    Wall.super.new(self, x, y, "sprites/wall.jpg", 1)
    -- Required to prevent player from pushing walls
    self.strength = 100
    -- Walls should not fall
    self.weight = 0
end