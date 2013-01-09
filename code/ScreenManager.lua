local ScreenManager = {}

local GameManager = require "GameManager"
local MainMenu = require "MainMenu"
local GameResult = require "GameResult"

local setTimer = timer.performWithDelay
local clearTimer = timer.cancel

ScreenManager.new = function()
	--functions
	local construct
	local changeScreen
	local onEvent
	local addEvents
	local removeEvents

	local m = display.newGroup()
	m.bg = display.newImageRect("bg.jpg", 538, 384)
	m.bg:center()
	m:insert(m.bg)
	m.nextScreen = display.newGroup()
	m.currentScreen = display.newGroup()
	m.loading = nil
	m.lTimer = nil
	m.current = nil
	m.next = nil
	m.isTransition = false
	function construct()
		m:insert(m.nextScreen,m.currentScreen)
		m.loading = display.newImageRect("loading.png", 128,64)
		m.loading:setPos(5000, 5000)
		m.loading.isVisible = false
		m:insert(m.loading)
	end
	
	function changeScreen(nextScene)
		m.currentScreen:insert(m.current)
		m.loading:center(); m.loading.isVisible = true
		
		setTimer(35, function(e)
				clearTimer(e.source)
				m.current:removeSelf()
				m.next = nextScene.new()
				m.nextScreen:insert(m.next)
				m.current = m.next
				m.loading:setPos(5000,5000); m.loading.isVisible = false
				collectgarbage("collect")
				setTimer(35, function(e) clearTimer(e.source); m.isTransition = false end, 1)
			end, 1)
	end	
	
	function onEvent(e)
		print("ScreenManager onEvent: " .. e.type)
		if m.isTransition ~= true then
			if e.type == GameEvent.MAIN_MENU then 
				m.isTransition = true
				changeScreen(MainMenu)
			elseif e.type == GameEvent.RESULT then 
				m.isTransition = true
				changeScreen(GameResult)
			elseif e.type == GameEvent.NEXT then 
				m.isTransition = true
				changeScreen(GameManager)
			end
		else
			print("SKIP event: " .. e.type)
		end
	end
	
	function addEvents()
		Runtime:addEventListener(GameEvent.NAVI, onEvent)
	end
	
	function removeEvents()
		Runtime:removeEventListener(GameEvent.NAVI, onEvent)
	end
	
	--####################
	-- PUBLIC FUNCIONS
	
	function m:run()
		addEvents()
		--m.current = GameManager.new()
		m.current = MainMenu.new()
		m.nextScreen:insert(m.current)	
	end

	m.oldRemoveSelf = m.removeSelf
	function m:removeSelf()
		removeEvents()
		
		if m.current then m.current:removeSelf() end
		
		m:removeSelf()
		m = nil
	end
	
	construct()
	
	return m
end

return ScreenManager