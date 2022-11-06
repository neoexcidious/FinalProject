
iceEnemy = Entity:extend()

function iceEnemy:new(x, y)
    --Image by Freepik "https://www.freepik.com/free-vector/flat-snow-cap-collection_3507261.htm#page=2&query=ice&position=23&from_view=search&track=sph"
    iceEnemy.super.new(self, x, y, "sprites/ice2.jpg")
    self.strength = 50
    self.weight = 0
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function iceEnemy:update(dt)

end

function iceEnemy:checkCollision(obj)
    if iceEnemy.super.checkCollision(self, obj) then
        if obj == player then
            local push = 20 
            if player.direction == right then
                push = -push
            end
            player.x = player.last.x + push
            player.y = player.last.y
            player.health = player.health - 1
            iceSFX:play()
            camera:shake(8, 1, 60)
        end
    end
end
