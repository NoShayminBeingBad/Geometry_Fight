%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SUBPROGRAMS %%%%%

proc exi
    ex := true
end exi

%Sets up the keyboards
for i : 1 .. upper (test)
    test (chr (i)) := true
    input (chr (i)) := false
end for

%For the mouse click so button won't be acitved but being held down
fcn keydown (i : int) : boolean
    if i ~= 0 and keyup then
	keyup := false
	result true
    end if
    result false
end keydown

%Moves the player, Used to draw the player too
proc draw
    player (1) -> control
    player (2) -> control
end draw

%If the key is not being held down then it is available to be pressed
proc testif
    for i : 1 .. upper (test)
	if not input (chr (i)) then
	    test (chr (i)) := true
	end if
	if not player (1) -> keyboard (chr (i)) then
	    player (1) -> test_keyboard (chr (i)) := true
	end if
	if not player (2) -> keyboard (chr (i)) then
	    player (2) -> test_keyboard (chr (i)) := true
	end if
    end for
end testif

%Gives the other number (mainly to get the other player number)
function other (i : int) : int
    if i = 1 then
	result 2
    elsif i = 2 then
	result 1
    end if
end other

%Tests for input, if the input is available so multiple inputs cannot be done and if player is stunned or charging
function testIf (player : ^character, i : char) : boolean
    if player -> keyboard (i) and player -> test_keyboard (i) and not player -> stun and not player -> charge then
	player -> test_keyboard (i) := false
	result true
    end if
    result false
end testIf

%Same thing but multiple inputs can be done
function moveIf (player : ^character, i : char) : boolean
    if player -> keyboard (i) and not player -> stun and not player -> charge then
	player -> test_keyboard (i) := false
	result true
    end if
    result false
end moveIf

%Special hitTest for projectiles that account for move that block projectiles (shield or relect)
fcn hitTest (move : ^projectile, i : int) : boolean
    if not player (other (i)) -> invins then
	if reflecter (other (i)) -> attack then %If hits the reflect, it sets the projectile
	    if Math.Distance (move -> x, move -> y, round (player (other (i)) -> x), round (player (other (i)) -> y)) < reflecter (other (i)) -> r + move -> r then
		reflected (other (i)) -> pro_num := move -> pro_num
		reflected (other (i)) -> x := move -> x
		reflected (other (i)) -> y := move -> y
		reflected (other (i)) -> v := -move -> v
		reflected (other (i)) -> m := -move -> m
		reflected (other (i)) -> attack := true
		move -> attack := false
		remove_entity (move)
	    end if
	elsif shield (other (i)) -> attack or up_shield (other (i)) -> attack then %If it hits the shield, it move is blocked
	    if move -> x > shield_x (other (i), 1) and move -> x < shield_x (other (i), 2) then
		if move -> y > shield_y (other (i), 1) and move -> y < shield_y (other (i), 2) then
		    move -> attack := false
		    remove_entity (move)
		end if
	    end if
	end if
	if Math.Distance (move -> x, move -> y, player (other (i)) -> x, player (other (i)) -> y) < move -> r + player (other (i)) -> r then %Tests if the projectile hit the opponent. The circle is to show the hitbox
	    %drawfilloval (round (x), round (y), round (r), round (r), yellow)
	    player (other (i)) -> v := move -> hitbox -> knock_up
	    move -> hitbox -> stunned (player (other (i)))
	    player (other (i)) -> hp -= move -> hitbox -> dmg
	    remove_entity (move)
	    result true
	end if
    end if
    result false
end hitTest

%%%%% BOT FNC/PROC %%%%%

%Sets all inputs to false for bots to change every loop
proc bot_keyboard (var keyboard : array char of boolean)
    for i : 1 .. upper (keyboard)
	keyboard (chr (i)) := false
    end for
end bot_keyboard

%Tests if the other player is in close proximity of their x values
fcn in_rx (i : int) : boolean
    if player (other (i)) -> x > player (i) -> x - player (i) -> r and player (other (i)) -> x < player (i) -> x + player (i) -> r then
	result true
    end if
    result false
end in_rx

%Test if the other players touching
fcn in_r (i : int) : boolean
    if Math.Distance (player (other (i)) -> x, player (other (i)) -> y, player (i) -> x, player (i) -> y) < player (i) -> r * 2 then
	result true
    end if
    result false
end in_r

