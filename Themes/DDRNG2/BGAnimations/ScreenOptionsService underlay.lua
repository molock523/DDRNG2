local aspectsize;
if aspectratio()=="16:9" then
    aspectsize = SCREEN_WIDTH-324
elseif aspectratio()=="4:3" then
    aspectsize = SCREEN_WIDTH-40
end

return Def.ActorFrame {
    commonpanel(aspectsize,524,10,0.5,color("#f2f2f2"),color("#ffffff"))..{
        InitCommand=cmd(Center);
    };
    Def.Quad{
        InitCommand=cmd(xy,_screen.w/2-335,_screen.cy+142+20-10+3;setsize,200,66;diffuse,color("#000000");diffusealpha,0.15);
    };
};