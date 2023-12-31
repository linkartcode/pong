--[[
    -- Paddle Class -- v 1.0
    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

Paddle = Class{}

function Paddle:init(xOffset, yOffset, settings)
	self.x = xOffset
	self.y = yOffset
	self.downKey = settings.downKey
	self.upKey = settings.upKey
	self.width = settings.width or 5
   self.height = settings.height or 20
	self.speed = settings.speed or 200
   self.aiLevel = settings.aiLevel or 0
	self.mouseControl = settings.mouseControl or false
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

function Paddle:isKeyPress()
	if love.keyboard.isDown(self.upKey) then
		self.dy = -self.speed
	elseif love.keyboard.isDown(self.downKey) then
		self.dy = self.speed
	else
		self.dy = 0
	end
end

function Paddle:isWheelMove(dt)
	self.dy = -gWheelVertMove * dt * self.speed 
end

function Paddle:update(dt)
	if self.aiLevel > 0 then
		self:AI(game.ball)
	elseif self.mouseControl then
		self:isWheelMove(dt)
	else
		self:isKeyPress()
	end
   if self.dy < 0 then
      self.y = math.max(0, self.y + self.dy * dt)
   else
      self.y = math.min(game.virtualHeight - self.height, self.y + self.dy * dt)
   end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end