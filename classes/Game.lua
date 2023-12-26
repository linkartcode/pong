--[[
	game Pong remake v 1.0 by Roman Protchev @linkartcode
	class Game the main part of the game
	the states of our game can be any of the following:
 'start' (the beginning of the game, before first serve)
 'help'  (help page)
 'serve' (waiting on a key press to serve the ball)
 'play'  (the ball is in play, bouncing between paddles)
 'win'   (the game is over,  ready for restart)
]]
Game = Class {}

function	Game:init(realWinWidth, realWinHeight, settings)
	self.virtualWidth = 432
	self.virtualHeight = 243

	push:setupScreen(self.virtualWidth, self.virtualHeight, realWinWidth, realWinHeight, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	self.paddleSpeed = settings.paddleSpeed or 200;
	self.paddleWidth = settings.paddleWidth or 5;
	self.paddleHeight = settings.paddleHeight or 20;

	self.player1 = Paddle(10, 30, self.paddleWidth, self.paddleHeight, self.paddleSpeed, 0)
   self.player2 = Paddle(self.virtualWidth - 10, self.virtualHeight - 30, 
									self.paddleWidth, self.paddleHeight, self.paddleSpeed, 0)

	self.ballSize = settings.ballSize or 4;
	self.ball = Ball((self.virtualWidth - self.ballSize)/2, (self.virtualHeight - self.ballSize)/2, 
							self.ballSize, self.ballSize)

	self.winScore = settings.winScore or 10;
	self.player1Score = 0
   self.player2Score = 0
	
	self.servingPlayer = 1
	self.winningPlayer = 0
	self.gameState = 'start'
	self.diplayFPS = true
end

-- made reflection from paddle
function Game:collidePaddle(player)
	if self.ball.dx < 0 then
		self.ball.x = player.x + self.ballSize + 1
	else
		self.ball.x = self.player2.x - self.ballSize
	end
	self.ball.dx = -self.ball.dx * 1.03
	if self.ball.dy < 0 then
		self.ball.dy = -math.random(10, 150)
	else
		self.ball.dy = math.random(10, 150)
	end
	sounds['paddle_hit']:play()
end

function Game:update(dt)
	if self.gameState == 'serve' and self.ball:isStop() then
		self.ball.dy = math.random(-50, 50)
		if self.servingPlayer == 1 then
			self.ball.dx = math.random(140, 200)
		else
			self.ball.dx = -math.random(140, 200)
		end
	elseif self.gameState == 'play' then
		if self.ball:collides(self.player1) then
			self:collidePaddle(self.player1)
		elseif self.ball:collides(self.player2) then
			self:collidePaddle(self.player2)
		end
		 -- detect upper and lower screen boundary collision, playing a sound
		 -- effect and reversing dy if true
		if self.ball.y <= 0 then
			self.ball.y = 0
			self.ball.dy = -self.ball.dy
			sounds['wall_hit']:play()
		elseif self.ball.y >= self.virtualHeight - self.ballSize then
			self.ball.y = self.virtualHeight - self.ballSize
			self.ball.dy = -self.ball.dy
			sounds['wall_hit']:play()
		end
		-- if we reach the left edge of the screen, go back to serve
		-- and update the score and serving player
		if self.ball.x < 0 then
			self.servingPlayer = 1
			self.player2Score = self.player2Score + 1
			sounds['score']:play()
			  -- if we've reached a Win score, the game is over; set the
			  -- state to win so we can show the victory message
			  if self.player2Score == self.winScore then
					self.winningPlayer = 2
					self.gameState = 'win'
			  else
					self.gameState = 'serve'
					-- places the ball in the middle of the screen, no velocity
					self.ball:reset(self.virtualWidth / 2, self.virtualHeight /2)
			  end
		 end
		 -- if we reach the right edge of the screen, go back to serve
		 -- and update the score and serving player
		if self.ball.x > self.virtualWidth then
			self.servingPlayer = 2
			self.player1Score = self.player1Score + 1
			sounds['score']:play()
			-- if we've reached a score of winScore, the game is over; set the
			-- state to win so we can show the victory message
			if self.player1Score == 10 then
				self.winningPlayer = 1
				self.gameState = 'win'
			else
				self.gameState = 'serve'
				-- places the ball in the middle of the screen, no velocity
				self.ball:reset(self.virtualWidth / 2, self.virtualHeight /2)
			end
		end
	end

	-- paddles can move no matter what state we're in
	-- player 1
	if self.player1.aiLevel > 0 then
		self.player1:AI(self.ball)
	else
		if love.keyboard.isDown('w') then
			self.player1.dy = -self.paddleSpeed
		elseif love.keyboard.isDown('s') then
			self.player1.dy = self.paddleSpeed
		else
			self.player1.dy = 0
		end
	end
	-- player 2
	if self.player2.aiLevel > 0  then
		self.player2:AI(self.ball)
	else
		if love.keyboard.isDown('up') then
			self.player2.dy = -self.paddleSpeed
		elseif love.keyboard.isDown('down') then
			self.player2.dy = self.paddleSpeed
		else
			self.player2.dy = 0
		end
	end
	-- update our ball based on its DX and DY only if we're in play state;
	-- scale the velocity by dt so movement is framerate-independent
	if self.gameState == 'play' then
		self.ball:update(dt)
	end
	self.player1:update(dt, self.virtualHeight)
	self.player2:update(dt, self.virtualHeight)
end
-- game is simply in a restart phase here, but will set the serving
-- player to the opponent of whomever won for fairness!
function Game:reset()
	self.gameState = 'serve'
	self.ball:reset(self.virtualWidth / 2, self.virtualHeight /2)
  	-- reset scores to 0
 	self.player1Score = 0
 	self.player2Score = 0

 	-- decide serving player as the opposite of who won
 	if self.winningPlayer == 1 then
		self.servingPlayer = 2
 	else
	 	self.servingPlayer = 1
 	end
end

function Game:stateMashine(key)
	-- for quit
	if key == 'escape' then
		love.event.quit()
	-- for switch displaying FPS or not
	elseif key == 'f' or key == 'F' then
		self.diplayFPS = not self.diplayFPS
	elseif key == 'enter' or key == 'return' or key == 'space' then
		if self.gameState == 'start' then
			self.gameState = 'serve'
		elseif self.gameState == 'help' then
			self.gameState = 'start'
		elseif self.gameState == 'serve' then
			self.gameState = 'play'
		elseif self.gameState == 'win' then
			self:reset()
			self.gameState = 'start'
		end
	-- set up ai level players from 0 level(no ai) to 3(high ai)
	elseif key == '1' or key == '2' and self.gameState == 'start' then								
		if key == '1' then
			self.player1.aiLevel = (self.player1.aiLevel + 1) % 4
		else
			self.player2.aiLevel = (self.player2.aiLevel + 1) % 4
		end
	elseif (key == 'h' or key == 'H') and self.gameState == 'start' then
		self.gameState = 'help'
	end
end

--[[ 
		all functions for output to display
]]
function Game:displayPlayers()
	love.graphics.setFont(smallFont)
	love.graphics.print('Player 1', 80, 70)
	if self.player1.aiLevel > 0 then
		love.graphics.print('AI level ' .. tostring(self.player1.aiLevel), 80, 90)
	else
		love.graphics.print('Human', 85, 90)
	end
	love.graphics.print('Player 2', 320, 70)
	if self.player2.aiLevel > 0 then
		love.graphics.print('AI level ' .. tostring(self.player2.aiLevel), 320, 90)
	else
		love.graphics.print('Human', 325, 90)
	end
	love.graphics.printf('Press 1 or 2 to change AI of player1 & player2', 
										0, 150, self.virtualWidth, 'center')
end
function Game:displayScore()
	-- score display
	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(self.player1Score), self.virtualWidth / 2 - 50,
		self.virtualHeight / 3)
	love.graphics.print(tostring(self.player2Score), self.virtualWidth / 2 + 30,
		self.virtualHeight / 3)
