-- Requirements
local composer = require "composer"
local fx = require "com.ponywolf.ponyfx"

-- Variables local to scene
local scene = composer.newScene()
local field, moon, ship, stars, info, music, help

function scene:create( event )
  local sceneGroup = self.view -- add display objects to this group

  -- music
  music = audio.loadSound("scene/menu/sfx/titletheme.mp3")

  -- load our title sceen
  field = display.newImage(sceneGroup, "scene/menu/img/field.png", display.contentCenterX, display.contentCenterY)
  stars = display.newImage(sceneGroup, "scene/menu/img/stars.png", display.contentCenterX, display.contentCenterY)
  ship = display.newImage(sceneGroup, "scene/menu/img/ship.png", display.contentCenterX, display.contentCenterY)
  moon = display.newImage(sceneGroup, "scene/menu/img/moon.png", display.contentCenterX, display.actualContentHeight)

  -- place everything
  moon.anchorY = 1
  moon.xScale, moon.yScale = 1.0, 1.0    
  field.xScale, field.yScale = 3, 3
  stars.xScale, stars.yScale = 3, 3 
  ship.xScale, ship.yScale = 2, 2  

  -- title and help

  help = display.newImage(sceneGroup, "scene/menu/img/help.png", display.contentCenterX, display.contentCenterY)
  local ratio = (display.contentHeight < display.contentWidth) and display.contentHeight or display.contentWidth
  help.xScale, help.yScale = 0.92 * ratio / help.width,  0.92 * ratio / help.height   

  function sceneGroup:tap()
    composer.gotoScene( "scene.game", { effect = "slideDown", params = { } })
  end
  sceneGroup:addEventListener("tap")
end

local function enterFrame(event)
  local elapsed = event.time
  field:rotate(0.1)
  stars:rotate(0.15)
  ship:rotate(-0.2)
end

function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    Runtime:addEventListener("enterFrame", enterFrame)
  elseif ( phase == "did" ) then
    audio.play(music, { loops = -1, fadein = 750, channel = 16 } )
  end
end

function scene:hide( event )
  local phase = event.phase
  if ( phase == "will" ) then
    audio.fadeOut( {channel = 16, time = 1500 } )
  elseif ( phase == "did" ) then
    Runtime:removeEventListener("enterFrame", enterFrame)  
  end
end

function scene:destroy( event )
  audio.stop()
  audio.dispose(music)  
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene