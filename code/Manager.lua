--Controller
local Manager = {}

local ScreenManager = require "ScreenManager"
local Model = require "Model"
local GameEvent = require "GameEvent"

-- wczytuje z pliku na poczatku i usuwa wszystko po zamknieciu 

Manager.new = function()
-- functions
	local addEvents
	local removeEvents
	local onEvent
	local performExit
	local saveUserData
	
	local m = display.newGroup()
	m.model = nil
	m.screenManager = nil
	
	function addEvents()
		Runtime:addEventListener(GameEvent.SYS, onEvent)
	end
	
	function removeEvents()
		Runtime:removeEventListener(GameEvent.SYS, onEvent)
	end
	
	function onEvent(e)
		print("Manager onEvent: " .. e.type)
		if e.type == GameEvent.EXIT then
			performExit()
		elseif e.type == GameEvent.SAVE then
			m.model:saveUserData(_G.userData)
		end
	end
	
	function performExit()
		--TODO save
		os.exit()
	end
	
	function saveUserData()
		local data = _G.userData
		if _G.data then m:saveUserData(data) end
	end
	
	function m:run()
		_G.activeWord = 1
		_G.allChoose = true
		_G.font = { mainfont = "Mido" }
		_G.result = {}
		
		addEvents()
		
		m.model = Model.new()
		_G.configurationData = m.model:loadConfiguration()
		print(_G.configurationData.sets[1].words[1].lines[1])
		
		m.screenManager = ScreenManager.new()
		m:insert(m.screenManager)
		m.screenManager.run()
	end
	
	m.oldRemoveSelf = m.removeSelf
	function m:removeSelf()
		print "Manager destroyed"
		removeEvents()
		m.model:removeSelf()
		
		m:oldRemoveSelf()
		m = nil
	end
	
	return m
end

return Manager