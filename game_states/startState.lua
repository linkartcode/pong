-- The first state to display info
-- from this state you can go to Help state and Serve state
startState = Class{__includes = BaseState}

local function displayPlayers()
	love.graphics.setFont(smallFont)
	love.graphics.print('Player 1', 80, 70)
	if game.player1.aiLevel > 0 then
		love.graphics.print('AI level ' .. tostring(game.player1.aiLevel), 80, 90)
	else
		love.graphics.print('Human', 85, 90)
	end
	love.graphics.print('Player 2', 320, 70)
	if game.player2.aiLevel > 0 then
		love.graphics.print('AI level ' .. tostring(game.player2.aiLevel), 320, 90)
	else
		love.graphics.print('Human', 325, 90)
	end
	love.graphics.printf('Press "'..game.controlKeys.aiPlayer1Key ..'" or "'..game.controlKeys.aiPlayer2Key ..
									'" to change AI of player1 & player2', 0, 150, game.virtualWidth, 'center')
	love.graphics.printf('Press "'..game.controlKeys.wheelToggleKey ..
									'" to toggle on/off mouse wheel conrol for player 2', 0, 160, game.virtualWidth, 'center')
end

function startState:update(dt)
	if isKeyWasPressed(game.controlKeys['serveKey']) then
		game.stateMachine:change('serveState')
	elseif isKeyWasPressed(game.controlKeys['helpKey']) then
		game.stateMachine:change('helpState')
	elseif isKeyWasPressed(game.controlKeys['aiPlayer1Key']) then
		game.player1.aiLevel = (game.player1.aiLevel + 1) % 4
	elseif isKeyWasPressed(game.controlKeys['aiPlayer2Key']) then
		game.player2.aiLevel = (game.player2.aiLevel + 1) % 4
	elseif isKeyWasPressed(game.controlKeys['wheelToggleKey']) then
		game.player2.mouseControl = not game.player2.mouseControl
	end
end

function startState:render()
	love.graphics.setFont(largeFont)
	love.graphics.printf('Welcome to Pong!', 0, 10, game.virtualWidth, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('Press "'..game.controlKeys.serveKey ..'" to begin!', 
			0, 30, game.virtualWidth, 'center')
	love.graphics.printf('Press "'..game.controlKeys.helpKey ..'" for Help', 
			0, 40, game.virtualWidth, 'center')
	displayPlayers()
	game:displayScore()
	game.ball:render()
end
