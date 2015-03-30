DreamersBoard = { __class = 'DreamersBoard' }
DreamersBoardMT = { __index = DreamersBoard }

--[[
 * Creates a new DreamersBoard object.
 *
 * @param     {table}            board    A 6x6 table representing the board tiles
 * @param     {function}         board    A function to be called before each step; receives a step
 *                                        object and the board instance as parameters
 *
 * @return    {DreamersBoard}             A DreamersBoard object
]]
function DreamersBoard:new(board, stepCallback)
    local newObject = {
        board = board,
        stepCallback = stepCallback
    }
    setmetatable(newObject, DreamersBoardMT)

    return newObject
end

--[[
 * Gets the tile on the given coordinates.
 *
 * @param     {number}    i    The coordinate on the y-axis
 * @param     {number}    j    The coordinate on the x-axis
 *
 * @return    {any}            The tile on the given coordinates
]]
function DreamersBoard:getTile(i, j)
    return self.board[i][j]
end

--[[
 * Updates the board tiles with the giving table.
 *
 * @param    {table}    board    A 6x6 table representing the board tiles
]]
function DreamersBoard:updateBoard(board)
    self.board = board
end

--[[
 * Calculates the distance, as in required movements, from a given index to another.
 *
 * @param     {number}    origin    The origin index
 * @param     {number}    dest      The destination index
 *
 * @return    {number}              The amount of movements needed to go from `origin` index to
 *                                  `dest`.
]]
function DreamersBoard:calculateDistance(origin, dest)
    return ((dest - origin) + 6) % 6
end

--[[
 * Calculates the distance, as in required movements, from a given coordinate to another.
 *
 * @param     {number}    oi    The origin coordinate's y-index
 * @param     {number}    oj    The origin coordinate's x-index
 * @param     {number}    di    The destination coordinate's y-index
 * @param     {number}    dj    The destination coordinate's x-index
 *
 * @return    {number}          The amount of movements needed to go from (`oi`, `oj`) coordinate to
 *                              (`di`, `dj`).
]]
function DreamersBoard:calculateFullDistance(oi, oj, di, dj)
    return self:calculateDistance(oi, di) + self:calculateDistance(oj, dj)
end

--[[
 * Shifts the board vertically on a given column.
 *
 * @param    {number}    col    The column to shift the board on
]]
function DreamersBoard:shiftVertically(col)
    self.stepCallback({
        dir = 'v',
        n   = col
    }, self)

    local tempTile = self.board[6][col]

    for i = 6, 2, -1 do
        self.board[i][col] = self.board[i - 1][col]
    end

    self.board[1][col] = tempTile
end

--[[
 * Shifts the board vertically multiple times on a given column.
 *
 * @param    {number}    col      The column to shift the board on
 * @param    {number}    times    The amount of times to perform the shifting
]]
function DreamersBoard:shiftVerticallyN(col, times)
    times = times % 6

    for i = 1, times do
        self:shiftVertically(col)
    end
end

--[[
 * Shifts the board horizontally on a given row.
 *
 * @param    {number}    row    The row to shift the board on
]]
function DreamersBoard:shiftHorizontally(row)
    self.stepCallback({
        dir = 'h',
        n   = row
    }, self)

    local tempTile = self.board[row][6]

    for j = 6, 2, -1 do
        self.board[row][j] = self.board[row][j - 1]
    end

    self.board[row][1] = tempTile
end

--[[
 * Shifts the board horizontally multiple times on a given row.
 *
 * @param    {number}    row      The row to shift the board on
 * @param    {number}    times    The amount of times to perform the shifting
]]
function DreamersBoard:shiftHorizontallyN(row, times)
    times = times % 6

    for i = 1, times do
        self:shiftHorizontally(row)
    end
end

--[[
 * Produces a string representation of the board.
 *
 * @return    {string}    String representation of the board
]]
function DreamersBoardMT:__tostring()
    local rows = {}

    for _, v in ipairs(self.board) do
        table.insert(rows, table.concat(v, ', '))
    end

    return table.concat(rows, '\n')
end
