-- functions provide keyboard and mouse input
-- fills keypressed table
function love.keypressed(key)
	gKeyPressedTable[key] = true
end
-- returns true if the "key" was pressed
function isKeyWasPressed(key)
	return gKeyPressedTable[key]
end

function love.wheelmoved(x, y)
--	mouse wheel speed acceleration
	gWheelVertMove = gWheelVertMove + y * 20
end
