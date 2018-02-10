local t = Def.ActorFrame{
	LoadActor("Glow")..{
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.5);
	};    
	LoadActor("Frame")..{
		InitCommand=cmd();
	};
	
};

return t;