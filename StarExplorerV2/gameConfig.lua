local module = {
    lives = 3,
    -- initial acceleration for asteroids
    asteroidsAcceleration = 0,
    -- initial asteroids created
    creationAcceleration = 10,
    -- max number of asteroids onscreen
    maxAsteroids = 20,
    -- how often the acceleration numbers increase (game clock intervals)
    accelerationIncreaseInterval = 10,
    -- how often the creation numbers increase (game clock intervals)
    creationIncreaseInterval = 1000,
    -- increase in acceleration every interval
    accelerationStep = 5
}

return module