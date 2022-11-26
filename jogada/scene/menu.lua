-- Requirements
local composer = require "composer"
local button = require('components.button')
local backgroundTiles = {}

-- Variables local to scene
local scene = composer.newScene()
local music, playButton

function scene:create(event)
    local sceneGroup = self.view -- add display objects to this group
    music = audio.loadSound('scene/menu/sfx/titletheme.mp3')
    local tileIdx = 1

    for curX = 0, display.contentWidth, 128 do
        for curY = 0, display.contentHeight, 128 do
            local rect = display.newRect(0, 0, 128, 128)
            rect.anchorX = 0
            rect.anchorY = 0
            rect.x, rect.y = curX, curY
            rect.fill = { type = 'image', filename = 'scene/menu/img/background.png' }
            rect:toBack()
            backgroundTiles[tileIdx] = rect
            tileIdx = tileIdx + 1
        end
    end

    local titleText = {
        parent = sceneGroup,
        x = display.contentCenterX, y = display.contentCenterY,
        text = 'JOGADA',
        font = 'scene/menu/font/Dosis-Bold.ttf',
        fontSize = 104
    }
    display.newText(titleText)

    local subTitleText = {
        parent = sceneGroup,
        x = display.contentCenterX, y = display.contentHeight - 50,
        text = '© 2022 Jeffrey Poore',
        font = 'scene/menu/font/Dosis-Bold.ttf',
        fontSize = 36
    }
    display.newText(subTitleText)
end

local function enterFrame(event)
    local elapsed = event.time

end

function scene:show(event)
    local phase = event.phase
    if (phase == "will") then
        Runtime:addEventListener("enterFrame", enterFrame)
    elseif (phase == "did") then
        playButton = button.new({
            left = display.contentCenterX - 100,
            top = display.contentCenterY + 100,
            label = 'Play',
            fillColor = { 0.3, 0.3, 1, 0.7 },
            activeFillColor = { 0.1, 0.1, 0.8, 1 },
            labelColor = { 1, 1, 1, 1 },
            activeLabelColor = { 1, 1, 1, 1 },
            fontSize = 48,
            strokeWidth = 8,
            strokeColor = { 0.0, 0.0, 0, 0.5 },
            handleButtonEvent = function(evt)
                if (evt.phase == 'ended') then
                    composer.gotoScene('scene.game')
                end
            end
        })

    end
end

function scene:hide(event)
    local phase = event.phase
    if (phase == "will") then

    elseif (phase == "did") then
        Runtime:removeEventListener("enterFrame", enterFrame)
        display.remove(playButton)
        playButton = nil
        for i = 1, #backgroundTiles, 1 do
            display.remove(backgroundTiles[i])
        end
    end
end

function scene:destroy(event)
    --collectgarbage()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene