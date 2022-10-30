
Fire = Entity:extend()

function Fire:new(x, y)
    self.image = love.graphics.newImage("fire.jpg")
    self.x = x
    self.y = y
    self.speed = 400
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.dead = false
end

function Fire:update(dt)
    self.y = self.y + self.speed * dt
end

function Fire:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Fire:checkCollision(obj)
    if Fire.super.checkCollision(self, obj) then
        self.dead = true
    end
end


