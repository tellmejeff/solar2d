
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local backGroup
local mainGroup
local uiGroup

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

local asteroids = require('asteroids')
local objectSheet = require('sheet')
local ship = require('ship')
local state = require('state')
local pausePlay

local function pauseOrPlayGame()
	display.remove(pausePlay)
	if (state.paused) then
		timer.resumeAll()
		physics.start()
		pausePlay = display.newImageRect(uiGroup, 'pause.png', 48, 48)
		state.paused = false
	else
		timer.pauseAll()
		physics.pause()
		pausePlay = display.newImageRect(uiGroup, 'play.png', 48, 48)
		state.paused = true
	end
	pausePlay.x = display.contentWidth - 120
	pausePlay.y = 80
	pausePlay:addEventListener('tap', pauseOrPlayGame)
end

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

local function endGame()
	asteroids.removeAllAsteroids()
	composer.setVariable('finalScore', state.score)
	state.reset()
	composer.gotoScene('highscores', {time=800, effect='crossFade'})
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
				local gameOver = state.shipDestroyed(ship)
				if (gameOver) then
					timer.performWithDelay(2000, endGame)
				end
			end
		end
	end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()

	backGroup = display.newGroup()
	sceneGroup:insert(backGroup)

	mainGroup = display.newGroup()
	sceneGroup:insert(mainGroup)

	uiGroup = display.newGroup()
	sceneGroup:insert(uiGroup)

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
	pausePlay = display.newImageRect(uiGroup, 'pause.png', 48, 48)
	pausePlay.x = display.contentWidth - 120
	pausePlay.y = 80
	pausePlay:addEventListener('tap', pauseOrPlayGame)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		ship.createShip()

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener('collision', onCollision)
		state.gameLoopTimer = timer.performWithDelay(300, gameLoop, 0)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel(state.gameLoopTimer)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener('collision', onCollision)
		physics.pause()
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
