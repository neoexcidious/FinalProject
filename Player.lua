
Player = Entity:extend()


-- Define player attributes
function Player:new(x, y)
    Player.super.new(self, x, y, "sprites/backdrop.png")
    self.speed = 200
    self.canJump = false
    self.strength = 10
    self.dead = false
    self.health = 1
    -- Image by ddraw on Freepik "https://www.freepik.com/free-vector/animation-skeleton_1036094.htm#query=animation%20sprite&position=10&from_view=keyword"
    self.texture = love.graphics.newImage("sprites/spritesheet.png")
    self.textureIdle = love.graphics.newImage("sprites/idle.png")
    self.state = "idle"
   
    -- Animation   
    

    frames = {}

    local w, h = self.texture:getDimensions()
    local wIdle, hIdle = self.textureIdle:getDimensions()
    self.xOffset = 30
    self.yOffset = 38

    local frame_width = 60
    local frame_height = 76
    maxFrames = 5

    for i =  0, 1 do
        for j = 0, 3 do
            table.insert(frames, love.graphics.newQuad(1 + j * (frame_width - 2), 1 + i * (frame_height + 2),
                        frame_width, frame_height, w, h))
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
        self.state = "walking"
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
        direction = "right"
        self.state = "walking"
    else
        self.state = "idle"
    end

    -- Check if mid-air to prevent jump while falling
    if self.last.y ~= self.y then
        self.canJump = false
    end
    
    -- Death conditions
    if player.health <= 0 or self.y > 800 then
        player.health = 0
        player.dead = true
        gameOver = true
    end

    -- Animation update
    currentFrame = currentFrame + 4 * dt
    if currentFrame >= maxFrames then
        currentFrame = 1
    end
end

-- If jumping
function Player:jump()
    if self.canJump then
        self.gravity = -300
        self.canJump = false
        self.state = "idle"
    end
end

function Player:render()
    local scaleX

    -- flip depending on direction
    if direction == "right" then
        scaleX = 1.3
        scaleXidle = 0.9
    else
        scaleX = -1.3
        scaleXidle = -0.9
    end

    -- draw sprite
    if self.state ~= "idle" then
        love.graphics.draw(self.texture, frames[math.floor(currentFrame)],
                            self.x + self.xOffset, self.y + self.yOffset, 0, scaleX, 1.2,
                            self.xOffset, self.yOffset - 2)
    else        
        love.graphics.draw(self.textureIdle, self.x + self.yOffset, self.y + self.yOffset,
                            0, scaleXidle, 0.9, self.xOffset, self.yOffset)
    end
end


-- Allow jump
function Player:collide(obj, direction)
    Player.super.collide(self, obj, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end

