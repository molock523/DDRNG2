local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame {
  InitCommand=cmd();
	Def.ActorFrame {
		LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"));
		LoadActor("konami") .. {
			OnCommand=cmd(FullScreen;diffusealpha,0;linear,0.5;diffusealpha,1;sleep,5;linear,0.5;diffusealpha,0);
		};
		LoadActor("ScreenCompany music.ogg") .. {
			OnCommand=cmd(play);
		};
         LoadActor("bemani") .. {
			OnCommand=cmd(FullScreen;diffusealpha,0;sleep,6;linear,0.5;diffusealpha,1;sleep,5;linear,0.5;diffusealpha,0);
		};
		LoadActor("e-amusement") .. {
			OnCommand=cmd(FullScreen;diffusealpha,0;sleep,12;linear,0.5;diffusealpha,1;sleep,5;linear,0.5;diffusealpha,0);
		};
		LoadActor("leeium") .. {
			OnCommand=cmd(FullScreen;diffusealpha,0;sleep,18;linear,0.5;diffusealpha,1;sleep,5;linear,0.5;diffusealpha,0);
		};        
	};
};

return t


	



