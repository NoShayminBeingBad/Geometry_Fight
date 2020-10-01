%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s):  Raymond Ma
% Program Name :  Geometry Fight
% Description  :  A Fighting game with shapes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% SUBPROGRAMS %%%%%

%Draws different types of triangles
proc drawStageTriangle (base, x1, x2, height : real, col : int)
    var a : int
    if x1 - x2 > 0 then
	a := -1
    else
	a := 1
    end if
    drawline (round (x1), round (base), round (x2), round (base), col)
    drawline (round (x1), round (base), round (x1), round (base + height), col)
    drawline (round (x1), round (base + height), round (x2), round (base), col)
    drawfill (round (x1 + a), round (base + height - 3), col, col)
end drawStageTriangle

proc drawtriangle (base, x1, x2, height : real, col : int)
    var a : real
    if base + height > base then
	a := height - 1
    else
	a := height + 1
    end if
    drawline (round (x1), round (base), round (x2), round (base), col)
    drawline (round (x1), round (base), round ((x1 + x2) / 2), round (base + height), col)
    drawline (round (x2), round (base), round ((x1 + x2) / 2), round (base + height), col)
    drawfill (round ((x1 + x2) / 2), round (base + 1), col, col)
end drawtriangle

%Draws stage 1
proc stage1
    ground_level := round (maxy * 0.1250)
    drawfillbox (0, 0, maxx, ground_level, stagecol)
    drawfillbox (round (maxx * 0.1), round (maxy * 0.225), round (maxx * 0.3466), round (maxy / 4), stagecol)
    drawfillbox (round (maxx * 0.9), round (maxy * 0.225), round (maxx * 0.6533), round (maxy / 4), stagecol)
    drawfillbox (round (maxx * 0.3666), round (maxy * 0.34375), round (maxx * 0.63333), round (maxy * 0.36875), stagecol)
end stage1

%Draws stage 2
proc stage2
    stagey := 200
    ground_level := round (maxy / 8)
    drawfillbox (0, 0, maxx, round (maxy / 8), 10)
    drawfillbox (stagex, stagey, stagex + round (maxx * 0.3), stagey - round (maxy * 0.01875), 10)
    stagex += sdx
    if stagex >= round (750) then
	sdx := -2
    elsif stagex <= round (120) then
	sdx := 2
    end if
    for a : 1 .. 2
	for i : 1 .. 2
	    if select1 = 4 or select2 = 4 then
		if mine (a, i) -> attack and
			mine (a, i) -> ground and mine (a, i) -> y - mine (a, i) -> r - 2 > stagey - round (maxy * 0.01875) and mine (a, i) -> y - mine (a, i) -> r - 2 < stagey and mine (a, i) -> x <
			stagex +
			round (maxx * 0.3) and mine (a, i) -> x > stagex then
		    mine (a, i) -> x += sdx
		end if
	    end if
	end for
	if player (a) -> ground and player (a) -> y - player (a) -> r - 2 > stagey - round (maxy * 0.01875) and player (a) -> y - player (a) -> r - 2 < stagey and player (a) -> x < stagex +
		round (maxx * 0.3) and player (a) -> x > stagex then
	    player (a) -> x += sdx
	end if
    end for
end stage2

%Draws stage 3
proc stage3
    ground_level := round (maxy * 0.18)
    drawfillbox (0, 0, maxx, round (maxy * 0.18), 10)
    if stagey < 115 and frames - stagetimer > 300 and frames - stagetimer < 900 then
	drawStageTriangle (stagey, 0, maxx / 3, maxy / 2, 10)
	drawStageTriangle (stagey, maxx, maxx * 0.6666, maxy / 2, 10)
	stagey += 2
    end if
    if stagey > 115 and frames - stagetimer <= 900 then
	drawStageTriangle (stagey, 0, maxx / 3, maxy / 2, 10)
	drawStageTriangle (stagey, maxx, maxx * 0.6666, maxy / 2, 10)
    end if
    if frames - stagetimer > 900 and frames - stagetimer < 1500 then
	drawStageTriangle (stagey, 0, maxx / 3, maxy / 2, 10)
	drawStageTriangle (stagey, maxx, maxx * 0.6666, maxy / 2, 10)
	stagey -= 2
    end if
    if frames - stagetimer > 1500 and frames - stagetimer < 1600 then
	stagey := round (maxy * 0.08)
	stagey2 := 0
    end if
    if frames - stagetimer > 2100 and frames - stagetimer < 3000 and stagey <= 400 then
	drawfillbox (round (maxx * 0.16666), stagey, round (maxx * 0.83333), round (stagey + maxy * 0.03125), 10)
	drawfillbox (0, stagey2, round (maxx * 0.15), stagey2 + round (maxy * 0.01875), 10)
	drawfillbox (round (maxx * 0.86), stagey2, maxx, round (stagey2 + maxy * 0.01875), 10)
	stagey += 2
	stagey2 += 1
    end if
    if frames - stagetimer > 2200 and frames - stagetimer < 3000 then
	drawfillbox (round (maxx * 0.16666), stagey, round (maxx * 0.83333), round (stagey + maxy * 0.03125), 10)
	drawfillbox (0, stagey2, round (maxx * 0.15), stagey2 + round (maxy * 0.01875), 10)
	drawfillbox (round (maxx * 0.86), stagey2, maxx, round (stagey2 + maxy * 0.01875), 10)
	stagey2 += sdx
	if stagey2 >= round (maxy * 0.6) then
	    sdx := -1
	elsif stagey2 <= round (maxy * 0.2) then
	    sdx := 1
	end if
    end if
    if frames - stagetimer > 3000 then
	drawfillbox (round (maxx * 0.16666), stagey, round (maxx * 0.83333), round (stagey + maxy * 0.03125), 10)
	drawfillbox (0, stagey2, round (maxx * 0.15), stagey2 + round (maxy * 0.01875), 10)
	drawfillbox (round (maxx * 0.86), stagey2, maxx, round (stagey2 + maxy * 0.01875), 10)
	stagey -= 2
	stagey2 -= 1
    end if
    if frames - stagetimer > 3500 then
	stagetimer := frames
	stagey := -300
	stagey2 := 0
    end if
end stage3

%Draws stage 4
proc stage4
    ground_level := round (maxy / 8)
    drawfillbox (0, 0, maxx, round (maxy / 8), 10)
end stage4