%Tests if the other player is int a certain range
fcn proximity (playy : ^character, range : real) : boolean
    var num := other (playy -> num)
    if Math.Distance (playy -> x, playy -> y, player (num) -> x, player (num) -> y) < range then
	result true
    end if
    result false
end proximity

%Runs thought the entity array to tests if anything is in a certain range
fcn proximity_all (entity : ^entity, range : real) : int
    for i : 1 .. upper (entities)
	if entities (i) -> side ~= entity -> side then
	    if entity -> num ~= i and Math.Distance (round (entity -> x), round (entity -> y), round (entities (i) -> x), round (entities (i) -> y)) < range + entities (i) -> r then
		if entities (i) -> y >= entity -> y + 1.2 * entity -> r then
		    result 2
		elsif entities (i) -> x >= entity -> x then
		    result 3
		elsif entities (i) -> x < entity -> x then
		    result 1
		end if
	    end if
	end if
    end for
    result 0
end proximity_all

%Same thing as before but skips the other player
fcn proximity_project (entity : ^entity, range : real) : int
    for i : 3 .. upper (entities)
	if entities (i) -> side ~= entity -> side then
	    if entity -> num ~= i and Math.Distance (round (entity -> x), round (entity -> y), round (entities (i) -> x), round (entities (i) -> y)) < range + entities (i) -> r then
		if entities (i) -> y >= entity -> y + 1.2 * entity -> r then
		    result 2
		elsif entities (i) -> x >= entity -> x then
		    result 3
		elsif entities (i) -> x < entity -> x then
		    result 1
		end if
	    end if
	end if
    end for
    result 0
end proximity_project

%Pauses the game
proc pause_game
    loop
	Input.KeyDown (input)
	testif
	drawfillbox (500, 230, 780, 370, white)
	drawbox (505, 235, 775, 365, red)
	Font.Draw ("Continue", 550, 315, font_ingame, white)
	Font.Draw ("Exit", 550, 265, font_ingame, white)
	drawfilloval (535, 225 + round (pause_select * 50), 5, 5, white)
	View.UpdateArea (500, 230, 780, 370)
	if input (chr (200)) and test (chr (200)) or input (chr (208)) and test (chr (208)) then
	    test (chr (200)) := not input (chr (200))
	    test (chr (208)) := not input (chr (208))
	    pause_select := other (pause_select)
	end if
	if input (chr (10)) then
	    if pause_select = 1 then
		endgame := true
	    end if
	    exit
	end if
	if input (chr (27)) and test (chr (27)) then
	    test (chr (27)) := false
	    exit
	end if
    end loop
end pause_game

%Return a inputed character to bind controls to that input
fcn change : char
    var c : string (1)
    getch (c)
    result c
end change

%Changes the key bind for a control
proc player1up
    player (1) -> up := change
end player1up
proc player1left
    player (1) -> left := change
end player1left
proc player1right
    player (1) -> right := change
end player1right
proc player1down
    player (1) -> down := change
end player1down
proc player1atk1
    player (1) -> atk1 := change
end player1atk1
proc player1atk2
    player (1) -> atk2 := change
end player1atk2

proc player2up
    player (2) -> up := change
end player2up
proc player2left
    player (2) -> left := change
end player2left
proc player2right
    player (2) -> right := change
end player2right
proc player2down
    player (2) -> down := change
end player2down
proc player2atk1
    player (2) -> atk2 := change
end player2atk1
proc player2atk2
    player (2) -> atk2 := change
end player2atk2

%An array of saves for each frame
var save : flexible array 0 .. 1 of replay

%Saves the inputs on the frame number
proc save_replay (i : int) %i is the frame number
    new save, i
    save (i).p1_up := player (1) -> keyboard (player (1) -> up)
    save (i).p1_left := player (1) -> keyboard (player (1) -> left)
    save (i).p1_right := player (1) -> keyboard (player (1) -> right)
    save (i).p1_down := player (1) -> keyboard (player (1) -> down)
    save (i).p1_atk1 := player (1) -> keyboard (player (1) -> atk1)
    save (i).p1_atk2 := player (1) -> keyboard (player (1) -> atk2)
    save (i).p2_up := player (2) -> keyboard (player (2) -> up)
    save (i).p2_left := player (2) -> keyboard (player (2) -> left)
    save (i).p2_right := player (2) -> keyboard (player (2) -> right)
    save (i).p2_down := player (2) -> keyboard (player (2) -> down)
    save (i).p2_atk1 := player (2) -> keyboard (player (2) -> atk1)
    save (i).p2_atk2 := player (2) -> keyboard (player (2) -> atk2)
