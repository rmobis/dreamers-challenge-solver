WindBotDreamersBoard = {
    __class = 'WindBotDreamersBoard',
    __super = DreamersBoard,

    -- Constants
    BOARD_POSX = 32818,
    BOARD_POSY = 32334,
    BOARD_POSZ = 9,
}

WindBotDreamersBoardMT = table.merge(
    DreamersBoardMT,
    { __index = WindBotDreamersBoard}
)

setmetatable(WindBotDreamersBoard, DreamersBoardMT)

--[[
 * Creates a new WindBotDreamersBoard object.
 *
 * @param     {any}                     ...    Same as DreamersBoard
 *
 * @return    {WindBotDreamersBoard}           A WindBotDreamersBoard object
]]
function WindBotDreamersBoard:new(...)
    local newObject = self.__super:new(...)

    setmetatable(newObject, WindBotDreamersBoardMT)

    return newObject
end

--[[
 * Synchronizes the internal representation of the board with the real one on the Tibia world.
 *
 * @return    {bool}    Whether the synchronization was successful
]]
function WindBotDreamersBoard:synchronize()
    local board = {}

    for i = 1, 6 do
        board[i] = {}

        for j = 1, 6 do
            local x, y = self.BOARD_POSX + j - 1, self.BOARD_POSY + i - 1
            if not tilehasinfo(x, y, self.BOARD_POSZ) then
                return false
            end

            board[i][j] = topitem(x, y, self.BOARD_POSZ).id - 2393
        end
    end

    self:updateBoard(board)
    return true
end
