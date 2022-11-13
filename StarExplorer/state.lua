local module = {}

module.init = function(group)
    module.lives = 3
    module.score = 0
    module.died = false
    module.steps = 0;
    module.gameLoopTimer = nil
    module.asteroidsAcceleration = 0
    module.creationAcceleration = 0
    module.accelerationInterval = 10
    module.accelerationStep = 10
    module.ableToFire = true
    module.paused = false
    module.group = group
    module.livesText = display.newText(group, 'Lives: ' .. 3, 200, 80, native.systemFont, 36)
    module.scoreText = display.newText(group, 'Score: ' .. 0, 400, 80, native.systemFont, 36)
end

module.reset = function()
    module.lives = 3
    module.score = 0
    module.died = false
    module.asteroidsAcceleration = 0
    module.creationAcceleration = 0
    module.steps = 0
    module.ableToFire = true
    module.livesText.text = 'Lives: ' .. module.lives
    module.scoreText.text = 'Score: ' .. module.score
end

module.updateText = function()
    module.livesText.text = 'Lives: ' .. module.lives
    module.scoreText.text = 'Score: ' .. module.score
end

module.updateSteps = function()
    if (module.steps >= module.accelerationInterval) then
        module.asteroidsAcceleration = module.asteroidsAcceleration + module.accelerationStep
        if (module.asteroidsAcceleration % 100 == 0) then
            module.creationAcceleration = module.creationAcceleration + 1
        end
        module.steps = 0
    end
    module.steps = module.steps + 1
end

module.increaseScore = function()
    module.score = module.score + 100
    module.updateText()
end

module.shipDestroyed = function(ship)
    module.died = true
    module.ableToFire = false
    module.lives = module.lives - 1
    module.updateText()
    ship.shipDestroyed(module.lives == 0)
    timer.performWithDelay(1250, function()
        module.ableToFire = true
    end)
    return module.lives == 0
end

return module
