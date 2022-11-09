
Fire = Entity:extend()

function Fire:new(x, y)
    -- Edited image retrieved from Pixabay https://pixabay.com/illustrations/fireball-fire-explosion-flames-422746/
    self.image = love.graphics.newImage("sprites/fire.jpg")
    self.x = x
    self.y = y
    self.speed = 400
    self.width = self.image:getWidth() / 2
    self.height = self.image:getHeight() / 2
    self.dead = false
end

function Fire:update(dt)
    self.y = self.y + self.speed * dt
end

function Fire:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

-- Check for damage to player
function Fire:checkCollision(obj)
    if Fire.super.checkCollision(self, obj) then
        self.dead = true
        if obj == player then
            player.x = player.last.x - 10
            player.health = player.health - 1
            camera:shake(8, 1, 60)
            flameSFX:play()
        end
    end
end