end save_replay

%Makes the input equal the array of saves for the replay
proc play_replay (i : int)
    if i <= upper (save) then
	player (1) -> keyboard (player (1) -> up) := save (i).p1_up
	player (1) -> keyboard (player (1) -> left) := save (i).p1_left
	player (1) -> keyboard (player (1) -> right) := save (i).p1_right
	player (1) -> keyboard (player (1) -> down) := save (i).p1_down
	player (1) -> keyboard (player (1) -> atk1) := save (i).p1_atk1
	player (1) -> keyboard (player (1) -> atk2) := save (i).p1_atk2
	player (2) -> keyboard (player (2) -> up) := save (i).p2_up
	player (2) -> keyboard (player (2) -> left) := save (i).p2_left
	player (2) -> keyboard (player (2) -> right) := save (i).p2_right
	player (2) -> keyboard (player (2) -> down) := save (i).p2_down
	player (2) -> keyboard (player (2) -> atk1) := save (i).p2_atk1
	player (2) -> keyboard (player (2) -> atk2) := save (i).p2_atk2
    end if
end play_replay

%Writes the replay to a save file
proc write_replay
    var a : string (1)
    var save_file := true
    var stream : int
    pause_select := 2
    if File.Exists ("Files/savefile.sav") then
	loop
	    Input.KeyDown (input)
	    testif
	    drawfillbox (450, 230, 780, 450, white)
	    drawbox (455, 235, 775, 445, red)
	    Font.Draw ("A save already exist", 505, 395, font_select, white)
	    Font.Draw ("do you want to replace it?", 465, 365, font_select, white)
	    Font.Draw ("Yes", 550, 315, font_ingame, white)
	    Font.Draw ("No", 550, 265, font_ingame, white)
	    drawfilloval (535, 225 + round (pause_select * 50), 5, 5, white)
	    View.UpdateArea (450, 230, 780, 450)
	    if input (chr (200)) and test (chr (200)) or input (chr (208)) and test (chr (208)) then
		test (chr (200)) := not input (chr (200))
		test (chr (208)) := not input (chr (208))
		pause_select := other (pause_select)
	    end if
	    if input (chr (10)) then
		if pause_select = 2 then
		    File.Delete ("savefile.sav")
		    save_file := true
		end if
		if pause_select = 1 then
		    save_file := false
		end if
		exit
	    end if
	end loop
    end if
    if save_file then
	open : stream, "Files/savefile.sav", put
	put : stream, stage_select
	put : stream, select1
	put : stream, select2
	for i : lower(save) .. upper (save)
	    if save (i).p1_up then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p1_left then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p1_right then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p1_down then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p1_atk1 then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p1_atk2 then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p2_up then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p2_left then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p2_right then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p2_down then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p2_atk1 then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	    if save (i).p2_atk2 then
		put : stream, "1"
	    else
		put : stream, "0"
	    end if
	end for
	close : stream
	drawfillbox (450, 230, 780, 450, white)
	drawbox (455, 235, 775, 445, red)
	Font.Draw ("Replay has been saved!", 475, 365, font_select, white)
	Font.Draw ("Press any key to continue", 550, 350, font_subtext, white)
	View.UpdateArea (450, 230, 780, 450)
	getch (a)
    end if
    View.Update
end write_replay

%Reads the replay and saves to the save array
proc read_replay
    var stream : int
    var str : string
    if File.Exists ("Files/savefile.sav") then
	var i := 0
	open : stream, "Files/savefile.sav", get
	get : stream, str
	stage_select := strint (str)
	get : stream, str
	select1 := strint (str)
	get : stream, str
	select2 := strint (str)
	loop
	    new save, i
	    get : stream, str
	    if str = "1" then
		save (i).p1_up := true
	    else
		save (i).p1_up := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p1_left := true
	    else
		save (i).p1_left := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p1_right := true
	    else
		save (i).p1_right := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p1_down := true
	    else
		save (i).p1_down := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p1_atk1 := true
	    else
		save (i).p1_atk1 := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p1_atk2 := true
	    else
		save (i).p1_atk2 := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p2_up := true
	    else
		save (i).p2_up := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p2_left := true
	    else
		save (i).p2_left := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p2_right := true
	    else
		save (i).p2_right := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p2_down := true
	    else
		save (i).p2_down := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p2_atk1 := true
	    else
		save (i).p2_atk1 := false
	    end if
	    get : stream, str
	    if str = "1" then
		save (i).p2_atk2 := true
	    else
		save (i).p2_atk2 := false
	    end if
	    exit when eof (stream)
	    i += 1
	end loop
	rerun := true
    else
	var a : string (1)
	drawfillbox (500, 230, 780, 370, white)
	drawbox (505, 235, 775, 365, red)
	Font.Draw ("There is no save", 515, 315, font_ingame, white)
	Font.Draw ("Press any key to continue", 550, 265, font_subtext, white)
	View.UpdateArea (500, 230, 780, 370)
	getch(a)
	rerun := false
    end if
