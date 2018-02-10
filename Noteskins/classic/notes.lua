local skin_name= Var("skin_name")
return function(button_list, stepstype, skin_parameters)
local NoteColour = skin_parameters.color
	local rots= {Left= 90, Down= 0, Up= 180, Right= 270}
	local hold_redir= {
		Left= "left", Right= "right", Down= "down", Up= "up", 
	}
	local tail_redir= {
		Left= "left", Right= "right", Down= "up", Up= "down", 
	}     
	local parts_per_beat=4
    local tap_state_map = {}
    if NoteColour == "Vivid" then
        tap_state_map= {
            parts_per_beat= 4, quanta= {
                {per_beat= 1, states= {1,2,3,4}}, -- 4th
                {per_beat= 2, states= {5,6,7,8}}, -- 8th
                {per_beat= 3, states= {9,10,11,12}}, -- 12th
                {per_beat= 4, states= {13,14,15,16}}, -- 16th
                {per_beat= 6, states= {9,10,11,12}}, -- 24th
                {per_beat= 8, states= {13,14,15,16}}, -- 32nd
                {per_beat= 12, states= {9,10,11,12}}, -- 48th
                {per_beat= 16, states= {13,14,15,16}}, -- 64th
            },
        }
    elseif NoteColour == "Note" or "Rainbow" then
        tap_state_map= {
            parts_per_beat= 16, quanta= {
                {per_beat= 1, states= {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}, -- 4th
                {per_beat= 2, states= {17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32}}, -- 8th
                {per_beat= 3, states= {33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48}}, -- 12th
                {per_beat= 4, states= {49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64}}, -- 16th
                {per_beat= 6, states= {65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80}}, -- 24th
            },
        } 
    else
        tap_state_map= {
            parts_per_beat= parts_per_beat, quanta= {
                {per_beat= 4, states= {1,2,3,4}}, -- 4th
            },
        } 
    end
	local lift_state_map= DeepCopy(tap_state_map)
	for i, quanta in ipairs(lift_state_map.quanta) do
		quanta.states[1]= quanta.states[1] + 1
	end
	local mine_state_map= NoteSkin.single_quanta_state_map{1, 2, 3, 4, 5, 6, 7, 8}
	local hold_active_map= NoteSkin.single_quanta_state_map{2}
	local hold_inactive_map= NoteSkin.single_quanta_state_map{1} 
    local roll_active_map= NoteSkin.single_quanta_state_map{2}
	local roll_inactive_map= NoteSkin.single_quanta_state_map{1}     
	local hold_length= {
		start_note_offset= 0,
		end_note_offset= -.5,
		head_pixs= 32,
		body_pixs= 32,
		tail_pixs= 32,
	}   

	local columns= {}
	for i, button in ipairs(button_list) do
		local hold_tex= hold_redir[button].." hold 2x1.png"
		local revhold_tex= tail_redir[button].." hold 2x1.png"              
		local roll_tex= hold_redir[button].." roll 2x1.png"
		local revroll_tex= tail_redir[button].." roll 2x1.png"         
        local hold_head_tex= "head 2x1.png"
        local hold_tail_tex= hold_redir[button].." tail 2x1.png"    
		columns[i]= {
			width= 64,
			padding= 0,
			hold_gray_percent= .25,
			use_hold_heads_for_taps_on_row= true,
			anim_time= 1,
			quantum_time= 1,
			anim_uses_beats= true,
			taps= {
				NoteSkinTapPart_Tap= {
					state_map= tap_state_map,
					actor= Def.Sprite{Texture= "tap_note_"..NoteColour or "tap_note_vivid",
						InitCommand= function(self) self:rotationz(rots[button]) end,
                        ColumnJudgmentCommand= function(self,param)
                        if param.tap_note_score == "TapNoteScore_HitMine" then
                            self:diffusealpha(0):linear(0.2):diffusealpha(1)
                            end
                        end
                    ,}
                },                
				NoteSkinTapPart_Mine= {
					state_map= mine_state_map,
					actor= Def.Sprite{Texture= "down mine",	InitCommand= function(self) self:rotationz(rots[button]) end}},
                
				NoteSkinTapPart_Lift= {
					state_map= lift_state_map,
					actor= Def.Sprite{Texture= "tap_note_"..NoteColour, InitCommand= function(self) self:rotationz(rots[button]) end}},
			},
            optional_taps= {
				NoteSkinTapOptionalPart_HoldHead= {
					state_map= NoteSkin.single_quanta_state_map{1},
					inactive_state_map= NoteSkin.single_quanta_state_map{2},
					actor= Def.Sprite{Texture= "down head", InitCommand= function(self) self:rotationz(rots[button]) end}},
                
                NoteSkinTapOptionalPart_HoldTail= {                   
                    state_map= NoteSkin.single_quanta_state_map{1},
                    inactive_state_map= NoteSkin.single_quanta_state_map{2},
					actor= Def.Sprite{Texture= hold_redir[button].." tail 2x1.png",}},
                
                NoteSkinTapOptionalPart_RollTail= {                   
                    state_map= NoteSkin.single_quanta_state_map{1},
                    inactive_state_map= NoteSkin.single_quanta_state_map{2},
					actor= Def.Sprite{Texture= hold_redir[button].." roll tail 2x1.png",}},                 
            },            
           reverse_optional_taps= {                
				NoteSkinTapOptionalPart_HoldHead= {
					state_map= NoteSkin.single_quanta_state_map{1},
					inactive_state_map= NoteSkin.single_quanta_state_map{2},
					actor= Def.Sprite{Texture= "down head", InitCommand= function(self) self:rotationz(rots[button]) end}},
                
                NoteSkinTapOptionalPart_HoldTail= {                   
                    state_map= NoteSkin.single_quanta_state_map{1},
                    inactive_state_map= NoteSkin.single_quanta_state_map{2},
					actor= Def.Sprite{Texture= tail_redir[button].." tail 2x1.png", InitCommand= function(self) self:zoomy(-1) end}},                
            },          
			holds= {
				TapNoteSubType_Hold= {
					{
						state_map= hold_inactive_map,
						textures= {hold_tex},
						flip= "TexCoordFlipMode_None",
						disable_filtering= false,
						length_data= hold_length,
					},
					{
						state_map= hold_active_map,
						textures= {hold_tex},
						length_data= hold_length,
					},                   
				},
				TapNoteSubType_Roll= {
					{
						state_map= hold_inactive_map,
						textures= {roll_tex},
						flip= "TexCoordFlipMode_None",
						disable_filtering= false,
						length_data= hold_length,
					},
					{
						state_map= hold_active_map,
						textures= {roll_tex},
						length_data= hold_length,
					},                   
				},                
			},
			reverse_holds= {
				TapNoteSubType_Hold= {
					{
						state_map= hold_inactive_map,
						textures= {revhold_tex},
						flip= "TexCoordFlipMode_None",
						disable_filtering= false,
						length_data= hold_length,
					},
					{
						state_map= hold_active_map,
						textures= {revhold_tex},
						length_data= hold_length,
					},                   
				},
				TapNoteSubType_Roll= {
					{
						state_map= hold_inactive_map,
						textures= {revroll_tex},
						flip= "TexCoordFlipMode_None",
						disable_filtering= false,
						length_data= hold_length,
					},
					{
						state_map= hold_active_map,
						textures= {revroll_tex},
						length_data= hold_length,
					},                   
				},                
			},            
		}
	end
	return {
		columns= columns,
		vivid_operation = NoteColour == "Vivid",
	}
end