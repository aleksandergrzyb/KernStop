--Controller
local GameResult = {}

local GameEvent = require "GameEvent"
local facebook = require "facebook"
local RectButton = require "RectButton"

-- wczytuje z pliku na poczatku i usuwa wszystko po zamknieciu 

local _W = display.contentWidth
local _H = display.contentHeight

GameResult.new = function()
-- functions
	local construct
	local calculateLastResult
	local onFacebookTouch
	local callFacebook
	local scoreAnimation
	local facebookListener
	local showButtons
	
	local onFacebook
	local onTwitter
	local onAgain
	local onMenu
	
	local rectMenu
	local rectFacebook
	local rectTwitter
	local rectRetry
	local number = 0
	local result = 0

	local m = display.newGroup()
	local score = display.newGroup()
	m:insert(score)
	
	function onFacebookTouch(self,e)
		if(e.phase == "ended") then
			--local message = "Testing posting from app."
			--message = url.escape(message)
			
			--[[native.showWebPopup(0, 80, _W, _H-80, "http://www.facebook.com/dialog/feed?display=touch&redirect_uri=http://www.blerdo.com&319051598109650=" .. 319051598109650 .. "&link=http://www.blerdo.com&picture=http://simplyzesty.com/wp-content/uploads//2011/10/facebook_logo.png&name=Your%20App&caption=iPhone%20app%20coming%20soon&description=test%20your%20description%20text%20here&message=" .. "test") 
			--local message = "Testing posting from app."
			--message = url.escape(message)
			native.showWebPopup(40, 20, 280, 300, "http://www.facebook.com/dialog/feed?display=touch&redirect_uri=http:www.blerdo.com&link=http:www.blerdo.com&picture=http://www.blerdo.com/images/blerdo_logo.jpg&name=TEST&message="..message)]]--
			callFacebook()
	    end
	end
	
	--[[
	function facebookListener(event)
		if ( "session" == event.type ) then
			if ( "login" == event.phase ) then
					facebook.request( "me/likes")
			end
		end
	end
	--]]
	
	function facebookListener(event)
		if ( "session" == event.type ) then
			if ( "login" == event.phase ) then
				local theMessage = "The best app ever ! Check this out !"
				facebook.request( "me/feed", "POST", {
				message = theMessage,
				name = "Blerdo.com",
				caption= "Blerdo.com",
				link = "http://www.blerdo.com/",
				picture = "http://www.blerdo.com/images/blerdo_logo.jpg" } )
			end
		end
	end

	function callFacebook()
		-- 319051598109650 appID
		facebook.login( "319051598109650", facebookListener, { "publish_stream" } )
	end
	
	function construct()
		print("Game results")
		_G.activeWord = 1
		
		score.maxText = display.newText("100", _W * 0.5 + 70, _H * 0.5 + 5 , _G.font.mainfont, 60 )
		score:insert(score.maxText)
		
		score.slash = display.newText("/", _W * 0.5, _H * 0.5 , _G.font.mainfont, 80 )
		score:insert(score.slash)
		
		
		score.textOne = display.newText("your score", _W * 0.5, _H * 0.5 - 60, _G.font.mainfont, 30 )
		score.textOne:setTextColor(79,79,79)
		score:insert(score.textOne)
		
		score.textTwo = display.newText("your score", _W * 0.5 + 40, _H * 0.5 + 60, _G.font.mainfont, 30 )
		score.textTwo:setTextColor(79,79,79)
		score:insert(score.textTwo)
		
		
		score.share = display.newText("share ", _W * 0.5 - 70, _H * 0.5 + 60, _G.font.mainfont, 30 )
		score.share:setTextColor(187,20,97)
		score:insert(score.share)
		
		score.y = - 30
		
		m.active = true
		
		showButtons()
		--[[
		rectMenu = display.newRect(40, _H - 90, 60, 60)
		rectMenu:setFillColor(79,79,79)
		
		rectFacebook = display.newRect(_W * 0.5 - 80, _H - 90, 60, 60)
		rectFacebook.touch = onFacebookTouch
		rectFacebook:setFillColor(79,79,79)
		
		rectTwitter = display.newRect(_W * 0.5 + 20, _H - 90, 60, 60)
		rectTwitter:setFillColor(79,79,79)
		
		rectRetry = display.newRect(_W - 100, _H - 90, 60, 60)
		rectRetry:setFillColor(79,79,79)
		
		
		rectFacebook:addEventListener("touch",rectFacebook)
		--]]
		
		
		calculateLastResult()
	end
	
	function onFacebook()
		if m.active then
			print"on facebook"
			callFacebook()
		end
	end
	
	function onTwitter()
		if m.active then
			print "on twitter"
		end
	end
	
	function onAgain()
		if m.active then
			m.active = false
			local event = GameEvent.getEvent(GameEvent.NEXT,m,nil)
			Runtime:dispatchEvent(event)
		end
	end
	
	function onMenu()
		if m.active then
			m.active = false
			local event = GameEvent.getEvent(GameEvent.MAIN_MENU,m,nil)
			Runtime:dispatchEvent(event)
		end
	end
	
	function showButtons()
		m.btnAgain  = RectButton.new({text = "again", w = 44})
 		m.btnAgain.x = 50
 		m.btnAgain.y = _H - 50
 		m.btnAgain.onTouch = onAgain
 		m:insert(m.btnAgain)
 		
 		
		m.btnFacebook = RectButton.new({text = "f", w = 44})
 		m.btnFacebook.x = math.floor(_W * 0.5) - 35
 		m.btnFacebook.y = _H - 50
 		m.btnFacebook.onTouch = onFacebook
 		m:insert(m.btnFacebook)
 		
 		m.btnTwitter = RectButton.new({text = "t", w = 44})
 		m.btnTwitter.x = math.floor(_W * 0.5) + 35
 		m.btnTwitter.y = _H - 50
 		m.btnTwitter.onTouch = onTwitter
 		m:insert(m.btnTwitter)
 		
 		
		m.btnMenu = RectButton.new({text = "menu", w = 44})
 		m.btnMenu.x = _W - 50
 		m.btnMenu.y = _H - 50
 		m.btnMenu.onTouch = onMenu
 		m:insert(m.btnMenu)
	end
	
	
	function calculateLastResult()
		for i = 1, #_G.configurationData.sets[1].words do
			result = result + _G.result[i]
		end
		result = result / #_G.configurationData.sets[1].words
		score.resultText = display.newText("" .. 0 , _W * 0.5 - 70, _H * 0.5 - 15 , _G.font.mainfont, 60 )
		score.resultText:setReferencePoint(display.CenterRightReferencePoint)
		score:insert(score.resultText)
		result = math.floor(result)
		timer.performWithDelay(17, scoreAnimation, result)
	end
	
	function scoreAnimation()
		number = number + 1
		score.resultText.text = "" .. number
	end
	
	m.oldRemoveSelf = m.removeSelf
	function m:removeSelf()
		print "GameResult destroyed"
		self:oldRemoveSelf()
		self = nil
	end
	
	
	construct()
	
	return m
end

return GameResult