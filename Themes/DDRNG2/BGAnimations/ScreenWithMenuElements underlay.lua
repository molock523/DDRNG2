return Def.ActorFrame {
    LoadActor("_mask_default_169")..{
        Condition=aspectratio()=="16:9";
        InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,"BlendMode_NoEffect");
    };
    LoadActor("_mask_default_43")..{
        Condition=aspectratio()=="4:3";
        InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,"BlendMode_NoEffect");
    };
};