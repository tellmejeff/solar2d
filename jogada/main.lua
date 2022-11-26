--[[

This is the main.lua file. It executes first and in this demo
is sole purpose is to set some initial visual settings and
then you execute our game or menu scene via composer.

Composer is the official scene (screen) creation and management
library in Corona SDK. This library provides developers with an
easy way to create and transition between individual scenes.

https://docs.coronalabs.com/api/library/composer/index.html

-- ]]

local composer = require('composer')

display.setStatusBar(display.HiddenStatusBar)

-- Removes bottom bar on Android
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
    native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
    native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
end

-- are we running on a simulator?
local isSimulator = "simulator" == system.getInfo( "environment" )

-- if we are load our visual monitor that let's a press of the "F"
-- key show our frame rate and memory usage
if isSimulator then

    -- show FPS
    local visualMonitor = require( "com.ponywolf.visualMonitor" )
    local visMon = visualMonitor:new()
    visMon.isVisible = false

    -- show/hide physics
    local function debugKeys( event )
        local phase = event.phase
        local key = event.keyName
        if phase == "up" then
            if key == "p" then
                physics.show = not physics.show
                if physics.show then
                    physics.setDrawMode( "hybrid" )
                else
                    physics.setDrawMode( "normal" )
                end
            elseif key == "f" then
                visMon.isVisible = not visMon.isVisible
            end
        end
    end
    Runtime:addEventListener( "key", debugKeys )
end

-- go to menu screen
composer.gotoScene( "scene.menu", { params={ } } )
