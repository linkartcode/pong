--[[
    class ball v 2.0
]]

Ball = Class{}

function Ball:init(xOffset, yOffset, width, height)
    self.x = xOffset
    self.y = yOffset
    self.width = width
    self.height = height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether ball collides with paddle or not.
]]
function Ball:isCollides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 
    -- if the above aren't true, they're overlapping
    return true
end
-- checks on collide with player and changes velocity of ball and make sound
function Ball:collides(player)
	if self:isCollides(player) then
		if self.dx < 0 then
			self.x = player.x + self.width + 1
		else
			self.x = player.x - self.width
		end
		self.dx = -self.dx * 1.03
		if self.dy < 0 then
			self.dy = -math.random(10, 150)
		else
			self.dy = math.random(10, 150)
		end
		sounds['paddle_hit']:play()
	end
end
-- Places the ball in the center of the screen, with no movement.
function Ball:reset()
    self.x = (game.virtualWidth - self.width) / 2
    self.y = (game.virtualHeight - self.height) / 2
    self.dx = 0
    self.dy = 0
end

-- detect upper and lower screen boundary collision, playing a sound
-- effect and reversing dy if true
function Ball:boundary()
	if self.y <= 0 then
		self.y = 0
		self.dy = -self.dy
		sounds['wall_hit']:play()
	elseif self.y >= game.virtualHeight - self.width then
		self.y = game.virtualHeight - self.width
		self.dy = -self.dy
		sounds['wall_hit']:play()
	end
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end