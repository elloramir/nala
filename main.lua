local screen

function love.load(args)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")

	screen = love.graphics.newCanvas(WIDTH, HEIGHT)
end

function love.update(dt)
end

function love.draw()
	love.graphicsa.setCanvas(screen)
	love.graphics.clear()

	-- game render goes here...

	do
		local w, h = love.graphics.getDimensions()
		local scale = math.min(w/WIDTH, h/HEIGHT)
		local x = (w-WIDTH*scale)*0.5
		local y = (h-HEIGHT*scale)*0.5
	
		love.graphics.setCanvas(nil)
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(screen, x, y, 0, scale, scale)
	end
end