
listOfCircles = {}

function love.load()
    -- Load Objects
    Object = require "classic"
    require "player"

    player = Player()
 
end

function love.update(dt)  
    player:update(dt)

end

function love.draw()
    -- Moving rectangle and circle
    player:draw()

end

