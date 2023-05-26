local Entity = require("engine.entity")


local Player = Entity:extend()


function Player:new(x, y)
	Player.super.new(self, x, y, 32, 32)

	self:play(SPLAYER_IDLE)
	self.image_origin_x = 12
	self.image_origin_y = 12
	self.image_index = 5
end


return Player