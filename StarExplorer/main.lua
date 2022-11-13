-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

-- seed the random number generator
math.randomseed(os.time())

-- set up display groups
local backGroup = display.newGroup()    -- group for the background image
local mainGroup = display.newGroup()    -- group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()      -- group for UI objects like the score

local asteroids = require('asteroids')
local objectSheet = require('sheet')
local ship = require('ship')
local state = require('state')
state.init(uiGroup)
ship.init(physics, mainGroup, objectSheet.sheet, state)
asteroids.init(physics, mainGroup, objectSheet.sheet, state)

-- load the background
local background = display.newImageRect(backGroup, 'background.png', 800, 1400)
background.x = display.contentCenterX
background.y = display.contentCenterY

local status = display.newRect(backGroup, 0, 0, 1400, 85)
status:setFillColor(0.3, 0.3, 0.3)
status.strokeWidth = 3
status:setStrokeColor(0.4, 0.4, 0.4)

-- pause / play button
local pausePlay = display.newImageRect(uiGroup, 'pause.png', 48, 48)
pausePlay.x = display.contentWidth - 120
pausePlay.y = 80

local function pauseOrPlayGame()
    display.remove(pausePlay)
    if (paused) then
        transition.resumeAll()
        timer.resumeAll()
        pausePlay = display.newImageRect(uiGroup, 'pause.png', 48, 48)
        paused = false
    else
        transition.pauseAll()
        timer.pauseAll()
        pausePlay = display.newImageRect(uiGroup, 'play.png', 48, 48)
        paused = true
    end
    pausePlay.x = display.contentWidth - 120
    pausePlay.y = 80
    pausePlay:addEventListener('tap', pauseOrPlayGame)
end
pausePlay:addEventListener('tap', pauseOrPlayGame)

-- hide status bar
display.setStatusBar(display.HiddenStatusBar)

local function gameLoop()
    if (not state.paused) then
        if (state.ableToFire) then
            ship.fireLasers()
        end
        state.updateSteps()
        asteroids.createAsteroids()
        asteroids.removeOffscreenAsteroids()
    end
end

ship.createShip()
state.gameLoopTimer = timer.performWithDelay(250, gameLoop, 0)

local function restartGame()
    asteroids.removeAllAsteroids()
    state.reset()
    ship.createShip()
end

local function onCollision(event)
    if (event.phase == 'began') then
        local obj1 = event.object1
        local obj2 = event.object2
        if ((obj1.myName == 'laser' and obj2.myName == 'asteroid') or
                (obj1.myName == 'asteroid' and obj2.myName == 'laser')) then
            -- remove both the laser and the asteroid
            display.remove(obj1)
            display.remove(obj2)
            asteroids.removeAsteroid(obj1, obj2)
            state.increaseScore()
        elseif ((obj1.myName == 'ship' and obj2.myName == 'asteroid') or
                (obj1.myName == 'asteroid' and obj2.myName == 'ship')) then
            if (state.died == false) then
                local restart = state.shipDestroyed(ship)
                if (restart) then
                    timer.performWithDelay(2000, restartGame)
                end
            end
        end
    end
end

Runtime:addEventListener('collision', onCollision)