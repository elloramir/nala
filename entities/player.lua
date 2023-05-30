local Actor = require("entities.actor")


local Player = Actor:extend()


function Player:new(x, y)
	Player.super.new(self, x, y, 32, 32)

	self:play(SPR_PLAYER_IDLE)
end


function Player:update(dt)
    self.x = self.x + 100*dt
    if self.x > WIDTH then
        self.x = 0
    end
    self:update_image_index(dt)
end


return Player