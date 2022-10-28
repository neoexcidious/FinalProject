
Player = Object:extend()

function Player:new()
    
    -- Loaded free use image from Pixabay: https://pixabay.com/photos/water-drop-wave-wet-liquid-splash-5099248/
    self.image = love.graphics.newImage("drop.png")
    self.x = 10
    self.y = 400
    self.width = self.image:getWidth()
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
    elseif self.x + self.width > window_width then
        self.x = window_width - self.width
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end