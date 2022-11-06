
Star = Entity:extend()

function Star:new(x, y)
    -- Edited retrieved image from Pixabay https://pixabay.com/photos/splash-water-droplet-water-drop-164963/
    self.image = love.graphics.newImage("sprites/star.png")  -- <<< Change picture
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.size = 10
    self.eaten = false
end

function Star:update(dt)

end

function Star:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Star:checkCollision(obj)
    if Star.super.checkCollision(self, obj) then
        if obj == player then
            self.eaten = true
        end
    end
end
-- Free to use image from Pixabay: https://pixabay.com/vectors/star-heart-vector-icon-glossy-2717442/