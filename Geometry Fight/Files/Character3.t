%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SUBPROGRAMS %%%%%

%Checks if the projectile will hit the enemy
%If not, it returns a number to tell the bot if the opponent is above or below
fcn inLine (i : int) : int
    var slope := 0.0
    var y_intercept_0 := .0
    if rez (i) -> m = 0 then
	%drawline (round (rez (i) -> x), 0, round (rez (i) -> x), maxy, black)
	if Math.DistancePointLine (round (player (other (i)) -> x), player (other (i)) -> y, round (rez (i) -> x), 0, round (rez (i) -> x), maxy) < player (other (i)) -> r then
	    result 0
	end if
    else
	slope := rez (i) -> v / rez (i) -> m
	y_intercept_0 := rez (i) -> y - slope * rez (i) -> x
	var y_intercept_max := slope * maxx + y_intercept_0
	%drawline (0, round (y_intercept_0), maxx, round (y_intercept_max), black)
	if Math.DistancePointLine (player (other (i)) -> x, player (other (i)) -> y, 0, round (y_intercept_0), maxx, round (y_intercept_max)) < player (other (i)) -> r then
	    result 0
	end if
    end if
    var y := slope * player (other (i)) -> x + y_intercept_0
    if player (other (i)) -> y > y then
	result 1
    elsif player (other (i)) -> y < y then
	result - 1
    end if
end inLine

%Runs character 3
proc character3 (i : int)

    if testIf (player (i), player (i) -> atk1) and not rez (i) -> attack then
	if mark (i) then
	    track (i) -> attack := true
	    player (i) -> charge := true
	elsif frames - rez (i) -> timer > 70 then
	    new_entity (rez (i))
	    rez (i) -> x := player (i) -> x
	    rez (i) -> y := player (i) -> y
	    rez (i) -> m := player (i) -> direc * rez (i) -> resetm
	    rez (i) -> v := rez (i) -> resetv
	    rez_count (i) := 0
	    rez (i) -> timer := frames
	    rez (i) -> attack := true
	end if
    end if

    if mark (i) then
	if frames - mark_count (i) > 140 then
	    mark (i) := false
	end if
    end if

    %lets you control atk1 and draws it
    if rez (i) -> attack then
	rez (i) -> active
	rez_count (i) += 1
	if moveIf (player (i), player (i) -> up) and abs (rez (i) -> v) < 9 then
	    if rez (i) -> v > 8.5 then
		rez (i) -> v += 9 - rez (i) -> v
	    else
		rez (i) -> v += 0.5
	    end if
	    rez (i) -> m := sign (rez (i) -> m) * sqrt (abs (9 ** 2 - abs (rez (i) -> v ** 2)))
	end if
	if moveIf (player (i), player (i) -> down) and abs (rez (i) -> v) < 9 then
	    if rez (i) -> v < -8.5 then
		rez (i) -> v -= -9 - rez (i) -> v
	    else
		rez (i) -> v -= 0.5
	    end if
	    rez (i) -> m := sign (rez (i) -> m) * sqrt (abs (9 ** 2 - abs (rez (i) -> v ** 2)))
	end if
	if moveIf (player (i), player (i) -> left) and abs (rez (i) -> m) < 9 then
	    if rez (i) -> m < -8.5 then
		rez (i) -> m -= -9 - rez (i) -> m
	    else
		rez (i) -> m -= 0.5
	    end if
	    rez (i) -> v := sign (rez (i) -> v) * sqrt (abs (9 ** 2 - abs (rez (i) -> m ** 2)))
	end if
	if moveIf (player (i), player (i) -> right) and abs (rez (i) -> m) < 9 then
	    if rez (i) -> m > 8.5 then
		rez (i) -> m -= 9 - rez (i) -> m
	    else
		rez (i) -> m += 0.5
	    end if
	    rez (i) -> m += 0.5
	    rez (i) -> v := sign (rez (i) -> v) * sqrt (abs (9 ** 2 - abs (rez (i) -> m ** 2)))
	end if
	% if input ('q') then
	%     rez (i) -> attack := false
	%     remove_entity (rez (i))
	% end if
	if rez_count (i) = 80 then
	    rez (i) -> attack := false
	    remove_entity (rez (i))
	end if
	if hitTest (rez (i), i) then
	    player (other (i)) -> m := sign (rez (i) -> m) * rez (i) -> hitbox -> knock_back
	    rez (i) -> attack := false
	    mark (i) := true
	    mark_count (i) := frames
	end if
    end if
    
    %Uses the distance and gets a ratio to get a set speed for the velocities(m and v)
    if track (i) -> attack then
	player (i) -> drop := true
	var x := player (i) -> x - player (other (i)) -> x
	var y := player (i) -> y - player (other (i)) -> y
	var dis := Math.Distance (player (i) -> x, player (i) -> y, player (other (i)) -> x, player (other (i)) -> y)
	dis := dis / 25
	x := x / dis
	y := y / dis
	player (i) -> m := -x
	player (i) -> v := -y
	player (i) -> direc := sign (player (i) -> m)
	track_hitbox (i) -> x := player (i) -> x
	track_hitbox (i) -> y := player (i) -> y
	% if player (i) -> stun then
	%     mark (i) := false
	%     player (i) -> drop := false
	%     player (i) -> charge := false
	%     track (i) -> attack := false
	%     player (i) -> m := 0
	%     player (i) -> v := 0
	% end if
	if track_hitbox (i) -> hitTest (player (other (i)), 1) then
	    mark (i) := false
	    player (i) -> drop := false
	    player (i) -> charge := false
	    track (i) -> attack := false
	    player (other (i)) -> m := player (i) -> direc * track_hitbox (i) -> knock_back
	    player (i) -> m := 0
	    player (i) -> v := 0
	end if
    end if

    if testIf (player (i), player (i) -> atk2) and frames - tempest (i) -> timer > 80 and proximity (player (i), 200) then
	tempest (i) -> timer := frames
	player (i) -> charge := true
	tempest (i) -> attack := true
	tempest (i) -> x := player (other (i)) -> x
	tempest (i) -> y := player (other (i)) -> y + player (i) -> r * 1.5
	tempest (i) -> lag := 0
	tempest_hitbox_active (i) := true
    end if
    
    %Drops a ball on them
    if tempest (i) -> attack then
	drawfilloval (round (tempest (i) -> x), round (tempest (i) -> y), round (tempest (i) -> r), round (tempest (i) -> r), 42)
	tempest (i) -> y -= 7
	tempest (i) -> lag += 1
	tempest_hitbox (i) -> x := tempest (i) -> x
	tempest_hitbox (i) -> y := tempest (i) -> y
	if player (other (i)) -> ground then
	    if tempest_hitbox_active (i) and tempest_hitbox (i) -> hitTest (player (other (i)), 1) then
		tempest_hitbox_active (i) := false
		player (other (i)) -> m := sign (player (other (i)) -> x - player (i) -> x) * tempest_hitbox (i) -> knock_back
	    end if
	else
	    if tempest_hitbox_active (i) and tempest_hitbox (i) -> hitTest (player (other (i)), 2) then
		tempest_hitbox_active (i) := false
		rez (i) -> timer := -1000
		player (other (i)) -> m := sign (player (other (i)) -> x - player (i) -> x) * tempest_hitbox (i) -> knock_back
	    end if
	end if
	if tempest (i) -> lag = 15 then
	    tempest (i) -> attack := false
	    player (i) -> charge := false
	end if
    end if

