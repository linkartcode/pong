
playState = Class{__includes = BaseState}

function playState:update(dt)
	game.ball:collides(game.player1)
	game.ball:collides(game.player2)
	game.ball:boundary()
	-- check for goal
	if game.ball.x < 0 then
		game.servingPlayer = 1
		game.player2Score = game.player2Score + 1
		sounds['score']:play()
		if game.player2Score == game.winScore then
			game.winningPlayer = 2
			game.stateMachine:change('overState')
		else
			game.stateMachine:change('serveState')
		end
	elseif game.ball.x > game.virtualWidth then
		game.servingPlayer = 2
		game.player1Score = game.player1Score + 1
		sounds['score']:play()
		if game.player1Score == game.winScore then
			game.winningPlayer = 1
			game.stateMachine:change('overState')
		else
			game.stateMachine:change('serveState')
		end
	end
	game.ball:update(dt)
end

function playState:render()
	game:displayScore()
	game.ball:render()
end
