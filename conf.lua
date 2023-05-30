WIDTH = 320
HEIGHT = 180
TILE_SIZE = 10
ANIM_SPEED = 0.1

function love.conf(t)
	t.window.title = "nala la nalinha"
	t.window.width = WIDTH*3
	t.window.height = HEIGHT*3
	t.window.resizable = true
	t.window.vsync = true
end