--[[
	game Pong remake v 1.0 by Roman Protchev @linkartcode
	based on code of the first lesson of GD50 2018
    	Author: Colton Ogden
    	cogden@cs50.harvard.edu
	this version have three levels ai for any player
]]

push = require 'libs.push'
Class = require 'libs.class'

require 'classes.Paddle'
require 'classes.Ball'
require 'classes.Game'

function love.load()

	local windowTitle = 'Pong v 1.0 (c)2023 @linkartcode'
	-- size of our actual window
	local	winWidth = 1280
	local	winHeight = 720

   math.randomseed(os.time())

	-- set filters for crisp pixel graphics
	love.graphics.setDefaultFilter('nearest', 'nearest')
   love.window.setTitle(windowTitle)
	
	game = Game(winWidth, winHeight, {
		paddleSpeed = 200
	})

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
end
-- redefines love.resize through the push module
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
	game:update(dt)
end

function love.keypressed(key)
	game:stateMashine(key)
end

function love.draw()
   -- begin drawing with push, in our virtual resolution
   push:apply('start')

   love.graphics.clear(40/255, 45/255, 52/255, 255/255)
   game:draw()
    -- end our drawing to push
   push:apply('end')
end
