
function love.load()
    -- Load components
    Object = require "classic"
    Camera = require "camera"
    require "entity"
    require "player"
    require "walls"
    player = Player(30, 390)
    
    -- Set camera parameters
    camera = Camera()
    camera:setFollowStyle("CUSTOM")
    local w, h = 800, 600
    camera = Camera (w/2, h/2, w, h)
    camera:setDeadzone(40, h/2, w - 80, 80)    

    objects = {}
    table.insert(objects, player)

    walls = {}

    map = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,1},
        {1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}  
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
    -- Update objects
    camera:update(dt)
    camera:follow(player.x, player.y)
    for i,v in ipairs(objects) do
        v:update(dt)
    end

    -- Update walls
    for i,v in ipairs(walls) do
        v:update(dt)
    end

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

        -- Check wall collision on each object
        for i = 1, #objects - 1 do
            for j = i + 1, #objects do
                local collision = objects[i]: resolveCollision(objects[j])
                if collision then
                    loop = true
                end
            end
        end
        for i, wall in ipairs(walls) do
            for j, object in ipairs(objects) do
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
    -- Draw objects
    for i, v in ipairs(objects) do
        v:draw()
    end
    -- Draw walls
    for i, v in ipairs(walls) do
        v:draw()
    end
    camera:detach()
    camera:draw()
end

function love.keypressed(key)
    -- jump function
    if key == "up" or key == "w" then
        player:jump()
    elseif key == "escape" then
        menu()
    end
end

function menu()
    local is_up = false
    
    if is_up == false then
        camera:fade(1, {0, 0, 0, 1})
        is_up = true
    else
        camera:fade(1, {0, 0, 0, 0})
        is_up = false
    end
end