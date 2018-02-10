local song;
local group;

--arrange song position devide by 3
function arrangeXPosition(myself, index)
	if index%3==0 then
		myself:x(-300);
	elseif index%3==1 then
		myself:x(0);
	else
		myself:x(300);
	end;
end

function arrangeXPosition2(myself, index, offset)
	if index%3==0 then
		myself:x(-300+offset);
	elseif index%3==1 then
		myself:x(0+offset);
	else
		myself:x(300+offset);
	end;
end

--technika2/3 style hack ;)
function arrangeYPosition(myself, index)
	if index%3==0 then
		myself:y(100);
	elseif index%3==1 then
		myself:y(0);
	else
		myself:y(-100);
	end;
end

function arrangeYPosition2(myself, index, offset)
	if index%3==0 then
		myself:y(100+offset);
	elseif index%3==1 then
		myself:y(0+offset);
	else
		myself:y(-100+offset);
	end;
end

--main backing
local t = Def.ActorFrame {
SetMessageCommand=function(self,params)
    arrangeXPosition(self,params.Index,0);
    arrangeYPosition(self,params.Index,0);
end;

--banner
    LoadActor("_random");
    LoadActor("_random")..{
    InitCommand=cmd(setsize,300,300;blend,"BlendMode_Add";diffusealpha,0.5);
    SetMessageCommand=function(self,params)
        (cmd(diffuseshift;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0.5;effectclock,'beatnooffset'))(self);
        if params.HasFocus then
            self:visible(true);
        else
            self:visible(false);
        end
    end;
	};
    
};
return t;