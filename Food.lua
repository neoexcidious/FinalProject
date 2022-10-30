
Food = Entity:extend()

function Food:new()
    self.image = love.graphics.newImage("dollar.png")  -- <<< Change picture
    self.x = math.random(100, 650)
    self.y = math.random(320, 380)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.size = 10
    self.eaten = false
end

function Food:update(dt)
    for i = 1, 5 do
        table.insert(foodBucket, Food(self.x, self.y))
    end
end

function Food:draw()
    love.graphics.draw(self.image, self.x, self.y)    
end

function Food:checkCollision(obj)
    if Food.super.checkCollision(self, obj) then
        self.eaten = true
    end
end