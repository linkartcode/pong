-- State for serve before Play state
serveState = Class{__includes = BaseState}

function serveState:enter()
	game.ball:reset()
end

function serveState:update(dt)
	if isKeyWasPressed(game.controlKeys['serveKey']) then
		game.ball.dy = math.random(-50, 50)
	if game.servingPlayer == 1 then
		game.ball.dx = math.random(70, 100)
	else
		game.ball.dx = -math.random(70, 100)
	end
		game.stateMachine:change('playState')
	end
end

function serveState:render()
	love.graphics.setFont(smallFont)
	love.graphics.printf('Player ' .. tostring(game.servingPlayer) .. "'s serve!", 
		0, 10, game.virtualWidth, 'center')
	love.graphics.printf('Press "'..game.controlKeys.serveKey ..'" to serve!', 
		0, 20, game.virtualWidth, 'center')
	game:displayScore()
	game.ball:render()
end
