--[[
    -- Paddle Class -- v 1.0
    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

Paddle = Class{}

function Paddle:init(x, y, width, height, speed, aiLevel)
   self.x = x
   self.y = y
   self.width = width
   self.height = height
	self.speed = speed;
   self.aiLevel = aiLevel
	self.dy = 0
end

function Paddle:AI(ball)
	-- chanse for error of movement depends from aiLevel (1-3)
    if math.random(self.aiLevel + 1) == 1 then
        self.dy = 0;
        return
    end
    if self.y > ball.y then
        self.dy = -self.speed
    elseif (self.y + self.height) < (ball.y + ball.height) then
        self.dy = self.speed
    else
        self.dy = 0;
    end
end

function Paddle:update(dt, maxY)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(maxY - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end