WIDTH = 320
HEIGHT = 180
TILE_SIZE = 10

function love.conf(t)
	t.window.title = "nala nalinha"
	t.window.width = WIDTH*3
	t.window.height = HEIGHT*3
	t.window.resizable = true
	t.window.vsync = true
end