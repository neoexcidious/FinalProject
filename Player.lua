
-- Create player from typ
Player = Entity:extend()

-- Define player attributes
function Player:new(x, y)    
    Player.super.new(self, x, y, "drop.png")
    self.speed = 200
    self.canJump = false
end

function Player:update(dt)
    -- Allows update to last position
    Player.super.update(self, dt)
    -- Movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end
    
    -- Check if mid-air
    if self.last.y ~= self.y then
        self.canJump = false
    end    
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function Player:jump()
    if self.canJump then
        self.gravity = -300
        self.canJump = false
    end
end

