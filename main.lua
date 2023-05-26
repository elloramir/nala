local level = require("engine.level")
local Sprite = require("engine.sprite")


local screen


function love.load(args)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")

	SPLAYER_IDLE = Sprite("assets/player.png", 22, 25, 0.1)

	screen = love.graphics.newCanvas(WIDTH, HEIGHT)

	level.add_body(require("game.player")(100, 100))
end


function love.update(dt)
	level.update(dt)
end


function love.draw()
	love.graphics.setCanvas(screen)
	love.graphics.clear()

	-- game render goes here...
	level.draw()

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