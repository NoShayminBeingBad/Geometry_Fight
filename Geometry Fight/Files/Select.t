%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% SUBPROGRAMS %%%%%

%Changes if its a bot or not
proc bot_1
    bot1 := not bot1
end bot_1

proc bot_2
    bot2 := not bot2
end bot_2

%The cycle pic
var re := Pic.FileNew("Files/rotation.bmp")
re := Pic.Scale(re,175,130)

%all the buttons and text in select screen
proc select_button
    Font.Draw ("Character Select", 90, 600, font_select, black)
    Font.Draw ("Character Select", 1000, 600, font_select, black)
    Font.Draw ("Stage Select", 550, 600, font_select, black)
    drawbox (70, 30, 230, 70, black)
    drawbox (1050, 30, 1210, 70, black)
    drawfillbox (40, 110, 190, 260, brightred)
    drawfillbox (200, 110, 350, 260, brightred)
    drawfillbox (40, 270, 190, 420, brightred)
    drawfillbox (200, 270, 350, 420, brightred)
    drawfillbox (40, 430, 190, 580, brightred)
    drawfillbox (200, 430, 350, 580, brightred)
    if select1 = 1 then
	drawfillbox (50, 440, 180, 570, black)
	dis_1 (1)
    else
	drawfillbox (45, 435, 185, 575, black)
	
    end if
    if select1 = 2 then
	drawfillbox (210, 440, 340, 570, black)
	dis_2 (1)
    else
	drawfillbox (205, 435, 345, 575, black)
    end if
    if select1 = 3 then
	drawfillbox (50, 280, 180, 410, black)
	dis_3 (1)
    else
	drawfillbox (45, 275, 185, 415, black)
    end if
    if select1 = 4 then
	drawfillbox (210, 280, 340, 410, black)
	dis_4 (1)
    else
	drawfillbox (205, 275, 345, 415, black)
    end if
    if select1 = 5 then
	drawfillbox (50, 120, 180, 250, black)
	dis_5 (1)
    else
	drawfillbox (45, 115, 185, 255, black)
    end if
    if select1 = 6 then
	drawfillbox (210, 120, 340, 250, black)
	dis_6 (1)
    else
	drawfillbox (205, 115, 345, 255, black)
    end if
    Font.Draw ('1', 100, 500, font_title, brightred)
    Font.Draw ('2', 260, 500, font_title, brightred)
    Font.Draw ('3', 100, 330, font_title, brightred)
    Font.Draw ('4', 260, 330, font_title, brightred)
    Font.Draw ('5', 100, 170, font_title, brightred)
    Font.Draw ('?', 260, 170, font_title, brightred)
    drawfillbox (maxx - 40, 110, maxx - 190, 260, brightblue)
    drawfillbox (maxx - 200, 110, maxx - 350, 260, brightblue)
    drawfillbox (maxx - 40, 270, maxx - 190, 420, brightblue)
    drawfillbox (maxx - 200, 270, maxx - 350, 420, brightblue)
    drawfillbox (maxx - 40, 430, maxx - 190, 580, brightblue)
    drawfillbox (maxx - 200, 430, maxx - 350, 580, brightblue)
    if select2 = 2 then
	drawfillbox (maxx - 50, 440, maxx - 180, 570, black)
	dis_2 (2)
    else
	drawfillbox (maxx - 45, 435, maxx - 185, 575, black)
    end if
    if select2 = 1 then
	drawfillbox (maxx - 210, 440, maxx - 340, 570, black)
	dis_1 (2)
    else
	drawfillbox (maxx - 205, 435, maxx - 345, 575, black)
    end if
    if select2 = 4 then
	drawfillbox (maxx - 50, 280, maxx - 180, 410, black)
	dis_4 (2)
    else
	drawfillbox (maxx - 45, 275, maxx - 185, 415, black)
    end if
    if select2 = 3 then
	drawfillbox (maxx - 210, 280, maxx - 340, 410, black)
	dis_3 (2)
    else
	drawfillbox (maxx - 205, 275, maxx - 345, 415, black)
    end if
    if select2 = 6 then
	drawfillbox (maxx - 50, 120, maxx - 180, 250, black)
	dis_6 (2)
    else
	drawfillbox (maxx - 45, 115, maxx - 185, 255, black)
    end if
    if select2 = 5 then
	drawfillbox (maxx - 210, 120, maxx - 340, 250, black)
	dis_5 (2)
    else
	drawfillbox (maxx - 205, 115, maxx - 345, 255, black)
    end if
    Font.Draw ('2', maxx - 130, 500, font_title, brightblue)
    Font.Draw ('1', maxx - 290, 500, font_title, brightblue)
    Font.Draw ('4', maxx - 130, 330, font_title, brightblue)
    Font.Draw ('3', maxx - 290, 330, font_title, brightblue)
    Font.Draw ('?', maxx - 130, 170, font_title, brightblue)
    Font.Draw ('5', maxx - 290, 170, font_title, brightblue)
    if keydown (o) then
	if my >= 30 and my <= 70 then
	    if mx >= 70 and mx <= 230 then
		bot_1
	    elsif mx >= 1050 and mx <= 1210 then
		bot_2
	    end if
	end if
    end if
    drawfillbox (380, 430, 540, 580, 10)
    drawfillbox (560, 430, 710, 580, 10)
    drawfillbox (730, 430, 880, 580, 10)
    drawfillbox (470, 270, 620, 420, 10)
    drawfillbox (645, 270, 795, 420, 10)
    if o ~= 0 then
	if my >= 430 and my <= 580 then
	    if mx >= 380 and mx <= 540 then
		stage_select := 1
	    elsif mx >= 560 and mx <= 710 then
		stage_select := 2
	    elsif mx >= 730 and mx <= 880 then
		stage_select := 3
	    end if
	end if
	if my >= 270 and my <= 420 then
	    if mx >= 470 and mx <= 620 then
		stage_select := 4
	    elsif mx >= 645 and mx <= 795 then
		stage_select := 5
	    end if
	end if
    end if
    if stage_select = 1 then
	drawfillbox (390, 440, 530, 570, black)
    else
	drawfillbox (385, 435, 535, 575, black)
    end if
    if stage_select = 2 then
	drawfillbox (570, 440, 700, 570, black)
    else
	drawfillbox (565, 435, 705, 575, black)
    end if
    if stage_select = 3 then
	drawfillbox (740, 440, 870, 570, black)
    else
	drawfillbox (735, 435, 875, 575, black)
    end if
    if stage_select = 4 then
	drawfillbox (480, 280, 610, 410, black)
    else
	drawfillbox (475, 275, 615, 415, black)
    end if
    if stage_select = 5 then
	drawfillbox (655, 280, 785, 410, black)
    else
	drawfillbox (650, 275, 790, 415, black)
    end if
    Draw.ThickLine (390, 445, 530, 445, 5, 10)
    Draw.ThickLine (400, 470, 440, 470, 5, 10)
    Draw.ThickLine (520, 470, 480, 470, 5, 10)
    Draw.ThickLine (440, 500, 480, 500, 5, 10)
    Draw.ThickLine (570, 445, 700, 445, 5, 10)
    Draw.ThickLine (590, 480, 640, 480, 5, 10)
    Draw.ThickLine (740, 445, 870, 445, 5, 10)
    Pic.Draw(re,735,435,picMerge)
    Draw.ThickLine (480, 285, 610, 285, 5, 10)
    Font.Draw('?', 710,330,font_button,10)
end select_button

