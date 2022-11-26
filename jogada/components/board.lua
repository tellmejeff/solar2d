local _M = {}
local levels = require('config.levels')
local gameConfig = require('config.gameConfig')

local function getColor(type)
    if type == 'BD' then
        return 0, 0, 1
    elseif type == 'RD' then
        return 1, 0, 0
    elseif type == 'GD' then
        return 0, 1, 0
    elseif type == 'BG' then
        return 0, 0, 0.6
    elseif type == 'GG' then
        return 0, 0.6, 0
    elseif type == 'RG' then
        return 0.6, 0, 0
    elseif type == 'W' then
        return 0.5, 0.5, 0.5
    end
end

local function isDot(type)
    return type == 'BD' or type == 'GD' or type == 'RD'
end

local function isGoal(type)
    return type == 'BG' or type == 'GG' or type == 'RG'
end

local function isMovable(piece, row, col)
    local type = piece.type
    return type == 'BD' or type == 'GD' or type == 'RD'
end

local function isValidDestination(piece, row, col)
    if (piece.moving) then
    end
    local type = piece.type
    local moving = piece.moving
    return type == ' ' or type == 'BG' or type == 'GG' or type == 'RG' or moving
end

local function isCorrect(pieceType, cellType)
    return (pieceType == 'BD' and cellType == 'BG') or
            (pieceType == 'GD' and cellType == 'GG') or
            (pieceType == 'RD' and cellType == 'RG')
end

