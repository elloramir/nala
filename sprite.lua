local lume = require("libs.lume")
local Object = require("libs.classic")


local Sprite = Object:extend()


-- cache image for future calls. we may want a content manage
-- for that, but all textures are small enough to load fast (for while)
local load_image = lume.memoize(function(filename)
	return love.graphics.newImage(filename)
end)


function Sprite:new(filename, cell_w, cell_h)
	self.image = load_image(filename)
	self.cell_w = cell_w
	self.cell_h = cell_h
	self.images = {}
	for y=0, self.image:getHeight()-cell_h, cell_h do
		for x=0, self.image:getWidth()-cell_w, cell_w do
			table.insert(self.images, love.graphics.newQuad(x, y, cell_w, cell_h, self.image))
		end
	end 
end


function Sprite:draw_image_index(index, ...)
	assert(index <= #self.images)
	love.graphics.draw(self.image, self.images[index], ...)
end


return Sprite