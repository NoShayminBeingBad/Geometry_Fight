%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SUBPROGRAMS %%%%%

%Runs character 4
proc character4 (i : int)

    if testIf (player (i), player (i) -> atk1) and frames - grab (i) -> timer > 40 then
	grab (i) -> attack := true
	player (i) -> charge := true
	grab (i) -> timer := frames
	player (i) -> m := player (i) -> direc * 7  
    end if

    if mark (i) then
	if frames - mark_count (i) > 6000 then
	    mark (i) := false
	end if
    end if

    if (player (i) -> stun) then
	grab (i) -> attack := false
	player (i) -> charge := false
    end if    

    %Draws the grab animation and tests the hitBox
    if grab (i) -> attack then
	grab_hitbox (i) -> x := player (i) -> x + player (i) -> direc * (player (i) -> r * 1.2)
	grab_hitbox (i) -> y := player (i) -> y
	if player (i) -> direc = 1 and frames - grab (i) -> timer < 25 then
	    drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r / 3 + 1), round (grab_hitbox (i) -> r / 3 + 1), 310, 50, player (i) -> col)
	    drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r / 3), round (grab_hitbox (i) -> r / 3), 310, 50, player (i) -> col)
	    if frames - grab (i) -> timer > 8 then
		drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r / 3 * 2 + 1), round (grab_hitbox (i) -> r / 3 * 2 + 1), 310, 50, player (i) -> col)
		drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r / 3 * 2), round (grab_hitbox (i) -> r / 3 * 2), 310, 50, player (i) -> col)
	    end if
	    if frames - grab (i) -> timer > 16 then
		drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r + 1), round (grab_hitbox (i) -> r + 1), 310, 50, player (i) -> col)
		drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r), round (grab_hitbox (i) -> r), 310, 50, player (i) -> col)
	    end if
	elsif player (i) -> direc = -1 and frames - grab (i) -> timer < 25 then
	    drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r / 3 + 1), round (grab_hitbox (i) -> r / 3 + 1), 140, 230, player (i) -> col)
	    drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r / 3), round (grab_hitbox (i) -> r / 3), 140, 230, player (i) -> col)
	    if frames - grab (i) -> timer > 8 then
		drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r / 3 * 2 + 1), round (grab_hitbox (i) -> r / 3 * 2 + 1), 140, 230, player (i) -> col)
		drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r / 3 * 2), round (grab_hitbox (i) -> r / 3 * 2), 140, 230, player (i) -> col)
	    end if
	    if frames - grab (i) -> timer > 16 then
		drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r + 1), round (grab_hitbox (i) -> r + 1), 140, 230, player (i) -> col)
		drawarc (round (grab_hitbox (i) -> x), round (grab_hitbox (i) -> y), round (grab_hitbox (i) -> r), round (grab_hitbox (i) -> r), 140, 230, player (i) -> col)
	    end if
	end if
	if grab_hitbox (i) -> hitTest (player (other (i)), 0) and frames - grab (i) -> timer < 25 then
	    grabbed (i) := true
	    grabbed_timer (i) := frames
	    grab (i) -> attack := false
	    player (other (i)) -> stun := true
	    player (other (i)) -> stun_timer := frames
	    player (other (i)) -> hitstun := 230
	end if

	if frames - grab (i) -> timer > 30 then
	    grab (i) -> attack := false
	    player (i) -> charge := false
	end if
    end if
    
    %If the grab connected, the player is given choices of what they want to do
    if grabbed (i) then
	if frames - grabbed_timer (i) <= 180 then
	    if player (i) -> keyboard (player (i) -> atk2) and player (i) -> test_keyboard (player (i) -> atk2) and not mark (i) then
		mark_count (i) := frames
		mark (i) := true
	    end if
	    player (other (i)) -> y := player (i) -> y
	    player (other (i)) -> x := player (i) -> x + player (i) -> direc * player (i) -> r * 1.5
	    if player (i) -> keyboard (player (i) -> up) and player (i) -> test_keyboard (player (i) -> up) then
		player (other (i)) -> hp -= 11
		player (i) -> test_keyboard (player (i) -> up) := false
		player (other (i)) -> stun := true
		player (other (i)) -> stun_timer := frames
		player (other (i)) -> hitstun := 50
		player (other (i)) -> col := player (other (i)) -> stun_col
		player (other (i)) -> v := 6.5
		player (other (i)) -> m := 0
		grabbed_timer (i) := frames - 185
	    elsif player (i) -> keyboard (player (i) -> right) and player (i) -> test_keyboard (player (i) -> right) then
		player (other (i)) -> hp -= 9
		if mine (i, 1) -> attack and mine (i, 1) -> x > player (other (i)) -> x then %Uses kinimatic equations to determine the velocity needed to be thown at the mine
		    var xdif := mine_hitbox (i, 1) -> x - player (other (i)) -> x
		    var ydif := mine_hitbox (i, 1) -> y - player (other (i)) -> y + player (other (i)) -> r
		    var dif := Math.Distance (mine_hitbox (i, 1) -> x, mine_hitbox (i, 1) -> y, player (other (i)) -> x, player (other (i)) -> y - player (i) -> r)
		    var airResistance : real
		    if xdif >= 0 then
			airResistance := player (other (i)) -> a * 0.1
		    else
			airResistance := -player (other (i)) -> a * 0.1
		    end if
		    var t := dif / sqrt (abs (airResistance * dif))
		    player (other (i)) -> v := player (other (i)) -> g / 4 * t + ydif / t
		    player (other (i)) -> m := airResistance * t + xdif / t
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := round (t)
		    player (other (i)) -> col := player (other (i)) -> stun_col
		    grabbed_timer (i) := frames - 185
		elsif mine (i, 2) -> attack and mine (i, 2) -> x > player (other (i)) -> x then
		    var xdif := mine_hitbox (i, 2) -> x - player (other (i)) -> x
		    var ydif := mine_hitbox (i, 2) -> y - player (other (i)) -> y + player (other (i)) -> r
		    var dif := Math.Distance (mine_hitbox (i, 2) -> x, mine_hitbox (i, 2) -> y, player (other (i)) -> x, player (other (i)) -> y - player (i) -> r)
		    var airResistance : real
		    if xdif >= 0 then
			airResistance := player (other (i)) -> a * 0.1
		    else
			airResistance := -player (other (i)) -> a * 0.1
		    end if
		    var t := dif / sqrt (abs (airResistance * dif))
		    player (other (i)) -> v := player (other (i)) -> g / 4 * t + ydif / t
		    player (other (i)) -> m := airResistance * t + xdif / t
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := round (t)
		    player (other (i)) -> col := player (other (i)) -> stun_col
		    grabbed_timer (i) := frames - 185
		else
		    player (i) -> test_keyboard (player (i) -> right) := false
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 60
		    player (other (i)) -> col := player (other (i)) -> stun_col
		    player (other (i)) -> v := 4
		    player (other (i)) -> m := 6
		    grabbed_timer (i) := frames - 185
		end if
	    elsif player (i) -> keyboard (player (i) -> left) and player (i) -> test_keyboard (player (i) -> left) then
		player (other (i)) -> hp -= 9
		if mine (i, 1) -> attack and mine (i, 1) -> x < player (other (i)) -> x then
		    var xdif := mine_hitbox (i, 1) -> x - player (other (i)) -> x
		    var ydif := mine_hitbox (i, 1) -> y - player (other (i)) -> y + player (other (i)) -> r
		    var dif := Math.Distance (mine_hitbox (i, 1) -> x, mine_hitbox (i, 1) -> y, player (other (i)) -> x, player (other (i)) -> y - player (i) -> r)
		    var airResistance : real
		    if xdif >= 0 then
			airResistance := player (other (i)) -> a * 0.1
		    else
			airResistance := -player (other (i)) -> a * 0.1
		    end if
		    var t := dif / sqrt (abs (airResistance * dif))
		    player (other (i)) -> v := player (other (i)) -> g / 4 * t + ydif / t
		    player (other (i)) -> m := airResistance * t + xdif / t
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := round (t)
		    player (other (i)) -> col := player (other (i)) -> stun_col
		    grabbed_timer (i) := grabbed_timer (i) - 185
		elsif mine (i, 2) -> attack and mine (i, 2) -> x > player (other (i)) -> x then
		    var xdif := mine_hitbox (i, 2) -> x - player (other (i)) -> x
		    var ydif := mine_hitbox (i, 2) -> y - player (other (i)) -> y + player (other (i)) -> r
		    var dif := Math.Distance (mine_hitbox (i, 2) -> x, mine_hitbox (i, 2) -> y, player (other (i)) -> x, player (other (i)) -> y - player (i) -> r)
		    var airResistance : real
		    if xdif >= 0 then
			airResistance := player (other (i)) -> a * 0.1
		    else
			airResistance := -player (other (i)) -> a * 0.1
		    end if
		    var t := dif / sqrt (abs (airResistance * dif))
		    player (other (i)) -> v := player (other (i)) -> g / 4 * t + ydif / t
		    player (other (i)) -> m := airResistance * t + xdif / t
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := round (t)
		    player (other (i)) -> col := player (other (i)) -> stun_col
		    grabbed_timer (i) := frames - 185
		else
		    player (i) -> test_keyboard (player (i) -> left) := false
		    player (other (i)) -> stun := true
		    player (other (i)) -> stun_timer := frames
		    player (other (i)) -> hitstun := 60
		    player (other (i)) -> col := player (other (i)) -> stun_col
		    player (other (i)) -> v := 4
		    player (other (i)) -> m := -6
		    grabbed_timer (i) := frames - 185
		end if
	    elsif player (i) -> keyboard (player (i) -> down) and player (i) -> test_keyboard (player (i) -> down) then
		player (other (i)) -> hp -= 7
		player (i) -> test_keyboard (player (i) -> down) := false
		player (other (i)) -> stun := true
		player (other (i)) -> stun_timer := frames
		player (other (i)) -> hitstun := 45
		player (other (i)) -> col := player (other (i)) -> stun_col
		if player (i) -> ground then
		    player (other (i)) -> v := 5
		    player (other (i)) -> m := player (i) -> direc * 3
		    grabbed_timer (i) := frames - 185
		else
		    player (other (i)) -> v := -5
		    player (other (i)) -> m := player (i) -> direc * 3
		    grabbed_timer (i) := frames - 185
		end if
	    end if
	end if

	if frames - grabbed_timer (i) = 181 then
	    player (other (i)) -> m := player (i) -> direc * grab_hitbox (i) -> knock_back
	    player (other (i)) -> v := grab_hitbox (i) -> knock_up
	    player (i) -> m := -player (i) -> direc * 5
	end if
	if frames - grabbed_timer (i) > 215 then
	    grabbed (i) := false
	    player (i) -> charge := false
	end if
    end if

    %Detonates the mark if the opponent is marked. If not, places a mine
    if testIf (player (i), player (i) -> atk2) then
	if mark (i) then
	    player (other (i)) -> v := 6
	    player (other (i)) -> m := sign(player (i) -> x - player (other (i)) -> x) * 4
	    player (other (i)) -> hp -= 11
	    player (other (i)) -> stun := true
	    player (other (i)) -> stun_timer := frames
	    player (other (i)) -> hitstun := 35
	    player (other (i)) -> col := player (other (i)) -> stun_col
	    mark (i) := false
	elsif not mine (i, 1) -> attack then
	    mine (i, 1) -> attack := true
	    mine (i, 1) -> x := player (i) -> x
	    mine (i, 1) -> y := player (i) -> y
	    mine (i, 1) -> v := 0
	    mine (i, 1) -> m := 0
	elsif not mine (i, 2) -> attack then
	    mine (i, 2) -> attack := true
	    mine (i, 2) -> x := player (i) -> x
	    mine (i, 2) -> y := player (i) -> y
	    mine (i, 2) -> v := 0
	    mine (i, 2) -> m := 0
	end if
    end if

    %Draws mine 1
    if mine (i, 1) -> attack then
	mine_hitbox (i, 1) -> x := mine (i, 1) -> x
	mine_hitbox (i, 1) -> y := mine (i, 1) -> y - mine_hitbox (i, 1) -> r / 1.5
	mine (i, 1) -> gravity
	Pic.Draw (mine (i, 1) -> waffle, round (mine (i, 1) -> x - mine (i, 1) -> r), round (mine (i, 1) -> y - mine (i, 1) -> r + 1), picMerge)
	if mine_hitbox (i, 1) -> hitTest (player (other (i)), 1) then
	    player (other (i)) -> m := player (other (i)) -> m / 4
	    mine (i, 1) -> attack := false
	end if
    end if

    %Draws mine 2
    if mine (i, 2) -> attack then
	mine_hitbox (i, 2) -> x := mine (i, 2) -> x
	mine_hitbox (i, 2) -> y := mine (i, 2) -> y - mine_hitbox (i, 2) -> r / 1.5
	mine (i, 2) -> gravity
	Pic.Draw (mine (i, 2) -> waffle, round (mine (i, 2) -> x - mine (i, 2) -> r), round (mine (i, 2) -> y - mine (i, 2) -> r + 1), picMerge)
	if mine_hitbox (i, 2) -> hitTest (player (other (i)), 1) then
	    player (other (i)) -> m := player (other (i)) -> m / 4
	    mine (i, 2) -> attack := false
	end if
    end if

end character4

%Runs bot inputs
proc bot_character4 (i : int)

    bot_keyboard (player (i) -> keyboard)
    if not player (i) -> stun then
	if frames <= 1 then
	    var ran := Rand.Int (1, 3)
	    if ran = 1 then
		player (i) -> keyboard (player (i) -> up) := true
		if Rand.Int (1, 2) = 1 then
		    player (i) -> keyboard (player (i) -> atk1) := true
		end if
	    elsif ran = 2 then
		player (i) -> keyboard (player (i) -> down) := true
	    end if
	end if
    
	%If there is a projectile above, it will try to drop down
	if proximity_project (player (i), 200) = 2 then
	    if player (i) -> y - player (i) -> r * 2 > ground_level or not player (i) -> ground then
		player (i) -> keyboard (player (i) -> down) := true
		if not in_rx (i) and player (i) -> x < player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> right) := true
		elsif not in_rx (i) and player (i) -> x > player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> left) := true
		end if
	    end if
	elsif proximity_project (player (i), 250) = 1 then %If there is a projectile to the left, it will go right
	    player (i) -> keyboard (player (i) -> right) := true
	    if Rand.Int (1, 300) = 2 then
		player (i) -> keyboard (player (i) -> up) := true
	    end if
	elsif proximity_project (player (i), 250) = 2 then %If there is a projectile to the right, it will go left
	    player (i) -> keyboard (player (i) -> left) := true
	    if Rand.Int (1, 500) = 2 then
		player (i) -> keyboard (player (i) -> up) := true
	    end if
	else
	    if grabbed (i) then %If grabbed, tests for a bunch of conditions and throws them into a direction
		if not mark (i) and player (i) -> test_keyboard (player (i) -> atk2) then
		    player (i) -> keyboard (player (i) -> atk2) := true
		elsif mark (i) then
		    if mine (i, 1) -> attack then
			if mine (i, 1) -> x > player (other (i)) -> x and player (i) -> test_keyboard (player (i) -> right) then
			    player (i) -> keyboard (player (i) -> right) := true
			elsif mine (i, 1) -> x < player (other (i)) -> x and player (i) -> test_keyboard (player (i) -> left) then
			    player (i) -> keyboard (player (i) -> left) := true
			end if
		    elsif mine (i, 2) -> attack then
			if mine (i, 2) -> x > player (other (i)) -> x then
			    player (i) -> keyboard (player (i) -> right) := true
			elsif mine (i, 2) -> x < player (other (i)) -> x then
			    player (i) -> keyboard (player (i) -> left) := true
			end if
		    elsif Rand.Int (1, 2) = 1 or not player (i) -> ground then
			player (i) -> keyboard (player (i) -> down) := true
		    else
			player (i) -> keyboard (player (i) -> up) := true
		    end if
		end if
	    else
		if player (other (i)) -> x < player (i) -> x + 2 * player (i) -> r and player (other (i)) -> x > player (i) -> x - player (i) -> r * 2 then
		    if player (other (i)) -> y < player (i) -> y and player (i) -> test_keyboard (player (i) -> atk2) then
			player (i) -> keyboard (player (i) -> atk2) := true
		    end if
		end if
		if mark (i) and player (i) -> test_keyboard (player (i) -> atk2) and player (i) -> hp <= 11 then
		    player (i) -> keyboard (player (i) -> atk2) := true
		end if
		if player (other (i)) -> y > player (i) -> y + 0.75 * player (i) -> r and player (i) -> test_keyboard (player (i) -> up) or player (i) -> jump then
		    player (i) -> keyboard (player (i) -> up) := true
		end if
		if player (other (i)) -> y < player (i) -> y - player (i) -> r and player (i) -> test_keyboard (player (i) -> down) or player (i) -> crouch then
		    player (i) -> keyboard (player (i) -> down) := true
		end if
		if mark (i) and not proximity (player (i), 270) and not player (i) -> test_keyboard (player (i) -> atk2) then
		    player (i) -> keyboard (player (i) -> atk2) := true
		end if
		if not mine (i, 1) -> attack and player (i) -> test_keyboard (player (i) -> atk2) then
		    player (i) -> keyboard (player (i) -> atk2) := true
		end if
		if not in_rx (i) and player (i) -> x < player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> right) := true
		elsif not in_rx (i) and player (i) -> x > player (other (i)) -> x then
		    player (i) -> keyboard (player (i) -> left) := true
		end if
		if player (i) -> ground and proximity (player (i), player (i) -> r * 4) and player (other (i)) -> y > player (i) -> y - player (i) -> r * 1.5 and player (other (i)) -> y < player (i) -> y + player (i) -> r * 1.5 and player (i) -> test_keyboard (player (i) -> atk1) then
		    if not player (i) -> jump then
			player (i) -> keyboard (player (i) -> atk1) := true
		    end if
		end if
		if not player (i) -> ground and proximity (player (i), player (i) -> r * 6) and player (other (i)) -> y > player (i) -> y - player (i) -> r * 1.5 and player (other (i)) -> y < player (i) -> y + player (i) -> r * 1.5 and player (i) -> test_keyboard (player (i) -> atk1) then
		    if not player (i) -> jump then
			player (i) -> keyboard (player (i) -> atk1) := true
		    end if
		end if
	    end if
	end if
    end if
end bot_character4
