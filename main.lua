
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

    gameOver = false

    -- Initialize primary objects
    player = Player(150, 100)
    fireEnemy = fireEnemy(600, 350)
    iceEnemy1 = iceEnemy(1200, 500)
    iceEnemy2 = iceEnemy(1250, 500)

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
    local w, h = 800, 600
    camera = Camera(w/2, h/2, w, h)
    camera:setFollowStyle("PLATFORMER")
    camera:setDeadzone(300, h/2 - 40, w - 80, 80)
    
    -- Debugging purposes only                       <<< Remove this when done
    camera.draw_deadzone = true  
    
    -- Create table of creatures
    creatures = {}    
    table.insert(creatures, player)
    table.insert(creatures, fireEnemy)
    table.insert(creatures, iceEnemy1)
    table.insert(creatures, iceEnemy2)

    image = player.image
    -- Create separate table for walls to avoid checking collision where not needed
    walls = {}
    
    -- Create tilemap
    map = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0},
        {1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1}  
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

    -- Update walls
    for i,v in ipairs(walls) do
        v:update(dt)
    end 

    -- Update fire
    for i,v in ipairs(BucketOfFire) do
        v:update(dt)
        v:checkCollision(player)
        if player.dead then
            gameOver = true
        end        
      end

    -- Collision checks
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
    love.graphics.print("Save Game: F5", 700, 0)
    love.graphics.print("Restart: F1", 700, 20)
    love.graphics.print("Quit: Alt + F4", 700, 40)


    camera:attach()
    -- Draw creatures
    for i, v in ipairs(creatures) do
        v:draw()
    end
    
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

    camera:detach()
    camera:draw()
    
    -- Check if player died
    if gameOver then
        camera:fade(0.1, {0, 0, 0, 1})
        love.graphics.print("Game Over", (win_width / 2), (win_height / 2))
        return
    end
end

-- Controls Mapping
-- check if Menu is up
local isOn = false

function love.keypressed(key)
    -- jump function
    if key == "up" or key == "w" then
        player:jump()
    elseif key == "escape" and isOn == false then
        camera:fade(1, {0, 0, 0, 1})
        isOn = true
    elseif key == "escape" and isOn == true then
        camera:fade(1, {0, 0, 0, 0})
        isOn = false
    elseif key == "f5" then
        saveGame()
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