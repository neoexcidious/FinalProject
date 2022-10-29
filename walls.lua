
-- Create wall type in order to resolve collisions with it
Wall = Entity:extend()

function Wall:new(x, y)
    -- From https://free-game-assets.itch.io/free-industrial-zone-tileset-pixel-art
    Wall.super.new(self, x, y, "wall.jpg", 1)
    -- required to prevent player from pushing walls
    self.strength = 100
    -- walls should not fall
    self.weight = 0

end