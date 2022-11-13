local module = {}

module.asteroidsTable = {}

module.init = function(physics, group, sheet, state)
    module.physics = physics
    module.group = group
    module.sheet = sheet
    module.state = state
end

local function createAsteroid()
    local newAsteroid = display.newImageRect(module.group, module.sheet, 1, 102, 85)
    table.insert(module.asteroidsTable, newAsteroid)
    module.physics.addBody(newAsteroid, 'dynamic', { radius = 40, bounce = 0.8 })
    newAsteroid.myName = 'asteroid'
    local whereFrom = math.random(3)
    if (whereFrom == 1) then
        -- from the left
        newAsteroid.x = -60
        newAsteroid.y = math.random(500)
        newAsteroid:setLinearVelocity(math.random(40, 120 + module.state.asteroidsAcceleration), math.random(20, 60 + module.state.asteroidsAcceleration))
    elseif (whereFrom == 2) then
        -- from the top
        newAsteroid.x = math.random(display.contentWidth)
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity(math.random(-40, 40 + module.state.asteroidsAcceleration), math.random(40, 120 + module.state.asteroidsAcceleration))
    elseif (whereFrom == 3) then
        -- from the right
        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y = math.random(500)
        newAsteroid:setLinearVelocity(math.random(-120, 40 + module.state.asteroidsAcceleration), math.random(20, 60 + module.state.asteroidsAcceleration))
    end
    newAsteroid:applyTorque(math.random(-6, 6))
end

module.createAsteroids = function()
    for i = 0, module.state.creationAcceleration, 1 do
        createAsteroid()
    end
end

module.removeOffscreenAsteroids = function()
    -- remove asteroids which have drifted off screen
    for i = #module.asteroidsTable, 1, -1 do
        local currentAsteroid = module.asteroidsTable[i]
        if (currentAsteroid.x < -100 or
                currentAsteroid.x > display.contentWidth + 100 or
                currentAsteroid.y < -100 or
                currentAsteroid.y > display.contentHeight + 100) then
            display.remove(currentAsteroid)
            table.remove(module.asteroidsTable, i)
        end
    end
end

module.removeAllAsteroids = function()
    for i = #module.asteroidsTable, 1, -1 do
        display.remove(module.asteroidsTable[i])
        table.remove(module.asteroidsTable, i)
    end
end

module.removeAsteroid = function(obj1, obj2)
    for i = #module.asteroidsTable, 1, -1 do
        if (module.asteroidsTable[i] == obj1 or module.asteroidsTable[i] == obj2) then
            table.remove(module.asteroidsTable, i)
            break
        end
    end
end

return module