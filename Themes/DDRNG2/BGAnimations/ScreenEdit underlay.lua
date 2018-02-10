return Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(Center;setsize,SCREEN_WIDTH,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("#000000");diffusealpha,0.5);
	};        
};