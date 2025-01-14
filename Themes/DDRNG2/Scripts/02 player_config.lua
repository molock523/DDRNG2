local player_config_default= {
	ComboUnderField= true,
	FlashyCombo= false,
	GameplayShowStepsDisplay= true,
	GameplayShowScore= true,
	JudgmentUnderField= true,
	Protiming= false,
	ScreenFilter= "Off",
    NoteColour= "Vivid",
    EXScore= false,
    StageStars= false,
    CalorieDisplay= false,
    Target= "Off",
    Pacemaker= "Off",
    Announcer= "On",
    Character= "Off",
}

player_config= create_lua_config{
	name= "player_config", file= "player_config.lua",
	default= player_config_default,
}
add_standard_lua_config_save_load_hooks(player_config)