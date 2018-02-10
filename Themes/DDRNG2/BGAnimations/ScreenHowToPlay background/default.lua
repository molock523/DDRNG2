return Def.ActorFrame {
	LoadActor( "background" )..{
		InitCommand=cmd(Center);
        OffCommand=cmd(linear,0.5;diffusealpha,0);
	};
}