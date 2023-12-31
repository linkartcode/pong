
overState = Class{__includes = BaseState}

function overState:update(dt)
	if isKeyWasPressed(game.controlKeys['serveKey']) then
		game:reset()
		game.stateMachine:change('startState')
	end
end

function overState:render()
	love.graphics.setFont(largeFont)
	love.graphics.printf('Player ' .. tostring(game.winningPlayer) .. ' wins!',
		 0, 10, game.virtualWidth, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('Press "'..game.controlKeys.serveKey ..'" to restart!', 0, 30, game.virtualWidth, 'center')
	game:displayScore()
end
