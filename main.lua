
function love.load()
    -- Load components
    Object = require "classic"
    Camera = require "camera"
    require "entity"
    require "player"
    require "walls"
    require "enemy"
    require "fire"
    require "food"

    -- Initialize primary objects
    player = Player(30, 390)
    enemy = Enemy(600, 350)
    BucketOfFire = {}
    gameOver = false

    -- Create food table
    foodBucket = {}

    -- Get window dimensions
    width, height = love.graphics.getDimensions()
    
    -- Set camera parameters                        <<< Fix this
    camera = Camera()
    local w, h = 800, 600
    camera = Camera(w/2, h/2, w, h)
    camera:setDeadzone(40, h/2 - 40, w - 400, 80)
    
    -- Debugging purposes only                       <<< Remove this when done
    camera.draw_deadzone = true  
    
    -- Create table of creatures
    creatures = {}    
    table.insert(creatures, player)
    table.insert(creatures, enemy)

    -- Create separate table for walls to avoid checking collision where not needed
    walls = {}
    
    -- Create tilemap
    map = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0},
        {1,1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
        {1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,0,1}  
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

    -- Update walls
    for i,v in ipairs(walls) do
        v:update(dt)
    end    

    -- Eat food
    for i,v in ipairs(foodBucket) do
        v:update(dt)
        v:checkCollision(player)
        print("Ate food!")
    end

    -- Update fire    <<< gameOver needs to be changed when adding wall collision check
    for i,v in ipairs(BucketOfFire) do
        v:update(dt)
        v:checkCollision(player)
        if v.dead then
            table.remove(BucketOfFire, i)
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
        end
    end
end


function love.draw()
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
        v:draw()
    end
    
    camera:detach()
    camera:draw()
    
    -- If player died
    if gameOver then
        camera:fade(0.1, {0, 0, 0, 1})
        love.graphics.print("Game Over", (width / 2), (height / 2))
        return
    end
end

-- Controls Mapping

-- Check if Menu is up
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
    end
end
