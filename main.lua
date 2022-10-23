

function love.load()
    myCircle = {}
    myCircle.x = 10
    myCircle.y = 400
    myCircle.height = 10
    myCircle.width = 10
    fruits = {"apple", "banana"}
    table.insert(fruits, "pear")
    table.insert(fruits, "pineapple")
    table.remove(fruits, 2)
    fruits[1] = "tomato"

    end
end


function love.update(dt)  
    -- Directional movement
    if love.keyboard.isDown('w') then
        myCircle.y = myCircle.y - 200 * dt
    elseif love.keyboard.isDown('s') then
        myCircle.y = myCircle.y + 200 * dt
    elseif love.keyboard.isDown('a') then
        myCircle.x = myCircle.x - 200 * dt
    elseif love.keyboard.isDown('d') then
        myCircle.x = myCircle.x + 200 * dt
    elseif love.keyboard.isDown("w") and love.keyboard.isDown("s") then
        myCircle.y = myCircle.y - 200 * dt
        myCircle.y = myCircle.y + 200 * dt
    
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

end

function love.draw()
    love.graphics.ellipse("fill", myCircle.x, myCircle.y, myCircle.width, myCircle.height)
    for i = 1, #fruits do
        love.graphics.print(fruits[i], myCircle.x, myCircle.y + 20 * i)
    end
end

