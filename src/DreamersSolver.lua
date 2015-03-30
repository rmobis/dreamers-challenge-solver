DreamersSolver = { __class = 'DreamersSolver' }
DreamersSolverMT = { __index = DreamersSolver }

--[[
 * Creates a new DreamersSolver object.
 *
 * @param     {DreamersBoard}     board         A DreamersBoard object to be solved
 * @param     {table}             desiredPos    A 2x2 table representing the desired final positions
 *
 * @return    {DreamersSolver}                  A DreamersSolver object
]]
function DreamersSolver:new(board, desiredPos)
    local newObject = {
        board = board,
        desiredPositions = desiredPos
    }

    setmetatable(newObject, DreamersSolverMT)

    return newObject
end

--[[
 * Checks whether the board has been correctly solved.
 *
 * @return    {bool}    Whether the board has been correctly solved
]]
function DreamersSolver:checkBoard()
    return self:checkFirstQuarter() and
        self:checkSecondQuarter() and
        self:checkThirdQuarter() and
        self:checkFourthQuarter()
end

--[[
 * Checks whether the board's first quarter has been correctly solved.
 *
 * @return    {bool}    Whether the board's first quarter has been correctly solved
]]
function DreamersSolver:checkFirstQuarter()
    return self:checkQuarter(2, 2)
end

--[[
 * Checks whether the board's second quarter has been correctly solved.
 *
 * @return    {bool}    Whether the board's second quarter has been correctly solved
]]
function DreamersSolver:checkSecondQuarter()
    return self:checkQuarter(2, 1)
end

--[[
 * Checks whether the board's third quarter has been correctly solved.
 *
 * @return    {bool}    Whether the board's third quarter has been correctly solved
]]
function DreamersSolver:checkThirdQuarter()
    return self:checkQuarter(1, 2)
end

--[[
 * Checks whether the board's fourth quarter has been correctly solved.
 *
 * @return    {bool}    Whether the board's fourth quarter has been correctly solved
]]
function DreamersSolver:checkFourthQuarter()
    return self:checkQuarter(1, 1)
end

--[[
 * Checks whether the board's given quarter has been correctly solved.
 *
 * @param     {number}    qi    The quarter's index on the y-axis
 * @param     {number}    qj    The quarter's index on the x-axis
 *
 * @return    {bool}            Whether the board's given quarter has been correctly solved
]]
function DreamersSolver:checkQuarter(qi, qj)
    local tile = self.desiredPositions[qi][qj]

    for i = ((qi - 1) * 3) + 1, qi * 3  do
        for j = ((qj - 1) * 3) + 1, qj * 3 do
            if self.board:getTile(i, j) ~= tile then
                return false
            end
        end
    end

    return true
end

--[[
 * Solves the whole board.
]]
function DreamersSolver:solveBoard()
    self:solveFirstQuarter()
    self:solveSecondQuarter()
    self:solveThirdQuarter()
end

--[[
 * Solves the first quarter of the board.
]]
function DreamersSolver:solveFirstQuarter()
    local tile = self.desiredPositions[2][2]

    if not self:checkFirstQuarter() then
        self:dropAll(tile, 1, 6)
        self:fillFloor(tile, 1, 6, 5)

        -- Stack
        self.board:shiftVerticallyN(4, 5)
        self.board:shiftVerticallyN(5, 5)
        self.board:shiftVerticallyN(6, 5)
        self.board:shiftHorizontallyN(6, 3)

        -- Fill third row
        for j = 6, 4, -1 do
            if self.board:getTile(4, j) ~= tile then
                local found = false

                for ii = 1, 6 do
                    if found then
                        break
                    end

                    for jj = 1, 6 do
                        if ii <= 3 or jj <= 3 then
                            if self.board:getTile(ii, jj) == tile then
                                if jj >= j then
                                    self.board:shiftHorizontally(ii, 7 - jj)
                                    jj = 1
                                end

                                if ii > 3 then
                                    self.board:shiftVertically(jj, 7 - ii)
                                    ii = 1
                                end

                                self.board:shiftHorizontallyN(ii, self.board:calculateDistance(jj, j - 1))
                                self.board:shiftVerticallyN(j, self.board:calculateDistance(6, ii) - 1)
                                self.board:shiftHorizontally(ii)
                                self.board:shiftVerticallyN(j, self.board:calculateDistance(ii, 6))

                                found = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

--[[
 * Solves the second quarter of the board.
]]
function DreamersSolver:solveSecondQuarter()
    local tile = self.desiredPositions[2][1]

    if not self:checkSecondQuarter() then
        self:dropAll(tile, 1, 3)
        self:fillFloor(tile, 1, 3, 3)

        for j = 1, 3 do
            for i = 5, 4, -1 do
                if self.board:getTile(i, j) ~= tile then
                    local found = false

                    for ii = 1, 4 do
                        if found then
                            break
                        end

                        for jj = 1, 6 do
                            if self.board:getTile(ii, jj) == tile then
                                self.board:shiftHorizontallyN(ii, self.board:calculateDistance(jj, j - 1))
                                self.board:shiftVerticallyN(j, self.board:calculateDistance(6, ii) - 1)
                                self.board:shiftHorizontally(ii)
                                self.board:shiftVerticallyN(j, self.board:calculateDistance(ii, 6))

                                found = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

