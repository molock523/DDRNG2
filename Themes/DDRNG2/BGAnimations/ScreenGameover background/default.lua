return Def.ActorFrame {
	LoadActor( "background" )..{
		InitCommand=cmd(Center);
	};
    LoadActor(THEME:GetPathS("ScreenGameover","music"))..{
        OnCommand=cmd(play);  
    };
}