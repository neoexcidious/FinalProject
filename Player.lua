
Player = Object:extend()

function Player:new()
    
    self.image = love.graphics.newImage("drop.png")
    self.x = 10
    self.y = 400
    self.size = 20 
    self.speed = 200
end

function Player:update(dt)
    -- Movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end
-- Set boundaries
    local window_width = love.graphics.getWidth()

    if self.x < 0 then
        self.x = 0
    elseif self.x + self.size > window_width then
        self.x = window_width - self.size
    end
end

function Player:draw()
    love.graphics.circle("fill", self.x, self.y, self.size)
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end