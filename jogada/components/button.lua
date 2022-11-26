local _M = {}
local widget = require("widget")

function _M.new(options)
    if (options == nil) then
        options = {}
    end
    -- Function to handle button events
    local function handleButtonEvent(event)
        if ("ended" == event.phase) then
            print("Button was pressed and released")
        end
    end

    -- Create the widget
    local button = widget.newButton(
            {
                left = options.left or 100,
                top = options.top or 200,
                shape = options.shape or 'roundedRect',
                fillColor = { default = options.fillColor or { 1, 1, 1, 0.5 }, over = options.activeFillColor or { 0, 0.0, 0.0, 0.5 } },
                strokeColor = { default = options.strokeColor or { 0, 0, 0 }, over = options.activeStrokeColor or { 0.8, 0.8, 0.8 } },
                strokeWidth = options.strokeWidth or 2,
                labelColor = { default = options.labelColor or { 1, 1, 1 }, over = options.activeLabelColor or { 0, 0, 0, 0.5 } },
                fontSize = options.fontSize or 14,
                cornerRadius = options.cornerRadius or 30,
                width = options.width or 200,
                height = options.height or 100,
                id = options.id or 'button',
                label = options.label or "OK",
                onEvent = options.handleButtonEvent or handleButtonEvent
            }
    )
    return button
end

return _M