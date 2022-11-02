
Player = Entity:extend()

-- Define player attributes
function Player:new(x, y)   
    Player.super.new(self, x, y, "spritesheet2.jpg")
    self.speed = 200
    self.canJump = false
    self.strength = 10
    self.dead = false
    self.health = 1
    
    -- Animation requirements    
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    
    frames = {}
    
    local frame_width = 90
    local frame_height = 90
    maxFrames = 5

    for i = 0, 1 do
        for j = 0, 2 do
            table.insert(frames, love.graphics.newQuad(j * frame_width + 20, i * frame_height, frame_width,
                        frame_height, self.width, self.height))
            if #frames == maxFrames then
                break
            end
        end
        currentFrame = 1
    end

end

function Player:update(dt)
    -- Allows update to last position
    Player.super.update(self, dt)
    -- Movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end    
    -- Check if mid-air to prevent jump while falling
    if self.last.y ~= self.y then
        self.canJump = false
    end
    
    -- Death conditions
    if player.health == 0 or self.y > 800 then
        gameOver = true
    end

    -- Animation
    currentFrame = currentFrame + 10 * dt
    if currentFrame >= 6 then
        currentFrame = 1
    end
end

-- function Player:draw()
    
-- end

function Player:jump()
    if self.canJump then
        self.gravity = -300
        self.canJump = false
    end
end

-- Allow jump
function Player:collide(obj, direction)
    Player.super.collide(self, obj, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end