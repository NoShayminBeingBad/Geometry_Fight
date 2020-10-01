%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% SUBPROGRAMS %%%%%

%How to play screen
proc how_to_play
    cls
    drawbox (5, maxy - 35, 80, maxy - 5, white)
    Font.Draw ("Back", 10, maxy - 30, font_select, white)
    Font.Draw ("How to Play", 500, 460, font_title, white)
    Font.Draw ("Fight your opponent with your ball and reduce their hp to 0!", 270, 420, font_select, white)
    Font.Draw ("Different character have a different moveset. Play around", 275, 390, font_select, white)
    Font.Draw ("and see who's your favourite. Use your controls to change", 275, 360, font_select, white)
    Font.Draw ("your character number. Once you both have chosen who you want,", 240, 330, font_select, white)
    Font.Draw ("Select a stage and start your match!", 400, 300, font_select, white)
    View.Update
    loop
	Input.KeyDown (input)
	Mouse.Where (mx, my, o)
	if input (chr (27)) then
	    exit
	end if
	if o ~= 0 then
	    if mx >= 5 and mx <= 80 then
		if my >= maxy - 35 and my <= maxy - 5 then
		    exit
		end if
	    end if
	end if
    end loop
end how_to_play

%replay match screen
proc replay_match

    cls

    reset

    winner := 0

    test (chr (10)) := false

    init_char1
    init_char2
    init_char3

    if stage_select = 3 then
	stagey := -300
    end if
    if stage_select = 2 then
	stagex := 400
    end if

    if select1 = 4 or select2 = 4 then
	init_char4
    end if
    if select1 = 5 or select2 = 5 then
	init_char5
    end if

    loop

	Input.KeyDown (input)
	play_replay (frames) %Replays the move inputs
	testif
	locate (8, 1)
	put "FPS: ", frames_per_sec
	if stage_select = 1 then %Draws the stage
	    stage1
	elsif stage_select = 2 then
	    stage2
	elsif stage_select = 3 then
	    stage3
	elsif stage_select = 4 then
	    stage4
	end if
	draw

	%Procs the movement for the character and the movement too
	if select2 = 4 then
	    character4 (2)
	end if
	if select1 = 4 then
	    character4 (1)
	end if
	if not player (1) -> invis then
	    drawfilloval (round (player (1) -> x), round (player (1) -> y), round (player (1) -> r_x), round (player (1) -> r_y), player (1) -> col)
	    if mark (2) then
		Pic.Draw (marker, round (player (other (2)) -> x - player (2) -> r * 0.5), round (player (other (2)) -> y - player (2) -> r * 0.5), picMerge)
	    end if
	end if
	if not player (2) -> invis then
	    drawfilloval (round (player (2) -> x), round (player (2) -> y), round (player (2) -> r_x), round (player (2) -> r_y), player (2) -> col)
	    if mark (1) then
		Pic.Draw (marker, round (player (other (1)) -> x - player (1) -> r * 0.5), round (player (other (1)) -> y - player (1) -> r * 0.5), picMerge)
	    end if
	end if
	if select1 = 1 then
	    character1 (1)
	elsif select1 = 2 then
	    character2 (1)
	elsif select1 = 3 then
	    character3 (1)
	elsif select1 = 5 then
	    character5 (1)
	end if
	if select2 = 1 then
	    character1 (2)
	elsif select2 = 2 then
	    character2 (2)
	elsif select2 = 3 then
	    character3 (2)
	elsif select2 = 5 then
	    character5 (2)
	end if

	%Draw the hp bars
	drawfillbox (-1, round (maxy * 0.85), round (-1 + (maxx * 0.45) * (player (1) -> hp / 100)), round (maxy * 0.995), player (1) -> col)
	drawfillbox (round (maxx * 0.55 + (maxx * 0.45 * ((100 - player (2) -> hp) / 100))), round (maxy * 0.85), maxx, round (maxy * 0.995), player (2) -> col)
	View.Update
	Time.DelaySinceLast (round (1000 / 61))
	if slow then %Slows the after someone loses
	    player (1) -> charge := true
	    player (2) -> charge := true
	    delay (round (slowdown))
	    slowdown *= 1.2
	end if
	frames += 1 %add the frames
	if Time.Elapsed div 1000 ~= last_update then %Updates the fps every oone second
	    frames_per_sec := round (frames - frames_last)
	    frames_last := frames
	    last_update := Time.Elapsed div 1000
	end if
	if not slow then
	    if player (1) -> hp <= 0 then
		winner += 2
	    end if
	    if player (2) -> hp <= 0 then
		winner += 1
	    end if
	end if
	slow := player (1) -> hp <= 0 or player (2) -> hp <= 0
	if input (chr (27)) and test (chr (27)) then
	    test (chr (27)) := false
	    pause_game
	end if
	exit when endgame or slowdown >= 250
	cls
	drawfillbox(0,0,2000,1000,black)
    end loop

    if not endgame then
	var a : string (1)

	if winner = 3 then
	    Font.Draw ("Tie Game!", 550, 265, font_ingame, white)
	elsif winner = 2 then
	    Font.Draw ("The Winner is Player 2!", 480, 265, font_ingame, white)
	elsif winner = 1 then
	    Font.Draw ("The Winner is Player 1!", 480, 265, font_ingame, white)
	end if
	Font.Draw ("Press any key to continue", 550, 245, font_subtext, white)
	View.Update
	getch (a)

	free_char1
	free_char2
	free_char3

	if select1 = 4 or select2 = 4 then
	    free_char4
	end if
	if select1 = 5 or select2 = 5 then
	    free_char5
	end if

	reset
    end if

    test (chr (10)) := false

