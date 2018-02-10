local theme_config_default= {
    Announcer= true,
    UIColor= "Light",
    MusicWheel= "Grid",
    ConsoleType= "Home",
    Mode= "Regular",
    ShowSelectProfile= true,
}

theme_config= create_lua_config{
	name= "theme_config", file= "theme_config.lua",
	default= theme_config_default,
}

theme_config:load()
