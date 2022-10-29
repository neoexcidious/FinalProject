
-- Following Sheepolution's guide to create base class
Entity = Object:extend()

function Entity:new(x, y, img)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(img)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Determine last position so we can revert back to it on collision
    self.last = {}
    self.last.x = self.x
    self.last.y = self.y
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
end

function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Entity:AlignedVertically(obj)
    -- If vertically aligned to other object, return true
    return self.last.y < obj.last.y and self.last.y + self.height > obj.last.y
end

function Entity:AlignedHorizontally(obj)
    -- If horizontally aligned to other object, return true
    return self.last.x < obj.last.x + obj.width and self.last.x + self.width > obj.last.x
end

function Entity: checkCollision(obj)
    -- If collided, return true
    return self.x + self.width > obj.x
    and self.x < obj.x + obj.width
    and self.y + self.height > obj.y
    and self.y < obj.y + obj.height
end

function Entity:resolveCollision(obj)
    -- If collided
    if self:checkCollision(obj) then
        -- Check alignment, push back accordingly
        if self:AlignedVertically(obj) then
            if self.x + self.width / 2 < obj.x + obj.width / 2 then
                -- push to the right of the player and left of the wall
                local push = self.x + self.width - e.x
                self.x = self.x - push
            else
                -- push to the left of the player and right of the wall
                local push = obj.x + obj.width - self.x
                self.x = self.x + push
            end

        elseif self:AlignedHorizontally(obj) then
            if self.y + self.height / 2 < obj.y + obj.height / 2 then
                -- push to bottom of player and top of wall
                local push = self.y + self.height - obj.y
                self.y = self.y - push
            else
                -- push to bottom of wall, top of player
                local push = obj.y + obj.height - self.y
                self.y = self.y + push
            end
        end
    end
end
