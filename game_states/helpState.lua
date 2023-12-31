-- This state display help info
-- You can get here and get back only from Start state
helpState = Class{__includes = BaseState}

function helpState:update(dt)
	if isKeyWasPressed(game.controlKeys['serveKey']) then
		game.stateMachine:change('startState')
	end
end

function helpState:render()
	love.graphics.setFont(largeFont)
	love.graphics.printf('Help page', 0, 40, game.virtualWidth, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('Win '..tostring(game.winScore) ..' points for victory!', 0, 60, game.virtualWidth, 'center')
	love.graphics.printf('"'..game.controlKeys.upPlayer1Key ..
								'" and "'..game.controlKeys.downPlayer1Key ..
								'" - move player 1  paddle', 0, 80, game.virtualWidth, 'center')
	love.graphics.printf('"'..game.controlKeys.aiPlayer1Key ..'" - toggle AI player 1', 
																		0, 90, game.virtualWidth, 'center')

	love.graphics.printf('"'..game.controlKeys.upPlayer2Key ..
								'" and "'..game.controlKeys.downPlayer2Key ..
								'" - move player 2  paddle', 0, 110, game.virtualWidth, 'center')
	love.graphics.printf('"'..game.controlKeys.aiPlayer2Key ..'" - toggle AI player 2', 
																		0, 120, game.virtualWidth, 'center')

	love.graphics.printf('"'..game.controlKeys.displayFPSKey ..'" - toggle on/off display FPS', 
																		0, 140, game.virtualWidth, 'center')
	love.graphics.printf('"'..game.controlKeys.serveKey ..'" - to return', 
																		0, 160, game.virtualWidth, 'center')
end
