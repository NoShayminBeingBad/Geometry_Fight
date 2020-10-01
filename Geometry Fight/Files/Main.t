%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import GUI
include "Files/Include.t" %includes a file that includes everything else
View.Set ("position:center;center,graphics:1280,640,offscreenonly,nocursor,title:Geometry Fight, nobuttonbar")

%%%%% MAIN CODE %%%%%

for i : 1 .. upper (input)
    player (1) -> keyboard (chr (i)) := false
end for

%colorback(black)
%loop for start menu
loop
    Input.KeyDown (input)
    if not input (chr (10)) then
	test (chr (10)) := true
    end if
    drawfilloval (title_x1, title_y1, r1, r1, blue)
    if title_x1 >= maxx - r1 or title_x1 <= r1 then
	title_movement_x1 *= -1
    end if
    if title_y1 >= maxy - r1 or title_y1 <= r1 then
	title_movement_y1 *= -1
    end if
    title_x1 += title_movement_x1
    title_y1 += title_movement_y1
    drawfilloval (title_x2, title_y2, r2, r2, red)
    if title_x2 >= maxx - r2 or title_x2 <= r2 then
	title_movement_x2 *= -1
    end if
    if title_y2 >= maxy - r2 or title_y2 <= r2 then
	title_movement_y2 *= -1
    end if
    title_x2 += title_movement_x2
    title_y2 += title_movement_y2

    Mouse.Where (mx, my, o)

    if o ~= 0 then
	if mx >= 565 and mx <= 695 then
	    if my >= 335 and my <= 385 then
		char_select
	    end if
	end if
	if mx >= 510 and mx <= 765 then
	    if my >= 235 and my <= 285 then
		how_to_play
	    end if
	end if
    end if

    Font.Draw ("Fight!", 580, 350, font_button, brightblue)
    drawbox (565, 335, 695, 385, brightblue)
    Font.Draw ("How to Play", 530, 250, font_button, brightblue)
    drawbox (510, 235, 765, 285, brightblue)
    Font.Draw ("Geometry Fight", 470, 500, font_title, brightred)
    View.Update
    Time.DelaySinceLast (round (1000 / 61))
    cls
    drawfillbox(0,0,2000,1000,black)
end loop

