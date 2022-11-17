local module = {
    lives = 3,
    -- initial acceleration for asteroids
    asteroidsAcceleration = 0,
    -- additional asteroids added
    creationAcceleration = 1,
    -- max number of asteroids onscreen
    maxAsteroids = 5,
    -- how often the acceleration numbers increase (game clock intervals)
    accelerationIncreaseInterval = 10,
    -- how often the creation numbers increase (game clock intervals)
    creationIncreaseInterval = 100,
    -- increase in acceleration every interval
    accelerationStep = 5
}

return module