
Fire = Entity:extend()

function Fire:new(x, y)
    self.image = love.graphics.newImage("fire.jpg")
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
        end
    end
end


