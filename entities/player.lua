local Actor = require("entities.actor")


local Player = Actor:extend()


Player.GRAVITY = 1000
Player.ACCELL = 1000
Player.FRICTION = 1000
Player.MAX_GROUND_SPEED = 220
Player.JUMP_SPEED = -300
Player.MAX_FALL_SPEED = 300


function Player:new(x, y)
	Player.super.new(self, x, y, 32, 32)

	self:play(SPR_PLAYER_IDLE)
end


local function approach(v1, v2, step)
    return v1 < v2 and math.min(v1 + step, v2) or math.max(v1 - step, v2)
end


function Player:update(dt)
    do
        local dir = 0

        -- horizontal controls
        if love.keyboard.isDown("a") then dir = dir - 1 end
        if love.keyboard.isDown("d") then dir = dir + 1 end

        local force = dir == 0 and Player.FRICTION or Player.ACCELL
        self.speed_x = approach(self.speed_x, dir * Player.MAX_GROUND_SPEED, force * dt)
    end

    -- jump
    if love.keyboard.isDown("j") and self.is_floor then
        self.speed_y = Player.JUMP_SPEED
    else
        -- gravity
        self.speed_y = approach(self.speed_y, Player.MAX_FALL_SPEED, Player.GRAVITY * dt)
    end

    self:update_image_index(dt)
    self:move_and_slide(dt)
end


return Player
