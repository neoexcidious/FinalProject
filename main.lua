
function love.load()
    -- Load components
    lume = require "lume"
    Object = require "classic"
    Camera = require "camera"
    require "entity"
    require "player"
    require "walls"
    require "fireEnemy"
    require "fire"
    require "food"
    require "iceEnemy"
    require "star"

    -- Sounds (created with BFXR)
    jumpSFX = love.audio.newSource("sounds/jump.wav", "static")
    flameSFX = love.audio.newSource("sounds/flame.wav", "static")
    deathSFX = love.audio.newSource("sounds/death.wav", "static")
    winSFX = love.audio.newSource("sounds/win.wav", "static")
    foodSFX = love.audio.newSource("sounds/food.wav", "static")
    iceSFX = love.audio.newSource("sounds/ice.wav", "static")

    -- Prevent ear bleeds
    winSFX:setVolume(0.5)

    -- Free music track from Itch.io: https://svl.itch.io/rpg-music-pack-svl
    music = love.audio.newSource("sounds/music.wav", "stream")
    music:setLooping(true)
    music:setVolume(0.15)
    music:play()

    -- Set flags
    gameOver = false
    gameWon = false
    gamePaused = false
    timer = 0

    -- Initialize primary objects
    player = Player(150, 200)
    fireEnemy = fireEnemy(600, 340)
    iceEnemy1 = iceEnemy(1200, 500)
    iceEnemy2 = iceEnemy(1250, 500)
    star = Star(2560, 400)

    -- Create fire table
    BucketOfFire = {}

    -- Create food table
    foodBucket = {}
    bucketSize = 3

     -- Load savegame if applicable
     if love.filesystem.getInfo("savedata.txt") then
        file = love.filesystem.read("savedata.txt")
        data = lume.deserialize(file)
        bucketSize = data.foodBucket

        -- Load player
        player.x = data.player.x
        player.y = data.player.y
        player.health = data.player.health  

        bucketSize = data.bucketSize
     else 
        for i = 1, bucketSize do
            table.insert(foodBucket, Food(love.math.random(150, 1800), love.math.random(300, 350)))
        end
    end
    
    -- Get window dimensions
    win_width, win_height = love.graphics.getDimensions()
    
    -- Set camera parameters
    camera = Camera()
    camW, camH = 800, 600    
    camera = Camera(camW/2, camH/2, camW, camH)    
   
    -- Create table of creatures
    creatures = {}    
    table.insert(creatures, player)
    table.insert(creatures, fireEnemy)
    table.insert(creatures, iceEnemy1)
    table.insert(creatures, iceEnemy2)

    -- Create separate table for walls to avoid checking collision where not needed
    walls = {}
    
    -- Create tilemap
    map = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
        {1,1,1,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1},
        {1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1}  
    }

    for i, v in ipairs(map) do 
        for j, w in ipairs(v) do
            if w == 1 then
                table.insert(walls, Wall((j-1) * 50, (i-1) * 50))
            end
        end
    end
end

