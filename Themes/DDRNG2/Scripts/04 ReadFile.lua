function profile_or_player(pn)
	if PROFILEMAN:IsPersistentProfile(pn) then
		return ToEnumShortString(pn);
	else
		return ToEnumShortString(pn);
	end;
end;

function directory(pn)
    if MEMCARDMAN:GetCardState(pn) == 'MemoryCardState_none' then
        return THEME:GetCurrentThemeDirectory().."Save";
    else
        return THEME:GetCurrentThemeDirectory().."Save";
    end
end

function EXScore(pn)
		return Off
end;

function OpenFile(dir,name,pn,access)
    local f = RageFileUtil:CreateRageFile()
    local profile_or_player = profile_or_player(pn); 
    local dir = directory(pn).."/"..dir
    local name = name
    f:Open(dir.."/"..name,access)
    return f
end

function LoadFile(fileName, fileDir)
	local f = RageFileUtil.CreateRageFile()
	local FileExist = FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."Save/"..fileDir.."/"..fileName)
	local text
	
	fileName = fileName or "NewFile"
	fileType = fileType or ".cfg"
	fileDir = fileDir or ""
	
	if FileExist then
		f:Open((THEME:GetCurrentThemeDirectory().."Save/"..fileDir.."/"..fileName):gsub("new",""),1)
		text = f:Read()
		f:Close()
		f:destroy()
	else
		text = nil
		assert(FileExist,"The file "..fileName.." doesn't exist on "..fileDir..". Unable to load file.")
	end
	
	return text
end

function WriteFile(fileName,strToWrite,fileDir)
	local f = RageFileUtil.CreateRageFile()
	local FileExist = FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."Save/"..fileDir.."/"..fileName)
	
	fileName = fileName or "NewFile"
	strToWrite = strToWrite or "Blank"
	fileDir = fileDir or ""
	
	if FileExist then
		f:Open((THEME:GetCurrentThemeDirectory().."Save/"..fileDir.."/"..fileName):gsub("new",""),2)
		f:Write(strToWrite)
		f:Close()
		f:destroy()
	else
		assert(FileExist,"The file "..fileName.." doesn't exist on "..fileDir..". Unable to write file.")
	end
end
