local level = require("level")
local Sprite = require("sprite")


local screen


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    screen = love.graphics.newCanvas(WIDTH, HEIGHT)

    -- load sprites
    SPR_PLAYER_IDLE = Sprite("assets/player.png", 22, 25)

    level.add_body(require("entities.player")(100, 100))
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