end replay_match

%Starts match screen
proc start_match

    cls

    reset

    winner := 0

    test (chr (10)) := false

    if select1 = 6 then
	select1 := Rand.Int (1, 5)
    end if
    if select2 = 6 then
	select2 := Rand.Int (1, 5)
    end if
    if stage_select = 5 then
	stage_select := Rand.Int (1, 4)
    end if


    init_char1
    init_char2
    init_char3

    if stage_select = 3 then
	stagey := -300
    end if
    if stage_select = 2 then
	stagex := 400
    end if

    if select1 = 4 or select2 = 4 then
	init_char4
    end if
    if select1 = 5 or select2 = 5 then
	init_char5
    end if

    loop

	Input.KeyDown (input)
	% if input ('z') then
	%     player (1) -> hp := 0
	%     player (2) -> hp := 0
	% end if

	%Gets the input (if it was set to bot, bot will play)
	if not bot1 then
	    Input.KeyDown (player (1) -> keyboard)
	elsif select1 = 1 then
	    bot_character1 (1)
	elsif select1 = 2 then
	    bot_character2 (1)
	elsif select1 = 3 then
	    bot_character3 (1)
	elsif select1 = 4 then
	    bot_character4 (1)
	elsif select1 = 5 then
	    bot_character5 (1)
	end if
	if not bot2 then
	    Input.KeyDown (player (2) -> keyboard)
	elsif select2 = 1 then
	    bot_character1 (2)
	elsif select2 = 2 then
	    bot_character2 (2)
	elsif select2 = 3 then
	    bot_character3 (2)
	elsif select2 = 4 then
	    bot_character4 (2)
	elsif select2 = 5 then
	    bot_character5 (2)
	end if
	save_replay (frames) %saves the input on the frames for the replay
	testif
	locate (8, 1)
	if stage_select = 1 then
	    stage1
	elsif stage_select = 2 then
	    stage2
	elsif stage_select = 3 then
	    stage3
	elsif stage_select = 4 then
	    stage4
	end if
	draw
	if select2 = 4 then
	    character4 (2)
	end if
	if select1 = 4 then
	    character4 (1)
	end if
	if not player (1) -> invis then
	    drawfilloval (round (player (1) -> x), round (player (1) -> y), round (player (1) -> r_x), round (player (1) -> r_y), player (1) -> col)
	    if mark (2) then
		Pic.Draw (marker, round (player (other (2)) -> x - player (2) -> r * 0.5), round (player (other (2)) -> y - player (2) -> r * 0.5), picMerge)
	    end if
	end if
	if not player (2) -> invis then
	    drawfilloval (round (player (2) -> x), round (player (2) -> y), round (player (2) -> r_x), round (player (2) -> r_y), player (2) -> col)
	    if mark (1) then
		Pic.Draw (marker, round (player (other (1)) -> x - player (1) -> r * 0.5), round (player (other (1)) -> y - player (1) -> r * 0.5), picMerge)
	    end if
	end if
	if select1 = 1 then
	    character1 (1)
	elsif select1 = 2 then
	    character2 (1)
	elsif select1 = 3 then
	    character3 (1)
	elsif select1 = 5 then
	    character5 (1)
	end if
	if select2 = 1 then
	    character1 (2)
	elsif select2 = 2 then
	    character2 (2)
	elsif select2 = 3 then
	    character3 (2)
	elsif select2 = 5 then
	    character5 (2)
	end if
	drawfillbox (-1, round (maxy * 0.85), round (-1 + (maxx * 0.45) * (player (1) -> hp / 100)), round (maxy * 0.995), player (1) -> col)
	drawfillbox (round (maxx * 0.55 + (maxx * 0.45 * ((100 - player (2) -> hp) / 100))), round (maxy * 0.85), maxx, round (maxy * 0.995), player (2) -> col)
	View.Update
	Time.DelaySinceLast (round (1000 / 61))
	if slow then
	    player (1) -> charge := true
	    player (2) -> charge := true
	    delay (round (slowdown))
	    slowdown *= 1.2
	end if
	frames += 1
	if Time.Elapsed div 1000 ~= last_update then
	    frames_per_sec := round (frames - frames_last)
	    frames_last := frames
	    last_update := Time.Elapsed div 1000
	end if
	if not slow then
	    if player (1) -> hp <= 0 then
		winner += 2
	    end if
	    if player (2) -> hp <= 0 then
		winner += 1
	    end if
	end if
	slow := player (1) -> hp <= 0 or player (2) -> hp <= 0
	if input (chr (27)) and test (chr (27)) then
	    test (chr (27)) := false
	    pause_game
	end if
	exit when endgame or slowdown >= 250
	cls
	drawfillbox(0,0,2000,1000,black)
    end loop

    free_char1
    free_char2
    free_char3

    if select1 = 4 or select2 = 4 then
	free_char4
    end if
    if select1 = 5 or select2 = 5 then
	free_char5
    end if

    loop

	Input.KeyDown (input)
	if winner = 3 then
	    Font.Draw ("Tie Game!", 550, 265, font_ingame, white)
	elsif winner = 2 then
	    Font.Draw ("The Winner is Player 2!", 480, 265, font_ingame, white)
	elsif winner = 1 then
	    Font.Draw ("The Winner is Player 1!", 480, 265, font_ingame, white)
	end if
	Font.Draw ("Press enter to continue", 550, 245, font_subtext, white)
	Font.Draw ("Press 0 to save replay", 520, 220, font_select, white)
	if input ('0') then
	    write_replay
	end if
	if input (chr (10)) or input (chr (27)) then
	    exit
	end if
	View.Update

    end loop

    reset
    test (chr (10)) := false

