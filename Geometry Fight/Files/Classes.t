%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% CLASSES %%%%%

%Everything in game has a x,y,a,g,v,m, etc.
class entity

    import Math, stagecol, ground_level
    export var all

    var x, m, a, y, v, g, r : real
    var num := 0
    var side := 0
    var ground := false %If entity is touching the ground
    var drop := false %If true, entity will drop through platforms
    y := 250
    v := 0
    m := 0
    g := 0.1
    a := 0.25
    r := 0
    
    %Runs gravity (vertical), the circle is to see where non-circular objects are
    proc gravity
	%drawfilloval(round(x),round(y),round(r),round(r),black)
	y += v
	v -= g
	if whatdotcolor (round (x), round (y - r * 2)) = stagecol then
	    drop := false
	end if
	%If running down a slope, you move down
	if whatdotcolor (round (x), round (y - r - 1)) ~= stagecol and v < 0 and ground then
	    for i : 2 .. 5
		if whatdotcolor (round (x), round (y - r - i)) = stagecol then
		    y -= i - 1
		end if
	    end for
	end if
	if Math.DistancePointLine (round (x), round (y), -1000, ground_level, maxx + 1000, ground_level) < r then
	    y += (r) - Math.DistancePointLine (round (x), round (y), 0, ground_level, maxx, ground_level)
	    ground := true
	    drop := false
	%If in the ground, you get pushed up
	elsif whatdotcolor (round (x), round (y - r)) = stagecol and v <= 0 and not drop then
	    ground := true
	    if whatdotcolor (round (x), round (y - r + 1)) = stagecol then
		for i : 1 .. 500
		    if whatdotcolor (round (x), round (y - r + i)) ~= stagecol then
			y += i - 1
			exit
		    end if
		end for
	    end if
	else
	    ground := false
	end if
	if ground and not drop then
	    v := 0
	end if
    end gravity

    %Runs the movement(horizontal)
    proc movement
	x += m
	if m ~= 0 then
	    if ground then
		m -= sign (m) * a
	    else
		m -= sign (m) * a * 0.1
	    end if
	end if
	if abs (m) < 0.01 then
	    m := 0
	end if
    end movement
end entity

%An array of all entities for bots
var entities : flexible array 1 .. 0 of ^entity
new entities, 2

%Addes an entity to the array
proc new_entity (ent : ^entity)
    var num := upper (entities) + 1
    new entities, num
    entities (num) := ent
    entities (num) -> num := num
end new_entity

%Removes an entity to the array
proc remove_entity (ent : ^entity)
    var num := 1
    num := ent -> num
    if num = upper (entities) then
	new entities, upper (entities) - 1
    else
	for i : num + 1 .. upper (entities)
	    entities (i) -> num := i - 1
	    entities (i - 1) := entities (i)
	end for
	new entities, upper (entities) - 1
    end if
end remove_entity

%Class for player character
class character

    inherit entity
    import Math, player_input, player_test, frames

    export var all

    var hp : real := 100
    var up, right, left, down, atk1, atk2 : char
    var jump := false
    var jump_count := 1
    var jumplag := 0
    var crouch := false
    var squat := 0
    var direc : int
    var col : int
    var stun_col : int
    var non_stun_col : int
    var charge := false
    var stun := false
    var stun_timer := 0
    var hitstun := 0
    var invis := false
    var invins := false
    var keyboard : array char of boolean
    var test_keyboard : array char of boolean

    var r_x : real
    var r_y : real

    for i : 1 .. upper (test_keyboard)
	test_keyboard (chr (i)) := true
    end for
    
    %Resets the player data
    proc reset_player
	v := 0
	m := 0
	r_x := r
	r_y := r
	y := 250
	hp := 100
	jump := false
	jump_count := 1
	jumplag := 0
	crouch := false
	squat := 0
	charge := false
	stun := false
	stun_timer := 0
	hitstun := 0
	invis := false
	invins := false
    end reset_player
    
    %Tests for input, if the input is available so multiple inputs cannot be done and if player is stunned or charging
    function testIf (i : char) : boolean
	if keyboard (i) and test_keyboard (i) and not stun and not charge then
	    test_keyboard (i) := false
	    result true
	end if
	result false
    end testIf
    
    %Same thing but multiple inputs can be done
    function moveIf (i : char) : boolean
	if keyboard (i) and not stun and not charge then
	    test_keyboard (i) := false
	    result true
	end if
	result false
    end moveIf
    
    %Player movement(horizontal)
    proc playerMovement
	x += m
	if m ~= 0 and not moveIf (left) and not moveIf (right) then
	    if ground then
		m -= sign (m) * a
	    else
		m -= sign (m) * a * 0.1
	    end if
	    if abs (m) < 0.5 then
		m := 0
	    end if
	end if
    end playerMovement
    
    %Basic controls for the player character
    proc control
	gravity
	playerMovement
	x := max (0 + r, x)
	x := min (maxx - r, x)
	Font.Draw (intstr (num), round (x), round (y), defFontID, black)
	if frames - stun_timer > hitstun then
	    stun := false
	    col := non_stun_col
	end if
	
	%Triggers the jump
	if testIf (up) and jump_count > 0 then
	    jump_count -= 1
	    if ground then
		jump := true
		jumplag := frames
	    else
		v := 4
		if not keyboard (left) and not keyboard (right) then
		    m := 0
		end if
	    end if
	end if
	
	%If grounded, refreshes jump count
	if ground then
	    jump_count := 1
	end if
	if jump then
	    if keyboard (atk1) or keyboard (atk2) then
		jump := false
	    elsif frames - jumplag > 4 then
		if keyboard (up) then
		    v := 4
		else
		    v := 2
		end if
		jump := false
	    end if
	end if
	if moveIf (left) then
	    direc := -1
	    if ground then
		m := -3
	    elsif m > -3 then
		m -= 0.25
	    end if
	end if
	if moveIf (right) then
	    direc := 1
	    if ground then
		m := 3
	    elsif m < 3 then
		m += 0.25
	    end if
	end if
	if testIf (down) then
	    if ground then
		crouch := true
		squat := frames
	    elsif not ground then
		if v <= 0 and v > -2 then
		    v -= 2
		end if
	    end if
	end if
	drop := moveIf (down) and not ground
	if crouch then
	    if keyboard (atk1) or keyboard (atk2) then
		crouch := false
	    elsif frames - squat > 5 then
		ground := false
		drop := true
		crouch := false
	    end if
	end if
    end control

