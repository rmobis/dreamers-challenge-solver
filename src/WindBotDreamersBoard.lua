WindBotDreamersBoard = {
    __class = 'WindBotDreamersBoard',
    __super = DreamersBoard,

    -- Constants
    BOARD_POSX = 12345,
    BOARD_POSY = 12345,
    BOARD_POSZ = 12345,
}

WindBotDreamersBoardMT = table.merge(
    DreamersBoardMT,
    { __index = WindBotDreamersBoard}
)

setmetatable(WindBotDreamersBoard, DreamersBoardMT)

--[[
 * Synchronizes the internal representation of the board with the real one on the Tibia world.
 *
 * @return    {bool}    Whether the synchronization was successful
]]
function WindBotDreamersBoard:synchronize()
    local board = {}

    for y = self.BOARD_POSY, self.BOARD_POSY + 5 do
        self.board[y] = {}

        for x = self.BOARD_POSX, self.BOARD_POSX + 5 do
            if not tilehasinfo(x, y, self.BOARD_POSZ) then
                return false
            end

            board[y][x] = topitem(x, y, self.BOARD_POSZ).id
        end
    end

    self:updateBoard(board)
    return true
end
