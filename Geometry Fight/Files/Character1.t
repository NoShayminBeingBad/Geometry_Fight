%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SUBPROGRAMS %%%%%

%Runs character 1
proc character1 (i : int) %i is the player number
    
    %If atk1 input and shield more than 65 frames has passed since last shielf then you can use it  again
    if testIf (player (i), player (i) -> atk1) and frames - shield (i) -> timer > 65 then
	if player (i) -> keyboard (player (i) -> up) then
	    up_shield (i) -> attack := true
	else
	    shield (i) -> attack := true
	end if
	shield_hitbox_active (i) := true
	shield (i) -> timer := frames
	player (i) -> charge := true
    end if
    
    %If you got hit, it cancels the shield
    if player (i) -> stun then
	shield (i) -> attack := false
	up_shield (i) -> attack := false
	player (i) -> charge := false
    end if
    
    %Run the shield
    if shield (i) -> attack then

	shield_y (i, 1) := round (player (i) -> y - player (i) -> r * 1.3)
	shield_y (i, 2) := round (player (i) -> y + player (i) -> r * 1.3)

	if player (i) -> direc = 1 then
	    shield_x (i, 1) := round (player (i) -> x + player (i) -> r)
	    shield_x (i, 2) := round (player (i) -> x + player (i) -> r * 2)
	else
	    shield_x (i, 2) := round (player (i) -> x - player (i) -> r)
	    shield_x (i, 1) := round (player (i) -> x - player (i) -> r * 2)
	end if

	drawfillbox (shield_x (i, 1), shield_y (i, 1), shield_x (i, 2), shield_y (i, 2), 27)

	for j : 1 .. 3
	    shield_hitbox (i, j) -> x := (shield_x (i, 1) + shield_x (i, 2)) / 2
	end for

	shield_hitbox (i, 1) -> y := (shield_y (i, 1) + shield_hitbox (i, 1) -> r)
	shield_hitbox (i, 2) -> y := (shield_hitbox (i, 1) -> y + 2 * shield_hitbox (i, 2) -> r)
	shield_hitbox (i, 3) -> y := (shield_hitbox (i, 2) -> y + 2 * shield_hitbox (i, 3) -> r)

	if shield_hitbox (i, 1) -> hitTest (player (other (i)), 1) or shield_hitbox (i, 2) -> hitTest (player (other (i)), 1) or shield_hitbox (i, 3) -> hitTest (player (other (i)), 1) then
	    if shield_hitbox_active (i) then
		shield_hitbox_active (i) := false
		player (other (i)) -> m := player (i) -> direc * shield_hitbox (i, 1) -> knock_back
	    end if
	end if

	if frames - shield (i) -> timer >= 30 then
	    shield (i) -> attack := false
	    player (i) -> charge := false
	end if

    end if
    
    %Runs the upward shield
    if up_shield (i) -> attack then

	shield_y (i, 1) := round (player (i) -> y + player (i) -> r)
	shield_y (i, 2) := round (player (i) -> y + 2 * player (i) -> r)
	shield_x (i, 1) := round (player (i) -> x - player (i) -> r * 1.3)
	shield_x (i, 2) := round (player (i) -> x + player (i) -> r * 1.3)

	drawfillbox (shield_x (i, 1), shield_y (i, 1), shield_x (i, 2), shield_y (i, 2), 27)

	for j : 1 .. 3
	    shield_hitbox (i, j) -> y := (shield_y (i, 1) + shield_y (i, 2)) / 2
	end for

	shield_hitbox (i, 1) -> x := shield_x (i, 1) + shield_hitbox (i, 1) -> r
	shield_hitbox (i, 2) -> x := shield_hitbox (i, 1) -> x + 2 * shield_hitbox (i, 2) -> r
	shield_hitbox (i, 3) -> x := shield_hitbox (i, 2) -> x + 2 * shield_hitbox (i, 3) -> r

	if shield_hitbox (i, 1) -> hitTest (player (other (i)), 1) or shield_hitbox (i, 2) -> hitTest (player (other (i)), 1) or shield_hitbox (i, 3) -> hitTest (player (other (i)), 1) then
	    %player (other (i)) -> m := sign (player (i) -> direc) * shield_hitbox (i, 1) -> knock_back
	end if

	if frames - shield (i) -> timer >= 30 then
	    up_shield (i) -> attack := false
	    player (i) -> charge := false
	end if

    end if

    if testIf (player (i), player (i) -> atk2) then
	
	%If the projectile is not active, it sets all the variables
	if not fire (i, 1) -> attack and frames - fire (i, 1) -> timer > 25 then
	    new_entity (fire (i, 1))
	    fire (i, 1) -> timer := frames
	    fire (i, 1) -> x := player (i) -> x
	    fire (i, 1) -> y := player (i) -> y
	    if player (i) -> keyboard (player (i) -> up) then
		fire (i, 1) -> v := 1.7 * fire (i, 1) -> resetv
		fire (i, 1) -> m := player (i) -> direc * 0.7 * fire (i, 1) -> resetm
	    elsif player (i) -> keyboard (player (i) -> down) then
		fire (i, 1) -> v := 0.4 * fire (i, 1) -> resetv
		fire (i, 1) -> m := player (i) -> direc * fire (i, 1) -> resetm
	    else
		fire (i, 1) -> v := fire (i, 1) -> resetv
		fire (i, 1) -> m := sign (player (i) -> direc) * fire (i, 1) -> resetm
	    end if
	    fire (i, 1) -> attack := true
	elsif not fire (i, 2) -> attack and frames - fire (i, 2) -> timer > 25 then
	    new_entity (fire (i, 2))
	    fire (i, 1) -> timer := frames
	    fire (i, 2) -> x := player (i) -> x
	    fire (i, 2) -> y := player (i) -> y
	    if player (i) -> keyboard (player (i) -> up) then
		fire (i, 2) -> v := 1.7 * fire (i, 2) -> resetv
		fire (i, 2) -> m := sign (player (i) -> direc) * 0.7 * fire (i, 2) -> resetm
	    elsif player (i) -> keyboard (player (i) -> down) then
		fire (i, 2) -> v := 0.4 * fire (i, 2) -> resetv
		fire (i, 2) -> m := player (i) -> direc * fire (i, 2) -> resetm
	    else
		fire (i, 2) -> v := fire (i, 2) -> resetv
		fire (i, 2) -> m := sign (player (i) -> direc) * fire (i, 2) -> resetm
	    end if
	    fire (i, 2) -> attack := true
	end if

    end if
    
    %Draws the projectile if it is active
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

