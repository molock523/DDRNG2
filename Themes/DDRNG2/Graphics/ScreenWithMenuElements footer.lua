local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
-- bg
	Def.Quad{
        InitCommand=cmd(setsize,SCREEN_WIDTH,80;diffuse,color("#000000");diffusealpha,0.5);
	};
};

return t;
