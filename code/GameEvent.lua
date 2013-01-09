GameEvent = {}

GameEvent.NAVI = "NAVI_EVENT"

GameEvent.MAIN_MENU = "MAIN_MENU"
GameEvent.RESULT = "RESULT"
GameEvent.NEXT = "NEXT"


-------------------------------------------------
GameEvent.SYS = "SYS_EVENT"

GameEvent.EXIT = "EXIT"
GameEvent.SAVE = "SAVE"



GameEvent.getEvent = function(_type, _target, _data)
	local e
	if _type == GameEvent.MAIN_MENU then
		e = {name=GameEvent.NAVI, type=GameEvent.MAIN_MENU, target=_target, data=_data}
	elseif _type == GameEvent.RESULT then
		e = {name=GameEvent.NAVI, type=GameEvent.RESULT, target=_target, data=_data}
	elseif _type == GameEvent.NEXT then
		e = {name=GameEvent.NAVI, type=GameEvent.NEXT, target=_target, data=_data}
	end
	
	
	
	if _type == GameEvent.EXIT then
		e = {name=GameEvent.SYS, type=GameEvent.EXIT, target=_target, data=_data}
	elseif _type == GameEvent.SAVE then
		e = {name=GameEvent.SYS, type=GameEvent.SAVE, target=_target, data=_data}
	end
	
	return e
end



return GameEvent