end
function Game:displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
-- displays UI for appropriate states
function Game:drawStartState()
	love.graphics.setFont(smallFont)
	love.graphics.printf('Welcome to Pong!', 0, 10, self.virtualWidth, 'center')
	love.graphics.printf('Press Enter to begin!', 0, 20, self.virtualWidth, 'center')
	love.graphics.printf('Press H for Help', 0, 30, self.virtualWidth, 'center')
	self:displayPlayers()
end
function Game:drawHelpState()
	love.graphics.setFont(largeFont)
	love.graphics.printf('Help page', 0, 40, self.virtualWidth, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('w and s - move player 1 paddle', 0, 80, self.virtualWidth, 'center')
	love.graphics.printf('1 - toggle AI player 1', 0, 90, self.virtualWidth, 'center')

	love.graphics.printf('up and down - move player 2 paddle', 0, 110, self.virtualWidth, 'center')
	love.graphics.printf('2 - toggle AI player 2', 0, 120, self.virtualWidth, 'center')

	love.graphics.printf('f - toggle on/off display FPS', 0, 140, self.virtualWidth, 'center')
	love.graphics.printf('space or enter - to return', 0, 160, self.virtualWidth, 'center')
end
function Game:drawServeState()
	love.graphics.setFont(smallFont)
	love.graphics.printf('Player ' .. tostring(self.servingPlayer) .. "'s serve!", 
		 0, 10, self.virtualWidth, 'center')
	love.graphics.printf('Press Enter to serve!', 0, 20, self.virtualWidth, 'center')
end
function Game:drawWinState()
	love.graphics.setFont(largeFont)
	love.graphics.printf('Player ' .. tostring(self.winningPlayer) .. ' wins!',
		 0, 10, self.virtualWidth, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('Press Enter to restart!', 0, 30, self.virtualWidth, 'center')
end

function Game:draw()
	if self.gameState == 'start' then
		self:drawStartState()
  	elseif self.gameState == 'serve' then
		self:drawServeState()
  	elseif self.gameState == 'win' then
		self:drawWinState()
	elseif self.gameState == 'help' then
		self:drawHelpState()
	end
	if self.gameState ~= 'help' then
		self:displayScore()
		self.ball:render()
	end
   self.player1:render()
   self.player2:render()
	if self.diplayFPS then
		self:displayFPS()
	end
end