function love.update(dt)  
    -- Prevents bugs called by delta time when moving the window
    dt = math.min(dt, 0.07)

    -- Update camera parameters to account for boundaries.
    if player.x >= 370 then
        camera:setFollowStyle("PLATFORMER")
    else
        camera:setFollowStyle("SCREEN_BY_SCREEN")
        camera:setDeadzone(100, camH/2 - 25, 80, 80)
    end

    -- Game Over
    if player.dead then
        deathSFX:play()
        gameOver = true        
    end   

    if star.eaten then
        gameWon = true
        winSFX:play()
    end

    -- Stop updates and death sound if game is paused or over
    if gamePaused or gameOver or gameWon then
        timer = timer + dt
        if gamePaused and timer > 0.5 then
            return
        elseif gameOver and timer > 2 or gameWon and timer > 2 then           
            deathSFX:stop()
            winSFX:stop()    
            return        
        end
    end

    -- Stop music on game end
    if gameWon or gameOver then
        music:stop()
    end

    -- Update camera
    camera:update(dt)
    camera:follow(player.x, player.y)
      
    -- Update creatures
    for i,v in ipairs(creatures) do
        v:update(dt)
    end 
     
    -- Check collision between all creatures without duplicating
    for i = 1, #creatures - 1 do
        for j = i + 1, #creatures do
            creatures[i]:resolveCollision(creatures[j])
        end
    end

    -- Eat food
    for i,v in ipairs(foodBucket) do
        v:update(dt)
        v:checkCollision(player)
        for i = #foodBucket, 1, -1 do
            if foodBucket[i].eaten then
                table.remove(foodBucket, i)
            end
        end
    end

    -- Eat star
    star:update(dt)
    star:checkCollision(player)
    if star.eaten then 
        gameWon = true
    end
        

    -- Update walls
    for i,v in ipairs(walls) do
        v:update(dt)
    end 

    -- Check for damage
    for i,v in ipairs(BucketOfFire) do
        v:update(dt)
        v:checkCollision(player)
    end
    iceEnemy1:checkCollision(player)
    iceEnemy2:checkCollision(player)

     

    -- Additional collision checks
    local loop = true
    local limit = 0

    while loop do
        -- While no collision happens
        loop = false

        -- Prevent player getting stuck in infinite loop
        limit = limit + 1        
        if limit > 100 then
            break
        end

        -- Resolve collision between all creatures
        for i = 1, #creatures - 1 do
            for j = i + 1, #creatures do
                local collision = creatures[i]: resolveCollision(creatures[j])
                if collision then
                    loop = true
                end
            end
        end
        
         -- Check wall collision on each object
        for i, wall in ipairs(walls) do
            for j, object in ipairs(creatures) do
                local collision = object:resolveCollision(wall)    
                if collision then
                    loop = true
                end
            end
            for k, bullet in ipairs(BucketOfFire) do
                local collision = bullet:checkCollision(wall)
                if collision then
                    loop = true
                    bullet.dead = true
                end
                if bullet.dead then
                    table.remove(BucketOfFire, i)
                end
            end
        end
    end
end


function love.draw()
    -- Display health counter
    love.graphics.print("Health: ".. player.health)   
    love.graphics.print("Use arrows to move and jump", 340, 0)
    love.graphics.print("Save Game: F5", 700, 0)
    love.graphics.print("Load Game: F9", 700, 20)
    love.graphics.print("Restart: F1", 700, 40)
    love.graphics.print("Quit: Alt + F4", 700, 60)
    love.graphics.print("Pause: Esc", 700, 80)

    


    camera:attach()
    -- Draw creatures
    for i, v in ipairs(creatures) do
        v:draw()       
    end
    player:render()
        
    -- Draw walls
    for i, v in ipairs(walls) do
        v:draw()
    end
    -- Draw fire
    for i, v in ipairs(BucketOfFire) do
        v:draw()
    end
    -- Draw food
    for i, v in ipairs(foodBucket) do
        love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.image:getWidth() / 2, v.image:getHeight() / 2)
    end

    -- Draw star
    star:draw()

    camera:detach()
    camera:draw()
    
    -- Game Paused
    if gamePaused and timer >= 0.1 then
        love.graphics.print("Game Paused. Press Esc to Resume.", win_width / 2 - 80, win_height / 4 + 50)
    end

    -- Game Over
    if gameOver then
        camera:fade(0.2, {0, 0, 0, 1})
        if timer >= 1 then
            love.graphics.print("Game Over! Press F1 to Restart.", win_width / 2 - 80, (win_height / 4) + 50)
        end
        return
    end

    -- Game Won
    if gameWon then
        camera:fade(0.2, {0, 0, 0, 1})
        if timer >= 1 then
            love.graphics.print("You've Won! Press F1 to Restart.", win_width / 2 - 80, (win_height / 4) + 50)
        end
    end
end

-- Controls Mapping
-- check if Menu is up
local isOn = false

function love.keypressed(key)
    -- jump function
    if key == "up" and player.canJump == true then
        player:jump()
        jumpSFX:play()
    -- Pause game
    elseif key == "escape" and isOn == false and not gameOver then
        camera:fade(0.1, {0, 0, 0, 1})
        isOn = true
        gamePaused = true        
    elseif key == "escape" and isOn == true and not gameOver then
        camera:fade(0.1, {0, 0, 0, 0})
        isOn = false
        gamePaused = false
        timer = 0
    -- Save
    elseif key == "f5" then
        saveGame()
    -- Load
    elseif key == "f9" then
        love.event.quit("restart")
    -- Restart
    elseif key == "f1" then
        love.filesystem.remove("savedata.txt")
        love.event.quit("restart")
    end
end

-- Save Function

function saveGame()
    data = {}
    data.player = {
        x = player.x,
        y = player.y,
        health = player.health
    }
    
    data.foodBucket = #foodBucket
    
    serialized = lume.serialize(data)
    love.filesystem.write("savedata.txt", serialized)
end

