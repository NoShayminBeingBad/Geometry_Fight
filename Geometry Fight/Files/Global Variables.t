%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% CHARACTER VARIABLES %%%%%
var ex := false
var font_title := Font.New ("sans serif:25:bold")
var font_button := Font.New ("sans serif:22:bold")
var mx, my, o : int

var title_movement_x1 := 3
var title_movement_y1 := 3
var r1 := 65
var title_x1 : int := Rand.Int (r1, maxx - r1 * 2)
var title_y1 : int := Rand.Int (r1, maxy - r1 * 2)
if Rand.Int (1, 2) = 1 then
    title_movement_x1 *= -1
end if
if Rand.Int (1, 2) = 1 then
    title_movement_y1 *= -1
end if

var title_movement_x2 := 3
var title_movement_y2 := 3
var r2 := 65
var title_x2 : int := Rand.Int (r2, maxx - r2 * 2)
var title_y2 : int := Rand.Int (r2, maxy - r2 * 2)
if Rand.Int (1, 2) = 1 then
    title_movement_x2 *= -1
end if
if Rand.Int (1, 2) = 1 then
    title_movement_y2 *= -1
end if

var keyup := true
var input : array char of boolean
var test : array char of boolean
var player_input : array 1 .. 2, char of boolean
var player_test : array 1 .. 2, char of boolean
var stagecol := 10
var ground_level : int := 20

var winner := 1
var endgame := false

var frames := 0
var frames_per_sec := 0
var frames_last := 0
var last_update := 0

var slow : boolean := false
var slowdown : real := 3

var font_select := Font.New ("sans serif:15:bold")
var font_subtext := Font.New ("sans serif:8:bold")
var select1 := 1
var select2 := 1
var bot_button : array 1 .. 2 of int
var bot1 := false
var bot2 := false

var button : array 1 .. 13 of int

var pause_select : int := 2
var font_ingame := Font.New ("sans serif:18:bold")

var stage_select := 1
var stagex := 126
var stagex2 : int := 0
var stagey := 105
var stagey2 : int := -300
var sdx := 2
var stagetimer : int := 0

var rerun := false