end character1

%Runs the bot inputs
proc bot_character1 (i : int)
    bot_keyboard (player (i) -> keyboard)
    if not player (i) -> stun then
	peak_jump := abs (player (i) -> v) < 0.5
	if proximity (player (i), 500) and player (i) -> stun then
	    agro := true
	end if
	if not proximity (player (i), 600) then
	    agro := false
	end if
	if frames <= 1 then
	    if Rand.Int (1, 4) = 3 then
		player (i) -> keyboard (player (i) -> atk2) := true
		if Rand.Int (1, 4) > 3 then
		    player (i) -> keyboard (player (i) -> up) := true
		else
		    player (i) -> keyboard (player (i) -> down) := true
		end if
	    else
		player (i) -> keyboard (player (i) -> down) := true
	    end if
	end if
	
	if in_r (i) then
	    if player (i) -> y < player (other (i)) -> y then
		player (i) -> keyboard (player (i) -> up) := true
	    else
		player (i) -> keyboard (player (i) -> down) := true
	    end if
	elsif not proximity (player (i), 350) then
	    if player (i) -> x < player (other (i)) -> x then
		player (i) -> keyboard (player (i) -> right) := true
	    else
		player (i) -> keyboard (player (i) -> left) := true
	    end if
	elsif proximity (player (i), 300) then %it tries to keep a certain range  away from the opponent
	    if not proximity (player (i), 20) then
		if agro then
		    if player (i) -> x < player (other (i)) -> x then
			player (i) -> keyboard (player (i) -> right) := true
		    else
			player (i) -> keyboard (player (i) -> right) := false
			player (i) -> keyboard (player (i) -> left) := true
		    end if
		else
		    if player (i) -> x < player (other (i)) -> x then
			player (i) -> keyboard (player (i) -> right) := false
			player (i) -> keyboard (player (i) -> left) := true
		    else
			player (i) -> keyboard (player (i) -> right) := true
		    end if
		end if
	    end if
	end if
	
	%If enemy is below, it will try to fall through the platform
	if proximity (player (i), 600) and player (other (i)) -> y < player (i) -> y - player (i) -> r and player (i) -> test_keyboard (player (i) -> down) or player (other (i)) -> y < player (i) -> 
	    y -
		player (i) -> r and player (i) -> crouch then
	    player (i) -> keyboard (player (i) -> down) := true
	end if
	
	%If enemey is above, it will jump after them
	if proximity (player (i), 600) and player (other (i)) -> y > player (i) -> y + 1.3 * player (i) -> r and player (i) -> test_keyboard (player (i) -> up) or player (i) -> jump and
		player (other (i)) -> y > player (i) -> y + 1.3 * player (i) -> r then
	    player (i) -> keyboard (player (i) -> up) := true
	end if
	
	%if in range, it will shoot a fireball
	if proximity (player (i), 725) and player (i) -> test_keyboard (player (i) -> atk2) then
	    if proximity (player (i), 400) then
		if not fire (i, 1) -> attack or not fire (i, 2) -> attack then
		    if player (i) -> x < player (other (i)) -> x then
			if player (i) -> direc ~= 1 then
			    player (i) -> keyboard (player (i) -> right) := true
			end if
		    else
			if player (i) -> direc ~= -1 then
			    player (i) -> keyboard (player (i) -> right) := false
			    player (i) -> keyboard (player (i) -> left) := true
			end if
		    end if
		    player (i) -> keyboard (player (i) -> atk2) := true
		end if
	    else
		if not fire (i, 1) -> attack or not fire (i, 2) -> attack then
		    if player (i) -> x < player (other (i)) -> x then
			if player (i) -> direc ~= 1 then
			    player (i) -> keyboard (player (i) -> up) := true
			    player (i) -> keyboard (player (i) -> right) := true
			end if
		    else
			if player (i) -> direc ~= -1 then
			    player (i) -> keyboard (player (i) -> up) := true
			    player (i) -> keyboard (player (i) -> right) := false
			    player (i) -> keyboard (player (i) -> left) := true
			end if
		    end if
		    player (i) -> keyboard (player (i) -> atk2) := true
		end if
	    end if
	end if
	
	%If anything is in a certain range, it will throw up a shield in that direction
	if proximity_all (player (i), 150) = 2 then
	    if player (i) -> y - player (i) -> r > ground_level and Rand.Int (1, 2) = 1 or not player (i) -> ground then
		player (i) -> keyboard (player (i) -> down) := true
	    else
		player (i) -> keyboard (player (i) -> up) := true
		player (i) -> keyboard (player (i) -> atk1) := true
	    end if
	elsif proximity_all (player (i), 150) = 1 then
	    player (i) -> keyboard (player (i) -> right) := false
	    player (i) -> keyboard (player (i) -> left) := true
	    player (i) -> keyboard (player (i) -> atk1) := true
	elsif proximity_all (player (i), 150) = 3 then
	    player (i) -> keyboard (player (i) -> right) := true
	    player (i) -> keyboard (player (i) -> atk1) := true
	end if
    end if
end bot_character1
