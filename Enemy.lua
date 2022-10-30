
Enemy = Entity:extend()

function Enemy:new(x, y)
    Enemy.super.new(self, x, y, "wall.png")
    self.speed = 100
    self.strength = 50
    self.weight = 0
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    self.x = self.x + self.speed * dt

    if self.x < 500 then
        self.x = 500
        self.speed = -self.speed
    elseif self.x + self.width > 700 then
        self.x = 700 - self.width
        self.speed = -self.speed
    end

    -- Shoot fire while player is near
    local loop = false
    local distance = math.abs(player.x - self.x)
    print(distance)
    if distance <= 250 then
        loop = true
    elseif distance > 250 then
        loop = false
    end
    
    while loop do
        loop = false
        table.insert(BucketOfFire, Fire(self.x + (self.width / 2), self.y + (self.height / 2))) 
        if distance <= 250 then          
            break
        end
    end
end

