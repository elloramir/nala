local level = require("level")
local Sprite = require("sprite")


local screen


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    screen = love.graphics.newCanvas(WIDTH, HEIGHT)

    -- load sprites
    SPR_PLAYER_IDLE = Sprite("assets/player_idle.png", 32, 32)
    SPR_PLAYER_JUMP = Sprite("assets/player_jump.png", 32, 32)

    level.add_body(require("entities.player")(100, 100))
    -- straigh line of tiles
    for i = 0, 31 do
        level.set_tile(i, 17)
    end
    -- walls
    for i = 0, 17 do
        level.set_tile(0, i)
        level.set_tile(31, i)
    end
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end


function love.update(dt)
    level.update(dt)
end


function love.draw()
    love.graphics.setCanvas(screen)
    love.graphics.clear()

    level.draw()

    do
        local w, h = love.graphics.getDimensions()
        local scale = math.min(w / WIDTH, h / HEIGHT)
        local x = (w - WIDTH * scale) / 2
        local y = (h - HEIGHT * scale) / 2

        love.graphics.setCanvas()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(screen, x, y, 0, scale, scale)
    end
end