end character

%Character for players
var player : array 1 .. 2 of ^character
new player (1)
player (1) -> side := 1
player (1) -> x := 150
player (1) -> r := 60
player (1) -> r_x := player (1) -> r
player (1) -> r_y := player (1) -> r
player (1) -> direc := 1
player (1) -> col := red
player (1) -> stun_col := 12
player (1) -> non_stun_col := red
player (1) -> up := 'w'
player (1) -> right := 'd'
player (1) -> left := 'a'
player (1) -> down := 's'
player (1) -> atk1 := 'c'
player (1) -> atk2 := 'v'

new player (2)
player (2) -> side := 2
player (2) -> x := maxx - 150
player (2) -> r := 60
player (2) -> r_x := player (2) -> r
player (2) -> r_y := player (2) -> r
player (2) -> direc := -1
player (2) -> col := blue
player (2) -> stun_col := 9
player (2) -> non_stun_col := blue
player (2) -> up := chr (200)
player (2) -> right := chr (205)
player (2) -> left := chr (203)
player (2) -> down := chr (208)
player (2) -> atk1 := '1'
player (2) -> atk2 := '2'

%Class for hitboxes
class hitBox

    import Math, character, frames
    export var all

    var dmg : real := 0
    var knock_back : real := 0
    var knock_up : real := 0
    var hit_stun : int := 0
    var x : real := 0
    var y : real := 0
    var r : real := 5
    
    %Sets the enemy so they're stunned
    proc stunned (enemy : ^character)
	enemy -> stun := true
	enemy -> stun_timer := frames
	enemy -> hitstun := hit_stun
	enemy -> col := enemy -> stun_col
    end stunned
    
    %Test if the enemy is hit by the hitbox. The circle is to show the hitbox(es)
    fcn hitTest (enemy : ^character, typ : int) : boolean
	%drawfilloval (round (x), round (y), round (r), round (r), yellow)
	if not enemy -> invins then
	    if Math.Distance (x, y, enemy -> x, enemy -> y) < r + enemy -> r then
		if typ = 1 then %normal knock up
		    enemy -> v := knock_up
		    stunned (enemy)
		    enemy -> hp -= dmg
		end if
		if typ = 2 then %knock them downwards
		    enemy -> v := -knock_up
		    stunned (enemy)
		    enemy -> hp -= dmg
		end if
		result true
	    end if
	end if
	result false
    end hitTest

end hitBox

%Class for moves, boolean for if the move is being used and the move's timer etc.
class move

    inherit entity
    import Math, hitBox
    export var all

    var attack := false
    var timer := -1000
    var move_lag := 0
    var waffle : int %This is for a pic if needed
    var lag := 0

end move

%Class for projectiles
class projectile

    inherit move
    import Math, hitBox, remove_entity
    export var all

    var pro_num : int
    var resetm := 6
    var resetv := 3
    var hitbox : ^hitBox
    new hitbox
    var egg : int %This is for a pic
    var final : int
    a := 0
    
    %Rotates the projectiles based on the angle and velocities (horizontal and vertical)
    proc rotate
	var angle : real
	if m = 0 then
	    if sign (v) = 1 then
		angle := 90
	    else
		angle := 270
	    end if
	else
	    angle := arctand (v / m)
	end if
	if sign (m) = -1 then
	    final := Pic.Rotate (egg, (angle + 180) div 1, round (r * 3), round (r * 3))
	else
	    final := Pic.Rotate (egg, angle div 1, round (r * 3), round (r * 3))
	end if
    end rotate
    
    %Draws and rotates if the projectile is active
    proc active

	rotate
	movement
	gravity

	hitbox -> x := x
	hitbox -> y := y

	Pic.Draw (final, round (x - round (r * 3)), round (y - round (r * 3)), picMerge)
	Pic.Free (final)
	
	%If it hits the ground then it stops
	if ground then
	    attack := false
	    remove_entity (self)
	end if
    end active

end projectile

%Record of all player inputs for replays
type replay :
    record
	p1_up : boolean
	p1_left : boolean
	p1_right : boolean
	p1_down : boolean
	p1_atk1 : boolean
	p1_atk2 : boolean
	p2_up : boolean
	p2_left : boolean
	p2_right : boolean
	p2_down : boolean
	p2_atk1 : boolean
	p2_atk2 : boolean
    end record