end read_replay

%Discription for all character
proc dis_1 (i : int)
    Font.Draw ("Attack 1: Puts up a shield", round (395 + 290 * (i - 1)), 245, font_subtext, white)
    Font.Draw ("left/right/up", round (395 + 290 * (i - 1)), 230, font_subtext, white)
    Font.Draw ("Attack 2: Shoots a fire ball", round (395 + 290 * (i - 1)), 185, font_subtext, white)
    Font.Draw ("Can be slightly angled up or", round (395 + 290 * (i - 1)), 170, font_subtext, white)
    Font.Draw ("down", round (395 + 290 * (i - 1)), 155, font_subtext, white)
end dis_1

proc dis_2 (i : int)
    Font.Draw ("Attack 1: Dashes in a held", round (395 + 290 * (i - 1)), 245, font_subtext, white)
    Font.Draw ("direction", round (395 + 290 * (i - 1)), 230, font_subtext, white)
    Font.Draw ("Attack 2: Uses reflecter that", round (395 + 290 * (i - 1)), 185, font_subtext, white)
    Font.Draw ("reflectes projectiles and", round (395 + 290 * (i - 1)), 170, font_subtext, white)
    Font.Draw ("pushes back opponents", round (395 + 290 * (i - 1)), 155, font_subtext, white)
end dis_2

proc dis_3 (i : int)
    Font.Draw ("Attack 1: Shoots a wave of", round (395 + 290 * (i - 1)), 245, font_subtext, white)
    Font.Draw ("energy that can be curved", round (395 + 290 * (i - 1)), 230, font_subtext, white)
    Font.Draw ("and MARKS the target", round (395 + 290 * (i - 1)), 215, font_subtext, white)
    Font.Draw ("MARKED targets can be dashed", round (395 + 290 * (i - 1)), 200, font_subtext, white)
    Font.Draw ("to", round (395 + 290 * (i - 1)), 185, font_subtext, white)
    Font.Draw ("Attack 2: If in range, drop", round (395 + 290 * (i - 1)), 155, font_subtext, white)
    Font.Draw ("ball on top of the opponent", round (395 + 290 * (i - 1)), 140, font_subtext, white)
end dis_3

proc dis_4 (i : int)
    Font.Draw ("Attack 1: Grabs opponents and", round (395 + 290 * (i - 1)), 245, font_subtext, white)
    Font.Draw ("thrown in a direction of choice", round (395 + 290 * (i - 1)), 230, font_subtext, white)
    Font.Draw ("Attack 2: Places a mine (2 max)", round (395 + 290 * (i - 1)), 185, font_subtext, white)
    Font.Draw ("If grabbing someone, MARKS", round (395 + 290 * (i - 1)), 170, font_subtext, white)
    Font.Draw ("the opponent", round (395 + 290 * (i - 1)), 155, font_subtext, white)
    Font.Draw ("MARKS can be reactived to", round (395 + 290 * (i - 1)), 140, font_subtext, white)
    Font.Draw ("explode on the target", round (395 + 290 * (i - 1)), 125, font_subtext, white)
end dis_4

proc dis_5 (i : int)
    Font.Draw ("Attack 1: Teleports in a direction", round (395 + 290 * (i - 1)), 245, font_subtext, white)
    Font.Draw ("Attack 2: Swings a ball, swing", round (395 + 290 * (i - 1)), 185, font_subtext, white)
    Font.Draw ("changes depending of held", round (395 + 290 * (i - 1)), 170, font_subtext, white)
    Font.Draw ("direction", round (395 + 290 * (i - 1)), 155, font_subtext, white)
end dis_5

proc dis_6 (i : int)
    Font.Draw ("Attack 1: ???", round (395 + 290 * (i - 1)), 245, font_subtext, white)
    Font.Draw ("Attack 2: ???", round (395 + 290 * (i - 1)), 185, font_subtext, white)
end dis_6
