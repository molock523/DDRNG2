return Def.ActorFrame {
    LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"));
	LoadActor( "background" )..{
		InitCommand=cmd(Center);
        OffCommand=cmd(linear,0.5;diffusealpha,0);
	};
}