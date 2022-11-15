local module = {}

module.init = function(group)
    module.lives = 3
    module.score = 0
    module.highScore = 0
    module.died = false
    module.steps = 0;
    module.gameLoopTimer = nil
    module.asteroidsAcceleration = 20
    module.creationAcceleration = 1
    module.accelerationInterval = 10
    module.accelerationStep = 5
    module.ableToFire = true
    module.paused = false
    module.group = group
    module.livesText = display.newText(group, 'Lives: ' .. 3, 150, 20, native.courier, 18)
    module.scoreText = display.newText(group, 'Score: ' .. 0, 350, 20, native.courier, 18)
    module.highScoreText = display.newText(group, 'HiScore: ' .. 0, 550, 20, native.courier, 18)
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
    module.highScoreText.text = 'HiScore: ' .. module.highScore
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
    if (module.score > module.highScore) then
        module.highScore = module.score
    end
    if (module.score % 50000 == 0) then
        module.lives = module.lives + 1
        module.updateText()
    end
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
    if (module.lives == 0) then
        local gameOverText = display.newText(module.group, "GAME OVER", display.contentWidth / 2, display.contentHeight /2, native.systemFont, 36)
        timer.performWithDelay(2000, function() display.remove(gameOverText)  end)
    end
    return module.lives == 0
end

return module
