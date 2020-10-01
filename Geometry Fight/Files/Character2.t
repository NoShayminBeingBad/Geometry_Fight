%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SUBPROGRAMS %%%%%

%Runs character 2
proc character2 (i : int)
    
    %Dashes in a direction
    if moveIf (player (i), player (i) -> atk1) then

	if player (i) -> keyboard (player (i) -> left) and frames - dash (i) -> timer > 60 or player (i) -> keyboard (player (i) -> right) and frames - dash (i) -> timer > 60 then
	    dash_count (i) := 0
	    player (i) -> v := 0
	    dash (i) -> timer := frames
	    dash (i) -> attack := true
	end if

	if player (i) -> keyboard (player (i) -> up) and player (i) -> jump_count ~= 0 then
	    player (i) -> jump_count := 0
	    up_count (i) := 0
	    player (i) -> m := 0
	    up_dash (i) -> attack := true
	end if

	if player (i) -> keyboard (player (i) -> down) and not player (i) -> ground then
	    down_dash (i) -> attack := true
	end if

    end if
    
    %If you got hit, dash will cancel
    if player (i) -> stun then
	dash (i) -> attack := false
	up_dash (i) -> attack := false
	down_dash (i) -> attack := false
    end if
    
    %Dashes left and right
    if dash (i) -> attack then

	player (i) -> m := player (i) -> direc * 15
	dash_count (i) += 1

	dash_hitbox (i) -> x := player (i) -> x
	dash_hitbox (i) -> y := player (i) -> y

	if dash_hitbox (i) -> hitTest (player (other (i)), 1) then
	    player (other (i)) -> m := player (i) -> direc * dash_hitbox (i) -> knock_back
	end if

	if player (i) -> stun then
	    dash (i) -> attack := false
	end if

	if dash_count (i) = 18 then
	    dash (i) -> attack := false
	    player (i) -> m := 0
	end if

    end if
    
    %Dashes up
    if up_dash (i) -> attack then

	player (i) -> v := 15
	up_count (i) += 1

	dash_hitbox2 (i) -> x := player (i) -> x
	dash_hitbox2 (i) -> y := player (i) -> y

	if dash_hitbox2 (i) -> hitTest (player (other (i)), 1) then
	    player (other (i)) -> m := sign (player (other (i)) -> x - player (i) -> x) * dash_hitbox (i) -> knock_back
	end if

	if player (i) -> stun then
	    up_dash (i) -> attack := false
	end if

	if up_count (i) = 18 then
	    up_dash (i) -> attack := false
	    player (i) -> v := 0
	end if

    end if
    
    %Dashes down
    if down_dash (i) -> attack then

	player (i) -> v := -15

	dash_hitbox2 (i) -> x := player (i) -> x
	dash_hitbox2 (i) -> y := player (i) -> y

	if dash_hitbox2 (i) -> hitTest (player (other (i)), 1) then
	    player (other (i)) -> m := sign (player (other (i)) -> x - player (i) -> x) * dash_hitbox (i) -> knock_back
	end if

	if player (i) -> stun then
	    down_dash (i) -> attack := false
	end if

	if player (i) -> ground then
	    down_dash (i) -> timer := frames
	    player (i) -> charge := true
	end if

	if frames - down_dash (i) -> timer > 20 then
	    player (i) -> charge := false
	    down_dash (i) -> attack := false
	end if

    end if

    if testIf (player (i), player (i) -> atk2) and frames - reflecter (i) -> timer > 60 then
	reflecter (i) -> r := round (player (i) -> r)
	player (i) -> charge := true
	reflecter (i) -> attack := true
	reflecter (i) -> timer := frames
    end if
    
    %Draws the reflector and updates the hitbox
    if reflecter (i) -> attack then

	drawoval (round (player (i) -> x), round (player (i) -> y), round (reflecter (i) -> r), round (reflecter (i) -> r), player (i) -> col)
	drawoval (round (player (i) -> x), round (player (i) -> y), round (reflecter (i) -> r - 1), round (reflecter (i) -> r - 1), player (i) -> col)

	reflecter (i) -> r += 3

	reflecter_hitbox (i) -> x := player (i) -> x
	reflecter_hitbox (i) -> y := player (i) -> y
	reflecter_hitbox (i) -> r := reflecter (i) -> r

	if reflecter_hitbox (i) -> hitTest (player (other (i)), 1) then
	    player (other (i)) -> m := sign (player (other (i)) -> x - player (i) -> x) * reflecter_hitbox (i) -> knock_back
	end if

	if reflecter (i) -> r > 1.7 * player (i) -> r then
	    reflecter (i) -> attack := false
	    player (i) -> charge := false
	end if

	if reflected (i) -> attack then
	    if reflected (i) -> pro_num = 1 then
		fire (i, 1) -> attack := true
		fire (i, 1) -> x := reflected (i) -> x
		fire (i, 1) -> y := reflected (i) -> y
		fire (i, 1) -> v := reflected (i) -> v
		fire (i, 1) -> m := reflected (i) -> m
		new_entity (fire (i, 1))
	    elsif reflected (i) -> pro_num = 2 then
		fire (i, 2) -> attack := true
		fire (i, 2) -> x := reflected (i) -> x
		fire (i, 2) -> y := reflected (i) -> y
		fire (i, 2) -> v := reflected (i) -> v
		fire (i, 2) -> m := reflected (i) -> m
		new_entity (fire (i, 2))
	    elsif reflected (i) -> pro_num = 3 then
		rez (i) -> attack := true
		rez (i) -> x := reflected (i) -> x
		rez (i) -> y := reflected (i) -> y
		rez (i) -> v := reflected (i) -> v
		rez (i) -> m := reflected (i) -> m
		rez_count (i) := rez_count (other (i))
		new_entity (rez (i))
	    end if
	    reflected (i) -> attack := false
	end if

    end if

    if fire (i, 1) -> attack then
	fire (i, 1) -> active
	if hitTest (fire (i, 1), i) then
	    player (other (i)) -> m := sign (fire (i, 1) -> m) * fire (i, 1) -> hitbox -> knock_back
	    fire (i, 1) -> attack := false
	end if
    end if

    if fire (i, 2) -> attack then
	fire (i, 2) -> active
	if hitTest (fire (i, 2), i) then
	    player (other (i)) -> m := sign (fire (i, 2) -> m) * fire (i, 2) -> hitbox -> knock_back
	    fire (i, 2) -> attack := false
	end if
    end if

    if rez (i) -> attack then
	rez_count (i) += 1
	rez (i) -> active
	if hitTest (rez (i), i) then
	    player (other (i)) -> m := sign (rez (i) -> m) * rez (i) -> hitbox -> knock_back
	    rez (i) -> attack := false
	end if
	if rez_count (i) = 80 then
	    rez (i) -> attack := false
	    remove_entity (rez (i))
	end if
    end if