function _M.new()
    -- board display object
    local board = display.newGroup()
    board.anchorChildren = true
    board.anchorX = 0
    board.anchorY = 0
    board:addEventListener('touch', board)

    function board:newPiece(row, col)
        local cellSize = board.cellSize
        if not board.removeSelf then
            return false
        end
        print('adding piece at ' .. row .. ', ' .. col)
        local piece = board.pieces[row][col]
        local type = piece.type

        if isDot(type) then
            piece.shape = display.newCircle(self, col * cellSize, row * cellSize, cellSize * gameConfig.dotRadius)
        elseif type == 'W' then
            piece.shape = display.newRect(self, col * cellSize, row * cellSize, cellSize * gameConfig.wallSideLen, cellSize * gameConfig.wallSideLen)
        end
        piece.type = type
        if (piece.shape) then
            piece.shape:setFillColor(getColor(type))
        end
    end

    function board:movePiecesUpOrDown(down)
        local rows = board.rows
        local cols = board.cols
        for col = 1, cols do
            if (down) then
                for row = rows - 1, 1, -1 do
                    local piece = board.pieces[row][col]
                    if isMovable(piece, row, col) then
                        local pieceBelow = board.pieces[row + 1][col]
                        if (isValidDestination(pieceBelow, row + 1, col)) then
                            board.pieces[row][col].moving = true
                        end
                    end
                end
                for row = rows - 1, 1, -1 do
                    local piece = board.pieces[row][col]
                    if piece.moving then
                        board.pieces[row + 1][col] = piece
                        board.pieces[row][col] = { type = ' ' }
                        transition.to(piece.shape, { time = gameConfig.pieceTransitionTime, x = col * board.cellSize, y = (row + 1) * board.cellSize, transition = easing.outSine })
                        piece.moving = false
                    end
                end
            else
                for row = 2, rows do
                    local piece = board.pieces[row][col]
                    if isMovable(piece, row, col) then
                        local pieceAbove = board.pieces[row - 1][col]
                        if (isValidDestination(pieceAbove, row - 1, col)) then
                            piece.moving = true
                        end
                    end
                end
                for row = 2, rows do
                    local piece = board.pieces[row][col]
                    if piece.moving then
                        board.pieces[row - 1][col] = piece
                        board.pieces[row][col] = { type = ' ' }
                        transition.to(piece.shape, { time = gameConfig.pieceTransitionTime, x = col * board.cellSize, y = (row - 1) * board.cellSize, transition = easing.outSine })
                        piece.moving = false
                    end
                end
            end
        end
    end

    function board:movePiecesLeftOrRight(right)
        local rows = board.rows
        local cols = board.cols
        for row = 1, rows do
            if (right) then
                for col = cols - 1, 1, -1 do
                    local piece = board.pieces[row][col]
                    if isMovable(piece, row, col) then
                        local pieceToRight = board.pieces[row][col + 1]
                        if (isValidDestination(pieceToRight, row, col + 1)) then
                            piece.moving = true
                        end
                    end
                end
                for col = cols - 1, 1, -1 do
                    local piece = board.pieces[row][col]
                    if piece.moving then
                        board.pieces[row][col + 1] = piece
                        board.pieces[row][col] = { type = ' ' }
                        transition.to(piece.shape, { time = gameConfig.pieceTransitionTime, x = (col + 1) * board.cellSize, y = row * board.cellSize, transition = easing.outSine })
                        piece.moving = false
                    end
                end
            else
                for col = 2, cols do
                    local piece = board.pieces[row][col]
                    if isMovable(piece, row, col) then
                        local pieceToLeft = board.pieces[row][col - 1]
                        if (isValidDestination(pieceToLeft, row, col - 1)) then
                            piece.moving = true
                        end
                    end
                end
                for col = 2, cols do
                    local piece = board.pieces[row][col]
                    if piece.moving then
                        board.pieces[row][col - 1] = piece
                        board.pieces[row][col] = { type = ' ' }
                        transition.to(piece.shape, { time = gameConfig.pieceTransitionTime, x = (col - 1) * board.cellSize, y = row * board.cellSize, transition = easing.outSine })
                        piece.moving = false
                    end
                end
            end
        end
    end

    function board:onLevelComplete(callback)
        board.callback = callback
    end

    function board:checkForWin()
        local piecesFound = 0
        local piecesCorrect = 0
        local layout = board.level.layout
        local pieces = board.pieces
        local rows = board.rows
        local cols = board.cols
        for row = 1, rows do
            for col = 1, cols do
                local piece = pieces[row][col]
                if isDot(piece.type) then
                    piecesFound = piecesFound + 1
                    if isCorrect(piece.type, layout[row][col]) then
                        piecesCorrect = piecesCorrect + 1
                    end
                end
            end
        end
        if piecesFound == piecesCorrect and board.callback then
            board.callback()
        end
    end

    function board:touch(event)
        local target = event.target
        local phase = event.phase
        if ('began' == phase) then
            target.startX = event.x
            target.startY = event.y
        elseif ('ended' == phase) then
            -- move the ship to the new touch position
            local endX = event.x - target.startX
            local endY = event.y - target.startY
            if math.abs(endX) > math.abs(endY) and math.abs(endX) > gameConfig.moveThreshold then
                board:movePiecesLeftOrRight(endX > 0)
            elseif math.abs(endY) > gameConfig.moveThreshold then
                board:movePiecesUpOrDown(endY > 0)
            end
            board:checkForWin()
        end
        return true
    end

    function board:reset()
        local spaces = board.spaces
        local pieces = board.pieces
        for row = 1, #spaces do
            local cols = spaces[row]
            for col = 1, #cols do
                spaces[row][col]:removeSelf()
                if pieces[row][col].shape then
                    pieces[row][col].shape:removeSelf()
                end
            end
        end
    end

    function board:loadLevel(n)
        board.level = levels[n]
        board.rows = board.level.rows or 3
        board.cols = board.level.cols or 3
        local layout = board.level.layout
        board.cellSize = (display.actualContentWidth / board.cols)

        if board.spaces then
            board:reset()
        end

        -- make the empty board
        board.spaces = {}
        board.pieces = {}
        for row = 1, board.rows do
            board.spaces[row] = {}
            board.pieces[row] = {}
            for col = 1, board.cols do
                board.spaces[row][col] = display.newRoundedRect(board, col * board.cellSize, row * board.cellSize, board.cellSize - 2, board.cellSize - 2, board.cellSize * 0.05)
                if isGoal(board.level.layout[row][col]) then
                    board.spaces[row][col]:setFillColor(getColor(board.level.layout[row][col]))
                else
                    board.spaces[row][col]:setFillColor(0.3, 0.3, 1)
                end
                board.spaces[row][col]:setStrokeColor(0.2, 0.2, 0.5)
                board.spaces[row][col].strokeWidth = 5
                board.spaces[row][col]:toBack()
                board.pieces[row][col] = {type = board.level.layout[row][col]}
                board:newPiece(row, col)
            end
        end
    end
    return board
end

return _M