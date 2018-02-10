function Interface()
    return "Interface"..theme_config:get_data().Interface
end

function UIColor()
    return theme_config:get_data().UIColor
end

function MusicWheelType()
    return "MusicWheel"..theme_config:get_data().MusicWheel
end

function MusicWheelFont()
    if MusicWheelType() == "MusicWheelList" or "MusicWheelOld-style" then return "Common Normal"
    else return "Common Bold" end
end

function ConsoleType()
    return theme_config:get_data().ConsoleType
end

function ShowSelectProfile()
    return theme_config:get_data().ShowSelectProfile
end

function GetRival()
    return player_config:get_data().Target
end

function GetCharacter()
    return player_config:get_data().Character
end