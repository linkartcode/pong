# Game Pong remake v 2.0 by Roman Protchev @linkartcode
	based on code of the first lesson of GD50 2018 by Colton Ogden, cogden@cs50.harvard.edu
	this version based on States Mashine class

	has three levels AI for any players
	0 level for human play

	Control for players:
		player 1, left side of screen		: w - up, s - down
		player 2, right side of screen	: up arrow - up, down arrow - down
			  										  m - toggle on/off mouse wheel control
	
	States:
		start - welcome screen
		help
		serve	- pause before play
		play
		over - victory for one and losing for another
		