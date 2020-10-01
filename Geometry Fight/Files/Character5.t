%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Justin Lai
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SUBPROGRAMS %%%%%

%Runs character 5
proc character5 (i : int)

    %Sets the swing var based off the condition
    if testIf (player (i), player (i) -> atk2) then
	player (i) -> charge := true
	swing (i) -> attack := true
	swing_hitbox_active (i) := true
	swing_count (i) := 0
	if player (i) -> keyboard (player (i) -> left) or player (i) -> keyboard (player (i) -> right) then
	    swing_var (i) := 0
	elsif player (i) -> keyboard (player (i) -> up) then
	    swing_var (i) := 1
	elsif player (i) -> keyboard (player (i) -> down) then
	    if player (i) -> ground then
		swing_var (i) := 2
	    else
		swing_var (i) := 3
	    end if
	else
	    swing_var (i) := 0
	end if
    end if

    %If player gets hit, tp gets canceled
    if player (i) -> stun then
	tp (i) -> attack := false
	player (i) -> charge := false
	player (i) -> r_x := player (i) -> r
	player (i) -> r_y := player (i) -> r
	player (i) -> invins := false
	player (i) -> invis := false
	swing (i) -> attack := false
    end if

    %Draws the swing
    if swing (i) -> attack then
	if swing_var (i) = 0 then
	    swing_count (i) += 5
	    if swing_count (i) <= 65 then
		swing (i) -> y := player (i) -> y - player (i) -> r / 2 + swing_count (i)
		swing (i) -> x := player (i) -> x + player (i) -> direc * 10 * sqrt (swing_count (i))
		swing_hitbox (i) -> x := swing (i) -> x
		swing_hitbox (i) -> y := swing (i) -> y
		if swing_hitbox (i) -> hitTest (player (other (i)), 0) and swing_hitbox_active (i) then
		    swing_hitbox_active (i) := false
		    player (other (i)) -> hp -= 8
		    player (other (i)) -> v := 3.5
		    player (other (i)) -> m := player (i) -> direc * 3
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 45
		    player (other (i)) -> col := player (other (i)) -> stun_col
		end if
	    elsif swing_count (i) <= 90 then
		swing (i) -> y := player (i) -> y - player (i) -> r / 2 + 65
		swing (i) -> x := player (i) -> x + player (i) -> direc * 10 * sqrt (65)
		swing_hitbox (i) -> x := swing (i) -> x
		swing_hitbox (i) -> y := swing (i) -> y
		if swing_hitbox (i) -> hitTest (player (other (i)), 0) and swing_hitbox_active (i) then
		    swing_hitbox_active (i) := false
		    player (other (i)) -> hp -= 8
		    player (other (i)) -> v := 3.5
		    player (other (i)) -> m := player (i) -> direc * 3
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 45
		    player (other (i)) -> col := player (other (i)) -> stun_col
		end if
	    end if
	    if swing_count (i) >= 110 then
		swing (i) -> attack := false
		player (i) -> charge := false
	    end if
	elsif swing_var (i) = 1 then
	    swing_count (i) += 8
	    if swing_count (i) <= 80 then
		swing (i) -> y := player (i) -> y + swing_count (i)
		swing (i) -> x := player (i) -> x
		swing_hitbox (i) -> x := swing (i) -> x
		swing_hitbox (i) -> y := swing (i) -> y
		if swing_hitbox (i) -> hitTest (player (other (i)), 0) and swing_hitbox_active (i) then
		    swing_hitbox_active (i) := false
		    player (other (i)) -> hp -= 14
		    player (other (i)) -> v := 6
		    player (other (i)) -> m := 0
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 55
		    player (other (i)) -> col := player (other (i)) -> stun_col
		end if
	    elsif swing_count (i) <= 125 then
		swing (i) -> y := player (i) -> y + 80
		swing (i) -> x := player (i) -> x
		swing_hitbox (i) -> x := swing (i) -> x
		swing_hitbox (i) -> y := swing (i) -> y
		if swing_hitbox (i) -> hitTest (player (other (i)), 0) and swing_hitbox_active (i) then
		    swing_hitbox_active (i) := false
		    player (other (i)) -> hp -= 11
		    player (other (i)) -> v := 5
		    player (other (i)) -> m := 0
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 55
		    player (other (i)) -> col := player (other (i)) -> stun_col
		end if
	    end if
	    if swing_count (i) >= 145 then
		swing (i) -> attack := false
		player (i) -> charge := false
	    end if
	elsif swing_var (i) = 2 then
	    swing_count (i) += 8
	    if swing_count (i) <= 72 then
		swing (i) -> y := player (i) -> y - swing_count (i) / 72 * player (i) -> r
		swing (i) -> x := player (i) -> x + player (i) -> direc * 15 * sqrt (swing_count (i))
		swing_hitbox (i) -> x := swing (i) -> x
		swing_hitbox (i) -> y := swing (i) -> y
		if swing_hitbox (i) -> hitTest (player (other (i)), 0) and swing_hitbox_active (i) then
		    swing_hitbox_active (i) := false
		    player (other (i)) -> hp -= 12
		    player (other (i)) -> v := 0.7
		    player (other (i)) -> m := player (i) -> direc * 4
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 40
		    player (other (i)) -> col := player (other (i)) -> stun_col
		end if
	    elsif swing_count (i) <= 110 then
		swing (i) -> y := player (i) -> y - player (i) -> r
		swing (i) -> x := player (i) -> x + player (i) -> direc * 13 * sqrt (72)
		swing_hitbox (i) -> x := swing (i) -> x
		swing_hitbox (i) -> y := swing (i) -> y
		if swing_hitbox (i) -> hitTest (player (other (i)), 0) and swing_hitbox_active (i) then
		    swing_hitbox_active (i) := false
		    player (other (i)) -> hp -= 12
		    player (other (i)) -> v := 3
		    player (other (i)) -> m := player (i) -> direc * 4
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 40
		    player (other (i)) -> col := player (other (i)) -> stun_col
		end if
	    end if
	    if swing_count (i) >= 125 then
		swing (i) -> attack := false
		player (i) -> charge := false
	    end if
	elsif swing_var (i) = 3 then
	    swing_count (i) += 5
	    if swing_count (i) <= 150 and not player (i) -> ground then
		swing (i) -> y := player (i) -> y + player (i) -> r * 2 * cosd (swing_count (i) + 120)
		swing (i) -> x := player (i) -> x - player (i) -> r + swing_count (i)
		swing_hitbox (i) -> x := swing (i) -> x
		swing_hitbox (i) -> y := swing (i) -> y
		if swing_hitbox (i) -> hitTest (player (other (i)), 0) and swing_hitbox_active (i) then
		    swing_hitbox_active (i) := false
		    player (other (i)) -> hp -= 9
		    if not player (other (i)) -> ground then
			player (other (i)) -> v := -5
		    else
			player (other (i)) -> v := 5
		    end if
		    player (other (i)) -> m := 0
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 55
		    player (other (i)) -> col := player (other (i)) -> stun_col
		end if
	    end if
	    if swing_count (i) >= 100 then
		swing (i) -> attack := false
		player (i) -> charge := false
	    end if
	end if
	drawfilloval (round (swing (i) -> x), round (swing (i) -> y), round (swing (i) -> r), round (swing (i) -> r), 15)
    end if

    if testIf (player (i), player (i) -> atk1) and frames - tp (i) -> timer > 30 and player (i) -> jump_count > -1 then
	player (i) -> charge := true
	tp (i) -> attack := true
	tp_count (i) := 0
	tp (i) -> timer := frames
	player (i) -> jump_count -= 1
	tp_state (i) := 0
	tp_hitbox_active (i) := true
    end if

    %Runs the animations for the teleport
    if tp (i) -> attack then

	if tp_state (i) = 0 then
	    player (i) -> r_x -= player (i) -> r / 4
	    player (i) -> r_y += player (i) -> r / 4
	    if player (i) -> keyboard (player (i) -> down) or player (i) -> keyboard (player (i) -> up) or player (i) -> keyboard (player (i) -> right) or player (i) -> keyboard (player (i) ->
		    left)
		    then
		if player (i) -> keyboard (player (i) -> down) then
		    tp_y (i) := -1
		elsif player (i) -> keyboard (player (i) -> up) then
		    tp_y (i) := 1
		else
		    tp_y (i) := 0
		end if
		if player (i) -> keyboard (player (i) -> right) then
		    tp_x (i) := 1
		elsif player (i) -> keyboard (player (i) -> left) then
		    tp_x (i) := -1
		else
		    tp_x (i) := 0
		end if
	    else
		tp_y (i) := 1
		tp_x (i) := 0
	    end if
	    if player (i) -> r_y >= player (i) -> r * 2 then
		player (i) -> invis := true
		player (i) -> invins := true
		tp_state (i) := 1
	    end if
	elsif tp_state (i) = 1 then
	    tp_count (i) += 1
	    player (i) -> v := tp_y (i) * 30
	    player (i) -> m := tp_x (i) * 30
	    if tp_count (i) = 10 then
		player (i) -> invis := false
		player (i) -> invins := false
		tp_state (i) := 2
		player (i) -> m := 0
		player (i) -> v := 0
	    end if
	elsif tp_state (i) = 2 then
	    player (i) -> r_x += player (i) -> r / 5
	    player (i) -> r_y -= player (i) -> r / 5
	    tp_hitbox (i) -> x := player (i) -> x
	    tp_hitbox (i) -> y := player (i) -> y
	    if tp_hitbox (i) -> hitTest (player (other (i)), 1) and tp_hitbox_active (i) then
		tp_hitbox_active (i) := false
		player (other (i)) -> m := tp_hitbox (i) -> knock_back
	    end if
	    if player (i) -> r_x >= player (i) -> r then
		player (i) -> r_x := player (i) -> r
		player (i) -> r_y := player (i) -> r
		player (i) -> charge := false
		tp (i) -> attack := false
	    end if
	end if

    end if

