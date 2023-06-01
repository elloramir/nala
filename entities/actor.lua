local level = require("level")
local lume = require("libs.lume")
local Entity = require("entity")


local Actor = Entity:extend()


function Actor:new(x, y, width, height)
	Actor.super.new(self)

	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.speed_x = 0
	self.speed_y = 0
	self.accum_x = 0
	self.accum_y = 0

	self.image_scale_x = 1
	self.image_scale_y = 1
	self.image_origin_x = 0
	self.image_origin_y = 0
	self.image_rotation = 0
	self.image_index_timer = 0
	self.image_flipped = false
end


function Actor:play(sprite)
	if self.sprite ~= sprite then
		self.sprite = sprite
		self.image_index = 1
	end
end


function Actor:update_image_index(dt)
	self.image_index_timer = self.image_index_timer + dt
	if self.image_index_timer >= ANIM_SPEED then
		self.image_index_timer = self.image_index_timer - ANIM_SPEED
		self.image_index = self.image_index + 1
		if self.image_index > #self.sprite.images then
			self.image_index = 1
		end
	end
end


function Actor:draw()
	assert(self.sprite)
	love.graphics.setColor(1, 1, 1)
	self.sprite:draw_image_index(
		self.image_index,
		self.x,
		self.y,
		self.image_rotation,
		self.image_scale_x * (self.image_flipped and -1 or 1),
		self.image_scale_y,
		self.image_origin_x,
		self.image_origin_y)
end


function Actor:overlaps(other)
	return
		self.x < other.x + other.width and
		self.x + self.width > other.x and
		self.y < other.y + other.height and
		self.y + self.height > other.y
end


function Actor:place_meeting(ox, oy)
	ox = ox or 0
	oy = oy or 0

	-- check first for tilemaps (fastter)
	local x1 = math.floor((self.x+ox)/TILE_SIZE)
	local y1 = math.floor((self.y+oy)/TILE_SIZE)
	local x2 = math.floor((self.x+self.width+ox-1)/TILE_SIZE)
	local y2 = math.floor((self.y+self.height+oy-1)/TILE_SIZE)
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


-- TODO(ellora): re-refactor this function
function Actor:move_and_slide(dt)
	if self.speed_x ~= 0 then
		self.accum_x = self.accum_x + self.speed_x * dt
		local total = math.floor(self.accum_x)
		if total ~= 0 then -- has at least 1 pixel to move
			self.accum_x = self.accum_x - total
			self.is_wall = false
			local sign = lume.sign(total)
			for _=1, math.abs(total) do
				if not self:place_meeting(sign, 0) then
					self.x = self.x + sign
				else
					self.is_wall = true
					self.speed_x = 0
					self.accum_x = 0
					break
				end
			end
		end
	end
	if self.speed_y ~= 0 then
		self.accum_y = self.accum_y + self.speed_y * dt
		local total = math.floor(self.accum_y)
		if total ~= 0 then -- has at least 1 pixel to move
			self.accum_y = self.accum_y - total
			self.is_floor = false
			local sign = lume.sign(total)
			for _=1, math.abs(total) do
				if not self:place_meeting(0, sign) then
					self.y = self.y + sign
				else
					self.is_floor = true
					self.speed_y = 0
					self.accum_y = 0
					break
				end
			end
		end
	end
end


return Actor