end start_match

%Screen to change controls
proc control
    var up : array 1 .. 2 of int
    var left : array 1 .. 2 of int
    var right : array 1 .. 2 of int
    var down : array 1 .. 2 of int
    var atk1 : array 1 .. 2 of int
    var atk2 : array 1 .. 2 of int
    var back : int
    ex := false
    cls
    loop
	Input.KeyDown (input)
	if input (chr (27)) then
	    exit
	end if
	Font.Draw ("Player 1 Controls", 150, 550, font_title, white)
	Font.Draw ("Player 2 Controls", 870, 550, font_title, white)
	Font.Draw ("Up", 290, 475, font_subtext, white)
	Font.Draw ("Left", 215, 430, font_subtext, white)
	Font.Draw ("Right", 365, 430, font_subtext, white)
	Font.Draw ("Down", 285, 415, font_subtext, white)
	Font.Draw ("Attack 1", 225, 345, font_subtext, white)
	Font.Draw ("Attack 2", 325, 345, font_subtext, white)
	Font.Draw ("Up", maxx - 265, 475, font_subtext, white)
	Font.Draw ("Left", maxx - 345, 430, font_subtext, white)
	Font.Draw ("Right", maxx - 195, 430, font_subtext, white)
	Font.Draw ("Down", maxx - 265, 415, font_subtext, white)
	Font.Draw ("Attack 1", maxx - 325, 345, font_subtext, white)
	Font.Draw ("Attack 2", maxx - 225, 345, font_subtext, white)
	Font.Draw ("Change your contorls here", 575, 475, font_subtext, white)
	Font.Draw ("Select a button, then press a key", 555, 450, font_subtext, white)
	Font.Draw ("to bind the control to a new key", 555, 425, font_subtext, white)
	up (1) := GUI.CreateButton (275, 430, 50, player (1) -> up, player1up)
	left (1) := GUI.CreateButton (200, 370, 50, player (1) -> left, player1left)
	right (1) := GUI.CreateButton (350, 370, 50, player (1) -> right, player1right)
	down (1) := GUI.CreateButton (275, 370, 50, player (1) -> down, player1down)
	atk1 (1) := GUI.CreateButton (225, 300, 50, player (1) -> atk1, player1atk1)
	atk2 (1) := GUI.CreateButton (325, 300, 50, player (1) -> atk2, player1atk2)
	up (2) := GUI.CreateButton (maxx - 275, 430, 50, player (2) -> up, player2up)
	left (2) := GUI.CreateButton (maxx - 350, 370, 50, player (2) -> left, player2left)
	right (2) := GUI.CreateButton (maxx - 200, 370, 50, player (2) -> right, player2right)
	down (2) := GUI.CreateButton (maxx - 275, 370, 50, player (2) -> down, player2down)
	atk1 (2) := GUI.CreateButton (maxx - 325, 300, 50, player (2) -> atk1, player2atk1)
	atk2 (2) := GUI.CreateButton (maxx - 225, 300, 50, player (2) -> atk2, player2atk2)
	back := GUI.CreateButtonFull (10, maxy - 30, 50, "Back", exi, 10, chr (27), false)
	GUI.Refresh
	exit when ex = true
	View.Update
	cls
    end loop
