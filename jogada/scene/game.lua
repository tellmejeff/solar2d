-- Requirements
local composer = require "composer"
local board = require('components.board')
local button = require('components.button')

-- Variables local to scene
local scene = composer.newScene()
local restartButton, currentLevel

function scene:create( event )
  local sceneGroup = self.view -- add display objects to this group
  currentLevel = 1
  local gameboard = board.new()
  gameboard:onLevelComplete(function()
    currentLevel = currentLevel + 1
    gameboard:loadLevel(currentLevel)
  end)
  gameboard:loadLevel(currentLevel)

  restartButton = button.new({
    left = 10,
    top = display.contentHeight - 110,
    label = 'Restart',
    fillColor = { 0.3, 0.3, 1, 0.7 },
    activeFillColor = { 0.1, 0.1, 0.8, 1 },
    labelColor = { 1, 1, 1, 1 },
    activeLabelColor = { 1, 1, 1, 1 },
    fontSize = 48,
    strokeWidth = 8,
    strokeColor = { 0.0, 0.0, 0, 0.5 },
    handleButtonEvent = function(evt)
      if (evt.phase == 'ended') then
        gameboard:loadLevel(currentLevel)
      end
    end
  })
end

local function enterFrame(event)
  local elapsed = event.time

end

function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    Runtime:addEventListener("enterFrame", enterFrame)
  elseif ( phase == "did" ) then

  end
end

function scene:hide( event )
  local phase = event.phase
  if ( phase == "will" ) then

  elseif ( phase == "did" ) then
    Runtime:removeEventListener("enterFrame", enterFrame)  
  end
end

function scene:destroy( event )
  --collectgarbage()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene