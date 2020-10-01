%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% GLOBAL VARIABLES %%%%%
player (1) -> num := 1
player (2) -> num := 2
entities (1) := player (1)
entities (2) := player (2)

%Mark variables for character 3 and 4
var mark : array 1 .. 2 of boolean := init (false, false)
var mark_count : array 1 .. 2 of int := init (-10000, -10000)
var marker : int
marker := Pic.FileNew ('Files/mark.bmp')
marker := Pic.Scale (marker, round (player (1) -> r * 1.1), round (player (1) -> r * 1.1))

%Variables for bots
var peak_jump := false
var agro := false
var combo : array 1 .. 2 of boolean := init (false, false)
var combo_frames : array 1 .. 2 of int := init (0, 0)

%reset the match variables
proc reset
    stagetimer := 0
    stagex := 126
    stagex2 := 0
    stagey := 105
    stagey2 := -300
    sdx := 2
    frames := 0
    mark (1) := false
    mark (2) := false
    slow := false
    slowdown := 3
    endgame := false
    player (1) -> reset_player
    player (1) -> hp := 100
    player (1) -> side := 1
    player (1) -> x := 150
    player (1) -> r := maxx / 22
    player (1) -> r_x := player (1) -> r
    player (1) -> r_y := player (1) -> r
    player (1) -> direc := 1
    player (1) -> col := red
    player (1) -> stun_col := 12
    player (1) -> non_stun_col := red
    player (2) -> reset_player
    player (2) -> side := 2
    player (2) -> x := maxx - 150
    player (2) -> r := maxx / 22
    player (2) -> r_x := player (2) -> r
    player (2) -> r_y := player (2) -> r
    player (2) -> direc := -1
    player (2) -> col := blue
    player (2) -> stun_col := 9
    player (2) -> non_stun_col := blue
    new entities, 2
    entities (1) := player (1)
    entities (2) := player (2)
end reset

%Character 1 variables
var fire : array 1 .. 2, 1 .. 2 of ^projectile
var shield : array 1 .. 2 of ^move
var up_shield : array 1 .. 2 of ^move
var shield_hitbox : array 1 .. 2, 1 .. 3 of ^hitBox
var shield_hitbox_active : array 1 .. 2 of boolean := init (true, true)
var shield_x : array 1 .. 2, 1 .. 2 of int
var shield_y : array 1 .. 2, 1 .. 2 of int

proc init_char1
    for i : 1 .. 2
	for j : 1 .. 2
	    new fire (i, j)
	    fire (i, j) -> pro_num := j
	    fire (i, j) -> side := i
	    fire (i, j) -> r := 13
	    fire (i, j) -> hitbox -> dmg := 8
	    fire (i, j) -> hitbox -> hit_stun := 40
	    fire (i, j) -> hitbox -> knock_up := 2.8
	    fire (i, j) -> hitbox -> knock_back := 3.3
	    fire (i, j) -> egg := Pic.FileNew ("Files/fire.BMP")
	    fire (i, j) -> egg := Pic.Scale (fire (i, j) -> egg, 52, 52)
	    fire (i, j) -> hitbox -> r := 13
	    fire (i, j) -> resetm := 8
	end for
	new shield (i)
	new up_shield (i)
	shield_hitbox_active (i) := false
	for j : 1 .. 3
	    new shield_hitbox (i, j)
	    shield_hitbox (i, j) -> dmg := 0.7
	    shield_hitbox (i, j) -> knock_back := 4
	    shield_hitbox (i, j) -> knock_up := 3
	    shield_hitbox (i, j) -> hit_stun := 30
	    shield_hitbox (i, j) -> r := round (player (i) -> r * 1.3) * 2 / 6
	end for
    end for
end init_char1

proc free_char1
    for i : 1 .. 2
	for j : 1 .. 2
	Pic.Free(fire (i,j) -> egg)
	free fire (i, j)
	end for
	free shield (i)
	free up_shield (i)
	for j : 1 .. 3
	    free shield_hitbox (i, j)
	end for
    end for
end free_char1

%Character 2 variables
var dash : array 1 .. 2 of ^move
var up_dash : array 1 .. 2 of ^move
var down_dash : array 1 .. 2 of ^move
var dash_hitbox : array 1 .. 2 of ^hitBox
var dash_hitbox2 : array 1 .. 2 of ^hitBox
var dash_count : array 1 .. 2 of int := init (0, 0)
var up_count : array 1 .. 2 of int := init (0, 0)
var reflecter : array 1 .. 2 of ^move
var reflecter_hitbox : array 1 .. 2 of ^hitBox
var reflecter_r : array 1 .. 2 of int := init (0, 0)
var reflected : array 1 .. 2 of ^projectile

proc init_char2
    for i : 1 .. 2
	new dash (i)
	new up_dash (i)
	new down_dash (i)
	new dash_hitbox (i)
	new dash_hitbox2 (i)
	new reflecter (i)
	new reflected (i)
	new reflecter_hitbox (i)
	dash (i) -> side := i
	up_dash (i) -> side := i
	down_dash (i) -> side := i
	dash_hitbox (i) -> dmg := 1
	dash_hitbox (i) -> knock_back := 3
	dash_hitbox (i) -> knock_up := 4
	dash_hitbox (i) -> hit_stun := 40
	dash_hitbox (i) -> r := round (player (i) -> r)
	dash_hitbox2 (i) -> dmg := 1
	dash_hitbox2 (i) -> knock_back := 4
	dash_hitbox2 (i) -> knock_up := 3
	dash_hitbox2 (i) -> hit_stun := 40
	dash_hitbox2 (i) -> r := round (player (i) -> r)
	reflecter (i) -> side := i
	reflecter_hitbox (i) -> dmg := 0.5
	reflecter_hitbox (i) -> knock_back := 2
	reflecter_hitbox (i) -> knock_up := 2
	reflecter_hitbox (i) -> hit_stun := 20
    end for
end init_char2

proc free_char2
    for i : 1 .. 2
	free dash (i)
	free up_dash (i)
	free down_dash (i)
	free dash_hitbox (i)
	free dash_hitbox2 (i)
	free reflecter (i)
	free reflected (i)
	free reflecter_hitbox (i)
    end for
end free_char2

%Character 3 variables
var rez : array 1 .. 2 of ^projectile
var rez_count : array 1 .. 2 of int
var track : array 1 .. 2 of ^move
var track_hitbox : array 1 .. 2 of ^hitBox
var tempest : array 1 .. 2 of ^move
var tempest_hitbox : array 1 .. 2 of ^hitBox
var tempest_hitbox_active : array 1 .. 2 of boolean := init (false, false)

proc init_char3
    for i : 1 .. 2
	new rez (i)
	new track (i)
	new track_hitbox (i)
	new tempest (i)
	new tempest_hitbox (i)
	rez (i) -> side := i
	rez (i) -> pro_num := 3
	rez (i) -> r := 15
	rez (i) -> hitbox -> dmg := 7
	rez (i) -> hitbox -> hit_stun := 35
	rez (i) -> hitbox -> knock_up := 2.5
	rez (i) -> hitbox -> knock_back := 2.5
	rez (i) -> egg := Pic.FileNew ('Files/rez.bmp')
	rez (i) -> egg := Pic.Scale (rez (i) -> egg, 60, 60)
	rez (i) -> hitbox -> r := 15
	rez (i) -> resetm := 9
	rez (i) -> resetv := 0
	rez (i) -> g := 0
	track_hitbox (i) -> dmg := 13
	track_hitbox (i) -> hit_stun := 40
	track_hitbox (i) -> knock_up := 3
	track_hitbox (i) -> knock_back := 2
	track_hitbox (i) -> r := player (i) -> r
	tempest (i) -> r := 15
	tempest_hitbox (i) -> dmg := 12
	tempest_hitbox (i) -> hit_stun := 40
	tempest_hitbox (i) -> knock_up := 2.5
	tempest_hitbox (i) -> knock_back := 3
	tempest_hitbox (i) -> r := 15
	tempest_hitbox_active (i) := false
    end for
end init_char3

proc free_char3
    for i : 1 .. 2
	free rez (i)
	free track (i)
	free track_hitbox (i)
	free tempest (i)
	free tempest_hitbox (i)
    end for
end free_char3

%Character 4 variables
var mine : array 1 .. 2, 1 .. 2 of ^move
var mine_hitbox : array 1 .. 2, 1 .. 2 of ^hitBox
var grab : array 1 .. 2 of ^move
var grab_hitbox : array 1 .. 2 of ^hitBox
var grabbed : array 1 .. 2 of boolean := init (false, false)
var grabbed_timer : array 1 .. 2 of int := init (0, 0)

proc init_char4
    for i : 1 .. 2
	for j : 1 .. 2
	    new mine (i, j)
	    new mine_hitbox (i, j)
	    mine (i, j) -> side := i
	    mine (i, j) -> waffle := Pic.FileNew ("Files/mine.BMP")
	    mine (i, j) -> waffle := Pic.Scale (mine (i, j) -> waffle, round (player (i) -> r * 1.6), round (player (i) -> r * 0.75))
	    mine (i, j) -> r := player (i) -> r * 0.8
	    mine_hitbox (i, j) -> dmg := 14
	    mine_hitbox (i, j) -> hit_stun := 35
	    mine_hitbox (i, j) -> knock_up := 5
	    mine_hitbox (i, j) -> knock_back := 0
	    mine_hitbox (i, j) -> r := player (i) -> r * 0.5
	end for
	new grab (i)
	new grab_hitbox (i)
	grab (i) -> lag := 20
	grab_hitbox (i) -> r := player (i) -> r * 0.8
	grab_hitbox (i) -> knock_up := 4
	grab_hitbox (i) -> knock_back := 3.5
	grabbed (i) := false
	grabbed_timer (i) := 0
    end for
end init_char4

proc free_char4
    for i : 1 .. 2
	for j : 1 .. 2
	    free mine (i, j)
	    free mine_hitbox (i, j)
	end for
	free grab (i)
	free grab_hitbox (i)
    end for
end free_char4

%Character 5 variables
var tp : array 1 .. 2 of ^move
var tp_hitbox : array 1 .. 2 of ^hitBox
var tp_state : array 1 .. 2 of int := init (0, 0)
var tp_count : array 1 .. 2 of int := init (0, 0)
var tp_x : array 1 .. 2 of int := init (0, 0)
var tp_y : array 1 .. 2 of int := init (0, 0)
var tp_hitbox_active : array 1 .. 2 of boolean := init (true, true)
var swing : array 1 .. 2 of ^move
var swing_hitbox : array 1 .. 2 of ^hitBox
var swing_count : array 1 .. 2 of int
var swing_var : array 1 .. 2 of int
var swing_hitbox_active : array 1 .. 2 of boolean := init (true, true)

proc init_char5
    for i : 1 .. 2
	new tp (i)
	new tp_hitbox (i)
	new swing (i)
	new swing_hitbox (i)
	tp_hitbox (i) -> dmg := 2
	tp_hitbox (i) -> knock_back := 1.5
	tp_hitbox (i) -> knock_up := 1.5
	tp_hitbox (i) -> hit_stun := 25
	tp_hitbox (i) -> r := player (i) -> r * 1.2
	tp_hitbox_active (i) := false
	swing (i) -> r := player (i) -> r / 3
	swing_hitbox (i) -> dmg := 8
	swing_hitbox (i) -> r := swing (i) -> r
	swing_hitbox_active (i) := false
    end for
end init_char5

proc free_char5
    for i : 1 .. 2
	free tp (i)
	free tp_hitbox (i)
	free swing (i)
	free swing_hitbox (i)
    end for
end free_char5
