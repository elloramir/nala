local level = require("engine.level")
local lume = require("libs.lume")
local Object = require("libs.classic")


local Entity = Object:extend()


-- entity class are nothing more than a rectangle with a script attached.
function Entity:new(x, y, width, height)
	self.active = false
	self.diff = love.timer.getTime() * 1e-7
	self:set_order(0)

	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.vel_x = 0
	self.vel_y = 0
end


function Entity:set_order(order)
	self.order = order + self.diff
end


function Entity:destroy()
	self.active = false
end


function Entity:update(dt)
end


-- NOTE(ellora): this function are overridable, but i don't recommend do it
function Entity:draw()
end


function Entity:overlaps(other)
	return
		self.x < other.x + other.width and
		self.x + self.width > other.x and
		self.y < other.y + other.height and
		self.y + self.height > other.y
end


function Entity:place_meeting(ox, oy)
	ox = ox or 0
	oy = oy or 0

	-- check first for tilemaps (fastter)
	local x1 = math.floor((self.x+ox)/TILE_SIZE)
	local y1 = math.floor((self.x+ox)/TILE_SIZE)
	local x2 = math.floor((self.x+self.width+ox-1)/TILE_SIZE)
	local y2 = math.floor((self.x+self.width+ox-1)/TILE_SIZE)
	for y=y1, y2 do
		for x=x1, x2 do
			if level.get_tile(x, y) then
				return true
			end
		end
	end
	-- entities check are a bit slower
	for other in pairs(level.physc_group) do
		if other ~= self and self:overlaps(other) then
			return true
		end
	end


	return false
end


function Entity:move(dt)
	local pixels_x = math.abs(self.vel_x*dt)
	local pixels_y = math.abs(self.vel_y*dt)
	local dir_x = lume.sign(self.vel_x)
	local dir_y = lume.sign(self.vel_y)
	for i=1, pixels_x do
		if not self:place_meeting() then
			self.x = self.x+dir_x
		end
	end
	for i=1, pixels_y do
		if not self:place_meeting() then
			self.y = self.y+dir_y
		end
	end
end


return Entity 