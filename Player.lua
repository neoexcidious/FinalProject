
Player = Entity:extend()


-- Define player attributes
function Player:new(x, y)
    Player.super.new(self, x, y, "backdrop.png")
    self.speed = 200
    self.canJump = false
    self.strength = 10
    self.dead = false
    self.health = 1
    -- Texture retrieved from https://www.vectorstock.com/royalty-free-vectors/water-sprites-vectors
    self.texture = love.graphics.newImage("spritesheet.jpg")
    self.state = "idle"
   
    -- Animation   
    self.direction = "left"
    self.xOffset = 8
    self.yOffset = 16

    frames = {}

    local w, h = self.image:getDimensions()
    print(w..","..h)

    self.width = 68
    self.height = 68
    local frame_width = 68
    local frame_height = 68
    maxFrames = 16

    for i =  0, 4 do
        for j = 0, 4 do
            table.insert(frames, love.graphics.newQuad(j * frame_width, (i * frame_height) - 15,
                        frame_width, frame_height, 272, 272))
            if #frames == maxFrames then
                break
            end
        end
        currentFrame = 1
    end    
    return Player
end

function Player:update(dt)
    -- -- Allows update to last position
    Player.super.update(self, dt)
    -- Movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
        direction = "left"
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
        direction = "right"
    end    
    -- Check if mid-air to prevent jump while falling
    if self.last.y ~= self.y then
        self.canJump = false
    end
    
    -- Death conditions
    if player.health <= 0 or self.y > 800 then
        player.health = 0
        gameOver = true
    end

    -- Animation
    currentFrame = currentFrame + 5 * dt
    if currentFrame >= maxFrames then
        currentFrame = 1
    end
end

-- Check if falling

function Player:jump()
    if self.canJump then
        self.gravity = -300
        self.canJump = false
        self.state = "falling"
    end
end

function Player:render()
    local scaleX

    -- flip depending on direction
    if direction == "right" then
        scaleX = 1
    else
        scaleX = -1
    end

    -- draw sprite
    love.graphics.draw(self.texture, frames[math.floor(currentFrame)], player.x, player.y)
end


-- Allow jump
function Player:collide(obj, direction)
    Player.super.collide(self, obj, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end

