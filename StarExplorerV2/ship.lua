local module = {}

local function isEmpty(object)
    return object == nil
end

module.init = function(physics, group, sheet, state)
    module.physics = physics
    module.group = group
    module.sheet = sheet
    module.state = state
end

module.createShip = function()
    module.ship = display.newImageRect(module.group, module.sheet, 4, 98, 79)
    module.ship.x = display.contentCenterX
    module.ship.y = display.contentHeight - 100
    module.physics.addBody(module.ship, { radius = 30, isSensor = true })
    module.ship.myName = 'ship'
    module.ship:addEventListener('touch', module.dragShip)
end

module.restoreShip = function()
    module.ship.isBodyActive = false
    module.ship.x = display.contentCenterX
    module.ship.y = display.contentHeight - 100

    -- fade in the ship
    transition.to(module.ship, { alpha = 1, time = 4000,
                                 onComplete = function()
                                     module.ship.isBodyActive = true
                                     module.state.died = false
                                 end
    })
end

module.fireLaser = function(offset)
    if (not isEmpty(module.ship) and not isEmpty(module.ship.x)) then
        local newLaser = display.newImageRect(module.group, module.sheet, 5, 14, 40)
        physics.addBody(newLaser, 'dynamic', { isSensor = true })
        newLaser.isBullet = true
        newLaser.myName = 'laser'
        newLaser.x = module.ship.x + offset
        newLaser.y = module.ship.y
        newLaser:toBack()
        transition.to(newLaser, { x = newLaser.x + offset * 5, y = -40 - (display.contentHeight - module.ship.y), time = 400,
                                  onComplete = function()
                                      display.remove(newLaser)
                                  end
        })
    end
end

module.fireLasers = function()
    module.fireLaser(-20)
    module.fireLaser(-10)
    module.fireLaser(-5)
    module.fireLaser(5)
    module.fireLaser(10)
    module.fireLaser(20)
end

module.dragShip = function(event)
    if (not module.state.paused) then
        local target = event.target
        local phase = event.phase
        target.touchOffsetX = 0
        target.touchOffsetY = 0
        if ('began' == phase) then
            -- set touch focus on ship
            display.currentStage:setFocus(module.ship)
            -- store initial offset position
            target.touchOffsetX = event.x - target.x
            target.touchOffsetY = event.y - target.y
        elseif ('moved' == phase) then
            -- move the ship to the new touch position
            target.x = event.x - target.touchOffsetX
            target.y = event.y - target.touchOffsetY

            -- make sure ship can't be dragged off-screen :)
            if (target.x < 150) then
                target.x = 150
            elseif (target.x > display.contentWidth - 150) then
                target.x = display.contentWidth - 155

            end
            if (target.y < 50) then
                target.y = 50
            elseif (target.y > display.contentHeight - 50) then
                target.y = display.contentHeight - 50
            end
        elseif ('ended' == phase or 'cancelled' == phase) then
            -- release touch focus on the ship
            display.currentStage:setFocus(nil)
        end
    end
    return true
end

module.shipDestroyed = function(gameOver)
    if (gameOver) then
        display.remove(module.ship)
    else
        module.ship.alpha = 0
        timer.performWithDelay(1000, module.restoreShip)
    end
end

return module