end character2

%Runs the bot inputs
proc bot_character2 (i : int)

    bot_keyboard (player (i) -> keyboard)
    if not player (i) -> stun then
	if frames <= 1 then
	    if Rand.Int (1, 20) > 2 then
		player (i) -> keyboard (player (i) -> atk1) := true
		if player (i) -> x >= player (i) -> x then
		    player (i) -> keyboard (player (i) -> left) := true
		else
		    player (i) -> keyboard (player (i) -> right) := true
		end if
		if Rand.Int (1, 5) >= 3 then
		    if Rand.Int (1, 2) = 1 then
			player (i) -> keyboard (player (i) -> up) := true
		    else
			player (i) -> keyboard (player (i) -> down) := true
		    end if
		end if
	    else
		player (i) -> keyboard (player (i) -> down) := true
	    end if
	end if
	if player (i) -> x > player (other (i)) -> x and not in_rx (i) then
	    player (i) -> keyboard (player (i) -> left) := true
	elsif player (i) -> x < player (other (i)) -> x and not in_rx (i) then
	    player (i) -> keyboard (player (i) -> right) := true
	end if
	
	%Will dash towards the opponent
	if proximity (player (i), 300) then
	    if Rand.Int (1, 2) = 2 then
		player (i) -> keyboard (player (i) -> up) := true
		if player (i) -> x < player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> right) := true
		end if
		if player (i) -> x > player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> right) := false
		    player (i) -> keyboard (player (i) -> left) := true
		end if
	    else
		player (i) -> keyboard (player (i) -> atk1) := true
		if player (i) -> y + player (i) -> r * 1.2 < player (other (i)) -> y then
		    player (i) -> keyboard (player (i) -> up) := true
		end if
		if player (i) -> y - player (i) -> r * 1.2 > player (other (i)) -> y then
		    player (i) -> keyboard (player (i) -> down) := true
		end if
		if player (i) -> x < player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> right) := true
		end if
		if player (i) -> x > player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> right) := false
		    player (i) -> keyboard (player (i) -> left) := true
		end if
	    end if
	end if
	if player (i) -> jump_count <= 1 and not player (i) -> ground then
	    if not up_dash (i) -> attack and not dash (i) -> attack then
		player (i) -> keyboard (player (i) -> down) := true
		player (i) -> keyboard (player (i) -> up) := false
		player (i) -> keyboard (player (i) -> atk1) := true
	    end if
	end if
	
	%If anything is in range, it will start the reflect
	if proximity_all (player (i), 130) ~= 0 and player (i) -> test_keyboard (player (i) -> atk2) then
	    player (i) -> keyboard (player (i) -> atk2) := true
	end if
    end if
end bot_character2

