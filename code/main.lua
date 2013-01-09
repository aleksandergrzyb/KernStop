display.setStatusBar(display.HiddenStatusBar)
--system.setIdleTimer( false )
--system.activate( "multitouch" )



local cls = require "CrawlspaceLib"

local setTimer = timer.performWithDelay
local clearTimer = timer.cancel


local HIDE_LOGO_TIME = 1000
local stage = display.getCurrentStage( )
local _mg = display.newGroup()
local _logo = display.newGroup()
stage:insert(_mg)
stage:insert(_logo)



local function hideLogo(e)
	print "hide logo"
	if e then clearTimer(e.source); e.source = nil; end
	local function remove()
		_logo:removeEventListener("touch", function() return true end)
		_logo:removeSelf(); _logo = nil
	end
	local function fadeOut()
		_logo[1]:fadeOut(250, remove)
	end
	if _logo then _logo[2]:fadeOut(250, fadeOut) end
end

local rect = display.newRect(0,0, 538,384, "c"); rect:setFillColor(0,0,0); rect:center(); _logo:insert(rect)
local logoImg = display.newImageRect("logo.png", 184, 58); logoImg:center(); _logo:insert(logoImg); _logo:addEventListener("touch", function() return true end)



print("scale: " .. scale)
print"----------------------------START---------------------------------"
--[
local Manager = require "Manager"

math.randomseed( os.time() )
math.random()
math.random()
math.random()

setTimer(250, function(e) 
		if e then clearTimer(e.source); e.source = nil end
		_allManager = Manager:new()
		_mg:insert(_allManager)
		_allManager:run()
		setTimer(HIDE_LOGO_TIME, hideLogo, 1) 
	end, 1)
	
--]]

--[ Uncomment to monitor app's lua memory/texture memory usage in terminal...
local mem = display.newText("0", 0,0, system.nativefont, 10)
mem:setReferencePoint(display.TopCenterReferencePoint)
mem.x, mem.y = 48,2
local tex = display.newText("0", 0,0, system.nativefont, 10)
tex:setReferencePoint(display.TopCenterReferencePoint)
tex.x, tex.y = 50, 12
local function garbagePrinting()
	collectgarbage("collect")
    local memUsage_str = string.format( "mem= %.3f KB", collectgarbage( "count" ) )
    --print( memUsage_str )
    mem.text = memUsage_str
    local texMemUsage_str = system.getInfo( "textureMemoryUsed" )
    texMemUsage_str = texMemUsage_str/1000
    texMemUsage_str = string.format( "tex = %.3f MB", texMemUsage_str )
    --print( texMemUsage_str )
    tex.text = texMemUsage_str
end

Runtime:addEventListener( "enterFrame", garbagePrinting )
--]]