end character5

%Runs bot input
proc bot_character5 (i : int)

    bot_keyboard (player (i) -> keyboard)
    if not player (i) -> stun then
	if frames <= 1 then
	    if Rand.Int (1, 3) = 3 then
		player (i) -> keyboard (player (i) -> atk1) := true
	    end if
	    if Rand.Int (1, 2) = 2 then
		player (i) -> keyboard (player (i) -> down) := true
	    end if
	end if

	if player (i) -> x > player (other (i)) -> x and not in_rx (i) then
	    player (i) -> keyboard (player (i) -> left) := true
	elsif player (i) -> x < player (other (i)) -> x and not in_rx (i) then
	    player (i) -> keyboard (player (i) -> right) := true
	end if

	%If other player is in a certain range, but not too close, it will teleport so not to overshoot
	if proximity (player (i), 350) and not proximity (player (i), 120) and player (i) -> test_keyboard (player (i) -> atk1) then
	    var ran := Rand.Int (1, 4)
	    player (i) -> keyboard (player (i) -> atk1) := true
	    if not proximity (player (i), 4 * player (i) -> r) then
		if ran = 1 then
		    player (i) -> keyboard (player (i) -> up) := true
		elsif ran = 2 then
		    player (i) -> keyboard (player (i) -> down) := true
		elsif ran = 3 then
		    if Rand.Int (1, 2) = 1 then
			player (i) -> keyboard (player (i) -> right) := true
		    else
			player (i) -> keyboard (player (i) -> left) := true
		    end if
		end if
	    end if
	end if

	%Jumps after them if the opponent is too high
	if player (other (i)) -> y > player (i) -> y + player (i) -> r * 2 and player (i) -> test_keyboard (player (i) -> up) then
	    player (i) -> keyboard (player (i) -> up) := true
	end if
	
	%If the opponent is in range, teleport
	if proximity_project (player (i), 200) ~= 0 and player (i) -> test_keyboard (player (i) -> atk1) then
	    player (i) -> keyboard (player (i) -> atk1) := true
	end if

	if player (i) -> jump_count = 0 and player (other (i)) -> y > player (i) -> y and player (i) -> test_keyboard (player (i) -> atk1) then
	    player (i) -> keyboard (player (i) -> atk1) := true
	end if

	if player (i) -> jump_count = 0 and not proximity (player (i), 120) and player (i) -> test_keyboard (player (i) -> atk1) then
	    player (i) -> keyboard (player (i) -> atk1) := true
	    player (i) -> keyboard (player (i) -> down) := true
	    player (i) -> keyboard (player (i) -> up) := false
	end if

	%If in range, bot will swing
	if proximity (player (i), player (i) -> r * 2.5) and player (i) -> test_keyboard (player (i) -> atk2) then
	    player (i) -> keyboard (player (i) -> atk2) := true
	    if player (other (i)) -> y > player (i) -> y + player (i) -> r * 1.5 then
		player (i) -> keyboard (player (i) -> right) := false
		player (i) -> keyboard (player (i) -> left) := false
		player (i) -> keyboard (player (i) -> up) := true
	    elsif player (other (i)) -> y < player (i) -> y - player (i) -> r * 1.5 then
		player (i) -> keyboard (player (i) -> right) := false
		player (i) -> keyboard (player (i) -> left) := false
		player (i) -> keyboard (player (i) -> up) := false
		player (i) -> keyboard (player (i) -> down) := true
	    end if
	    if in_r (i) then
		if player (other (i)) -> x > player (i) -> x then
		    player (i) -> keyboard (player (i) -> right) := true
		elsif player (other (i)) -> x < player (i) -> x then
		    player (i) -> keyboard (player (i) -> right) := false
		    player (i) -> keyboard (player (i) -> left) := true
		end if
	    end if
	end if
    end if
end bot_character5