end character3

%Runs the bot inputs
proc bot_character3 (i : int)

    bot_keyboard (player (i) -> keyboard)
    if not player (i) -> stun then
	if frames <= 1 then
	    if Rand.Int (1, 3) = 2 then
		player (i) -> keyboard (player (i) -> up) := true
	    end if
	    if Rand.Int (1, 4) = 2 then
		player (i) -> keyboard (player (i) -> atk1) := true
	    end if
	end if

	if not combo (i) then
	    if rez (i) -> attack then
		if rez (i) -> attack and not shield (other (i)) -> attack then
		    if inLine (i) ~= 0 then %Tries to target the opponent
			if abs (rez (i) -> v) > 7.5 then
			    if player (other (i)) -> x > rez (i) -> x then
				player (i) -> keyboard (player (other (i)) -> right) := true
			    elsif player (other (i)) -> x < rez (i) -> x then
				player (i) -> keyboard (player (i) -> left) := true
			    end if
			elsif inLine (i) = 1 then
			    player (i) -> keyboard (player (i) -> up) := true
			elsif inLine (i) = -1 then
			    player (i) -> keyboard (player (i) -> down) := true
			end if
		    end if
		end if
	    elsif not in_rx (i) then
		if player (i) -> x > player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> left) := true
		else
		    player (i) -> keyboard (player (i) -> right) := true
		end if
	    end if

	    if not rez (i) -> attack and player (i) -> test_keyboard (player (i) -> atk1) and proximity (player (i), 700) or mark (i) then
		player (i) -> keyboard (player (i) -> atk1) := true
	    end if

	    if proximity (player (i), 200) and player (i) -> test_keyboard (player (i) -> atk2) then
		player (i) -> keyboard (player (i) -> atk2) := true
	    end if

	    if mark (i) and proximity (player (i), 250) and not track (i) -> attack then
		combo (i) := true
	    end if
	else
	    combo_frames (i) += 1
	    if combo_frames (i) = 30 then
		player (i) -> keyboard (player (i) -> atk1) := true
	    elsif combo_frames (i) = 45 then
		player (i) -> keyboard (player (i) -> atk2) := true
	    elsif combo_frames (i) = 60 then
		player (i) -> keyboard (player (i) -> atk1) := true
		combo (i) := false
		combo_frames (i) := 0
	    end if
	    if not proximity (player (i), 250) then
		combo (i) := false
		combo_frames (i) := 0
	    end if
	end if
    end if
end bot_character3
