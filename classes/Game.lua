--[[
	game Pong remake v 2.0 by Roman Protchev @linkartcode
	class Game the main part of the game
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
	-- Table consists control keys set
	self.controlKeys = {
		serveKey = 			gServeKey,			-- key for serve and switch between game states
		helpKey = 			gHelpKey,			-- key for enter to help screen
		displayFPSKey =	gDisplayFPSKey,	-- key toggle display on/off
		wheelToggleKey=	gWheelToggleKey,	-- toggles on/off control with mouse wheel for player2

		aiPlayer1Key = 	gAiPlayer1Key,		-- key to change ai player 1
		aiPlayer2Key = 	gAiPlayer2Key,		-- key to change ai player 2

		upPlayer1Key = 	gUpPlayer1Key,		-- key move up player1
		downPlayer1Key = 	gDownPlayer1Key,	-- key move down player1

		upPlayer2Key = 	gUpPlayer2Key,		-- key move up player2
		downPlayer2Key = 	gDownPlayer2Key,	-- key move down player2

		exitKey =			gExitKey				-- key for exit
	}

	--[[	inits players, parameters : x, y start positions, requred parameters
			{	upKey, downKey - keys for movements, requred parameters
				width, height - size of paddle, 5 and 20 by default
				speed - velocity of paddle, 200 by default
				aiLevel - level of AI, 0 - not ai, by default
				mouseControl - controls paddle with mouse's Wheel or not
			}
	]] 
	self.player1 = Paddle(10, 30, {
		upKey =  self.controlKeys.upPlayer1Key, 
		downKey = self.controlKeys.downPlayer1Key
	})
   self.player2 = Paddle(self.virtualWidth - 10, self.virtualHeight - 30,{
		upKey =  self.controlKeys.upPlayer2Key, 
		downKey = self.controlKeys.downPlayer2Key
	})
	-- inits ball object
	local bSize = settings.ballSize or 4;
	self.ball = Ball((self.virtualWidth - bSize)/2, (self.virtualHeight - bSize)/2, bSize, bSize)

	self.player1Score = 0
   self.player2Score = 0
	self.winScore = settings.winScore or 10;
	
	self.servingPlayer = 1
	self.winningPlayer = 0
	self.displayFPS = true

	-- init states of the game
	self.stateMachine = StateMachine {
		['startState'] = function() return startState end,
		['serveState'] = function() return serveState end,
		['playState'] = function() return playState end,
		['overState'] = function() return overState end,
		['helpState'] = function() return helpState end
	}
	self.stateMachine:change('startState')
end

function Game:update(dt)
	if isKeyWasPressed(self.controlKeys.exitKey) then
		love.event.quit()
	elseif isKeyWasPressed(self.controlKeys.displayFPSKey) then
		self.displayFPS = not self.displayFPS
	end
	self.stateMachine:update(dt)
	-- paddles move in all states
	self.player1:update(dt)
	self.player2:update(dt)
end

-- game is simply in a restart phase here, but will set the serving
-- player to the opponent of whomever won for fairness!
function Game:reset()
	self.ball:reset()
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

function Game:displayScore()
	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(self.player1Score), self.virtualWidth / 2 - 50,
		self.virtualHeight / 3)
	love.graphics.print(tostring(self.player2Score), self.virtualWidth / 2 + 30,
		self.virtualHeight / 3)
end

function Game:showFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function Game:render()
	self.stateMachine:render()
	self.player1:render()
   self.player2:render()
	if self.displayFPS then
		self:showFPS()
	end
end
