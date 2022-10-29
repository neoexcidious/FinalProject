
function love.load()
    -- Load Objects
    Object = require "classic"
    require "entity"
    require "player"
    require "walls"
    player = Player(30, 390)

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
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
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
    -- Draw objects
    for i, v in ipairs(objects) do
        v:draw()
    end
    -- Draw walls
    for i, v in ipairs(walls) do
        v:draw()
    end
end

