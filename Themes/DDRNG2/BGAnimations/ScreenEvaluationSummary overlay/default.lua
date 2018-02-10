local function InputHandler(event)
if event.type == "InputEventType_Release" then return false end
    if event.DeviceInput.button == "DeviceButton_1" then
        SOUND:PlayOnce(THEME:GetPathS("","_common switch"))
        MESSAGEMAN:Broadcast("KP1")
    elseif event.DeviceInput.button == "DeviceButton_2" then
        SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
        MESSAGEMAN:Broadcast("KP2")
    elseif event.DeviceInput.button == "DeviceButton_3" then
        SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
        MESSAGEMAN:Broadcast("KP3")              
    elseif event.DeviceInput.button == "DeviceButton_4" then
        SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
        MESSAGEMAN:Broadcast("KP4")              
    elseif event.DeviceInput.button == "DeviceButton_5" then
        SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
        MESSAGEMAN:Broadcast("KP5")              
    end 
end

local t = Def.ActorFrame{
OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) end;
};
for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
t[#t+1] = LoadActor("info.lua", pn);
end

return t