--[[
	game Pong remake v 2.1 by Roman Protchev @linkartcode
	based on code of the first lesson of GD50 2018 by Colton Ogden(cogden@cs50.harvard.edu)
	this version based on States Mashine class
	and have three levels AI for any players
	0 level for human play
]]

require 'base.requires'
require 'base.constants'
require 'base.input'

function love.load()

	math.randomseed(os.time())

	local windowTitle = gWindowTitle
	-- size of our actual window
	local	winWidth = gWinWidth
	local	winHeight = gWinHeight

	-- set filters for crisp pixel graphics
	love.graphics.setDefaultFilter('nearest', 'nearest')
   love.window.setTitle(windowTitle)

	-- initialize our nice-looking retro text fonts
   smallFont = love.graphics.newFont('fonts/font.ttf', 8)
   largeFont = love.graphics.newFont('fonts/font.ttf', 16)
   scoreFont = love.graphics.newFont('fonts/font.ttf', 32)
   love.graphics.setFont(smallFont)

	-- set up our sound effects; later, we can just index this table and
   sounds = {
      ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
      ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
      ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
   }

	game = Game(winWidth, winHeight, {
		paddleSpeed = gPaddleSpeed,
		winScore = gWinScore
	})
	-- inits table to hold pressed keys
	gKeyPressedTable = {}
	-- reset mouse wheel velocity
	gWheelVertMove = 0;
end
-- redefines love.resize through the push module
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
	game:update(dt)
	-- resets keypressed Table in the end of update cycle
	gKeyPressedTable = {}
	-- mouse wheel speed decay
	gWheelVertMove = gWheelVertMove - gWheelVertMove * math.min(dt * 10, 1)
end

function love.draw()
   -- begin drawing with push, in our virtual resolution
   push:apply('start')
	-- fill all screen with the color
   love.graphics.clear(40/255, 45/255, 52/255, 255/255)
	
   game:render()

    -- end our drawing to push
   push:apply('end')
end
