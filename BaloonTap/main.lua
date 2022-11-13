-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- center background
local background = display.newImageRect('background.png', 360, 570)
background.x = display.contentCenterX
background.y = display.contentCenterY

local tapCount = 0
local tapText = display.newText(tapCount, display.contentCenterX, 20, native.systemFont, 40)
tapText:setFillColor(1, 0, 0)

-- platform near the bottom
local platform = display.newImageRect('platform.png', 300, 50)
platform.x = display.contentCenterX
platform.y = display.contentHeight - 25

-- balloon centered
local balloon = display.newImageRect('balloon.png', 112, 112)
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

-- physics!
local physics = require('physics')
physics.start()

-- add objects
physics.addBody(platform, 'static')
physics.addBody(balloon, "dynamic", { radius=50, bounce=0.5})

local function pushBalloon()
    balloon:applyLinearImpulse(0, -0.75, balloon.x, balloon.y)
    tapCount = tapCount + 1
    tapText.text = tapCount
end

balloon:addEventListener('tap', pushBalloon)