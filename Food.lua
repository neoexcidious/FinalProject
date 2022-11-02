
Food = Entity:extend()

function Food:new(x, y)
    self.image = love.graphics.newImage("dollar.png")  -- <<< Change picture
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.size = 10
    self.eaten = false
end

function Food:update(dt)

end

function Food:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Food:checkCollision(obj)
    if Food.super.checkCollision(self, obj) then
        self.eaten = true
        if obj == player then
            player.health = player.health + 1
        end
    end
end