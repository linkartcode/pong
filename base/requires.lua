-- links all necessary files
push = require 'libs.push'
Class = require 'libs.class'

-- files for Game's states model
require 'classes.StateMachine'

require 'classes.BaseState'
require 'game_states.startState'
require 'game_states.serveState'
require 'game_states.playState'
require 'game_states.overState'
require 'game_states.helpState'

require 'classes.Paddle'
require 'classes.Ball'
require 'classes.Game'
