
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
    for i,v in ipairs(objects) do
        v:update(dt)
    end
    local loop = true
    local limit = 0

    while loop do
        loop = false
        limit = limit + 1
        if limit > 100 then
            break
        end
        -- check wall collision on each object
        for i = 1, #objects - 1 do
            for j = i + 1, # objects do
                local collision = objects[i]: resolveCollision(objects[j])
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

