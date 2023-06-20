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
	local total_x = self.accum_x+self.speed_x*dt
	local total_y = self.accum_y+self.speed_y*dt

	self.accum_x = total_x % 1
	self.accum_y = total_y % 1

	local pixels_x = math.abs(total_x-self.accum_x)
	local pixels_y = math.abs(total_y-self.accum_y)

	local dir_x = lume.sign(self.speed_x)
	local dir_y = lume.sign(self.speed_y)

	local colides_x = false
	local colides_y = false
	
	for i = 1, pixels_x do
		colides_x = self:place_meeting(dir_x, 0)
		if not colides_x then 
			self.x = self.x + dir_x
		end
	end


	for i = 1, pixels_y do
		colides_y = self:place_meeting(0, dir_y)
		if not colides_y then 
			self.y = self.y + dir_y
		end
	end

	-- reset flags
	self.is_wall = colides_x
	self.is_floor = colides_y and dir_y == 1
	self.is_ceeling = colides_y and dir_y == -1

	-- normal forces
	if colides_x then self.speed_x = 0 end
	if colides_y then self.speed_y = 0 end
end


return Actor