--[[
 * Solves the third quarter of the board.
]]
function DreamersSolver:solveThirdQuarter()
    local tile = self.desiredPositions[1][2]

    if not self:checkThirdQuarter() then
        self:slideAll(tile, 1, 3)
        self:fillWall(tile, 1, 3, 6)

        for j = 5, 4, -1 do
            for i = 1, 3 do
                if self.board:getTile(i, j) ~= tile then
                    local found = false

                    for ii = 1, 3 do
                        if found then
                            break
                        end

                        for jj = 1, 3 do
                            if self.board:getTile(ii, jj) == tile then
                                if ii == 3 then
                                    if i == 3 then
                                        self.board:shiftVertically(jj)
                                    end

                                    self.board:shiftHorizontallyN(i, self.board:calculateDistance(6, jj) - 1)
                                    self.board:shiftVerticallyN(jj, self.board:calculateDistance(ii, i - (i == 3 and 1 or 0)))
                                else
                                    self.board:shiftVerticallyN(jj, self.board:calculateDistance(ii, i - 1))
                                    self.board:shiftHorizontallyN(i, self.board:calculateDistance(6, jj) - 1)
                                    self.board:shiftVertically(jj)
                                end

                                self.board:shiftHorizontallyN(i, self.board:calculateDistance(jj, 6))
                                self.board:shiftVerticallyN(jj, 6 - self.board:calculateDistance(ii, i))

                                found = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

--[[
 * Shifts every column in the given range containing at least one tile of the type `tile` until its last row has a tile
 * of the type `tile`.
 *
 * @param    {any}       tile      The tile type to be dropped
 * @param    {number}    starts    The start of the columns range
 * @param    {number}    ends      The end of the columns range
]]
function DreamersSolver:dropAll(tile, starts, ends)
    for j = starts, ends do
        for i = 6, 1, -1 do
            if self.board:getTile(i, j) == tile then
                self.board:shiftVerticallyN(j, 6 - i)
                break
            end
        end
    end
end

--[[
 * Shifts every row in the given range containing at least one tile of the type `tile` until its last column has a tile
 * of the type `tile`.
 *
 * @param    {any}       tile      The tile type to be dropped
 * @param    {number}    starts    The start of the rows range
 * @param    {number}    ends      The end of the rows range
]]
function DreamersSolver:slideAll(tile, starts, ends)
    for i = starts, ends do
        for j = 6, 1, -1 do
            if self.board:getTile(i, j) == tile then
                self.board:shiftHorizontallyN(i, 6 - j)
                break
            end
        end
    end
end

--[[
 * Fills the last row's columns in the given range with a tile of type `tile`.
 *
 * @param    {any}       tile        The tile type to be dropped
 * @param    {number}    starts      The start of the columns range
 * @param    {number}    ends        The end of the columns range
 * @param    {number}    maxDepth    The maximum row to look for tiles
]]
function DreamersSolver:fillFloor(tile, starts, ends, maxDepth)
    for j = starts, ends do
        if self.board:getTile(6, j) ~= tile then
            local bi, bj, bd = 0, 0, math.huge

            -- Find best candidate to be moved
            for ii = 1, maxDepth do
                for jj = 1, 6 do
                    if self.board:getTile(ii, jj) == tile then
                        local d = self.board:calculateFullDistance(ii, jj, 6, j)

                        if d < bd then
                            bi, bj, bd = ii, jj, d
                        end
                    end
                end
            end

            self.board:shiftHorizontallyN(bi, self.board:calculateDistance(bj, j))
            self.board:shiftVerticallyN(j, self.board:calculateDistance(bi, 6))
        end
    end
end

--[[
 * Fills the last column's row in the given range with a tile of type `tile`.
 *
 * @param    {any}       tile        The tile type to be dropped
 * @param    {number}    starts      The start of the rows range
 * @param    {number}    ends        The end of the rows range
 * @param    {number}    maxDepth    The maximum column to look for tiles
]]
function DreamersSolver:fillWall(tile, starts, ends, maxDepth)
    for i = starts, ends do
        if self.board:getTile(i, 6) ~= tile then
            local bi, bj, bd = 0, 0, math.huge

            -- Find best candidate to be moved
            for ii = 1, maxDepth do
                for jj = 1, 6 do
                    if self.board:getTile(ii, jj) == tile then
                        local d = self.board:calculateFullDistance(ii, jj, i, 6)

                        if d < bd then
                            bi, bj, bd = ii, jj, d
                        end
                    end
                end
            end

            self.board:shiftVerticallyN(bj, self.board:calculateDistance(bi, i))
            self.board:shiftHorizontallyN(i, self.board:calculateDistance(bj, 6))
            self.board:shiftVerticallyN(bj, self.board:calculateDistance(i, bi))
        end
    end
end
