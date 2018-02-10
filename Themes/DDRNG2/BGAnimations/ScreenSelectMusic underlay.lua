local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame {
-- blur
    Def.Sprite{
        InitCommand=cmd(Center;scaletoclipped,SCREEN_WIDTH*1,SCREEN_HEIGHT*1;blend,"BlendMode_AlphaKnockOut";diffusealpha,0.5);
        CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,0.3;smooth,0.3;diffusealpha,1;playcommand,"Set");
        SetCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
            if song then
            self:Load(song:GetJacketPath()); 
            end
        end;
    };
};
t[#t+1] = LoadActor(THEME:GetPathB("","_mask_music_169.png"))..{
    Condition=aspectratio()=="16:9";
    InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,'BlendMode_NoEffect');
};
t[#t+1] = LoadActor(THEME:GetPathB("","_mask_music_43.png"))..{
    Condition=aspectratio()=="4:3";
    InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,'BlendMode_NoEffect');
};
return t