end control

%Character select screen
proc char_select
    cls
    loop
	Mouse.Where (mx, my, o)
	if o = 0 then
	    keyup := true
	end if
	Input.KeyDown (input)
	Input.KeyDown (player (1) -> keyboard)
	Input.KeyDown (player (2) -> keyboard)
	testif
	select_button
	if input ('m') then
	    replay_match
	end if
	if testIf (player (1), player (1) -> up) then
	    select1 -= 2
	elsif testIf (player (1), player (1) -> down) then
	    select1 += 2
	elsif testIf (player (1), player (1) -> right) then
	    select1 += 1
	elsif testIf (player (1), player (1) -> left) then
	    select1 -= 1
	end if
	select1 := max (1, select1)
	select1 := min (6, select1)
	if testIf (player (2), player (2) -> up) then
	    select2 -= 2
	elsif testIf (player (2), player (2) -> down) then
	    select2 += 2
	elsif testIf (player (2), player (2) -> right) then
	    select2 += 1
	elsif testIf (player (2), player (2) -> left) then
	    select2 -= 1
	end if
	drawbox (390, 110, 600, 260, white)
	drawbox (maxx - 390, 110, maxx - 600, 260, white)
	drawbox (400, 30, 550, 70, white)
	Font.Draw ("Controls", 425, 40, font_select, white)
	drawbox (870, 30, 720, 70, white)
	Font.Draw ("Replay", 745, 40, font_select, white)
	drawbox (560, 30, 710, 70, white)
	Font.Draw ("Start!", 600, 40, font_select, white)
	if o ~= 0 then
	    if my >= 30 and my <= 70 then
		if mx >= 720 and mx <= 870 then
		    read_replay
		    if rerun then
			replay_match
		    end if
		end if
		if mx >= 560 and mx <= 710 then
		    start_match
		end if
		if mx >= 425 and mx <= 550 then
		    control
		end if
	    end if
	end if
	select2 := max (1, select2)
	select2 := min (6, select2)
	if not bot2 then
	    Font.Draw ("Player 2", 1080, 40, font_select, brightblue)
	else
	    Font.Draw ("Bot 2", 1080, 40, font_select, brightblue)
	end if
	Font.Draw ("Click to Change", 1080, 15, font_subtext, white)
	if not bot1 then
	    Font.Draw ("Player 1", 100, 40, font_select, brightred)
	else
	    Font.Draw ("Bot 1", 100, 40, font_select, brightred)
	end if
	Font.Draw ("Click to Change", 100, 15, font_subtext, white)
	View.Update
	Time.DelaySinceLast (round (1000 / 61))
	cls
	drawfillbox(0,0,2000,1000,black)
	if input (chr (10)) and test (chr (10)) then
	    start_match
	end if
	if input (chr (27)) and test (chr (27)) then
	    test (chr (27)) := false
	    exit
	end if
	
    end loop
end char_select
