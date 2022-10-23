

function love.load()
    myCircle = {}
    myCircle.x = 10
    myCircle.y = 400
    myCircle.height = 10
    myCircle.width = 10
    myCircle.speed = 200
    listOfCircles = {}
end

-- shoot circles
function createCircle()
    circ = {}
    circ.x = myCircle.x
    circ.y = myCircle.y
    circ.height = 10
    circ.width = 10
    circ.speed = 200
    table.insert(listOfCircles, circ)
end

function love.keypressed(key)
    if key == "space" then
        createCircle()
    end
end

function love.update(dt)  
    -- Directional movement
    if love.keyboard.isDown('w') then
        myCircle.y = myCircle.y - myCircle.speed * dt
    elseif love.keyboard.isDown('s') then
        myCircle.y = myCircle.y + myCircle.speed * dt
    elseif love.keyboard.isDown('a') then
        myCircle.x = myCircle.x - myCircle.speed * dt
    elseif love.keyboard.isDown('d') then
        myCircle.x = myCircle.x + myCircle.speed * dt
    elseif love.keyboard.isDown("w") and love.keyboard.isDown("s") then
        myCircle.y = myCircle.y - myCircle.speed * dt
        myCircle.y = myCircle.y + myCircle.speed * dt
    
    end

    -- Boundaries
    if myCircle.y < 4 then
        myCircle.y = myCircle.y + 5
    elseif myCircle.y > 595 then
        myCircle.y = myCircle.y - 5
    elseif myCircle.x < 1 then
        myCircle.x = myCircle.x + 5
    elseif myCircle.x > 795 then
        myCircle.x = myCircle.x - 5
    end

    -- Create more
    for i,v in ipairs(listOfCircles) do
        v.x = v.x + v.speed * dt
    end

end

function love.draw(dt)
    love.graphics.ellipse("fill", myCircle.x, myCircle.y, myCircle.width, myCircle.height)
    for i,v in ipairs(listOfCircles) do
        love.graphics.circle("line", v.x, v.y, v.width, v.height)
    end
end



