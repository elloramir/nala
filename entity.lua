local Object = require("libs.classic")


local Entity = Object:extend()


function Entity:new(order)
    self.active = false
    self.created_at = love.timer.getTime()*1e-7
    self:set_order(order or 0)
end


function Entity:set_order(order)
    self.order = order + self.created_at
end


function Entity:destroy()
    self.active = false
end


function Entity:draw()
end


return Entity