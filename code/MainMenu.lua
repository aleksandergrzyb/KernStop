--Controller
local MainMenu = {}

local SpriteGrabber = require("SpriteGrabber")
local GTween = require "GTween"
local GameEvent = require "GameEvent"
local RectButton = require "RectButton"
local GEase = GTween.easing

local _W = display.contentWidth
local _H = display.contentHeight

MainMenu.new = function()
	-- functions
	local construct
	local showLines
	local showTip
	local showLetters
	local showFacebook
	local showTwitter
	local moveLetters
	local moveLetterE
	local onRectTouch
	local onFacebookTouch
	local onTwitterTouch
		
	-- groups
	local m = display.newGroup()
	local wordAndLines = display.newGroup()
	
	m:insert(wordAndLines)
	
	-- variables
	local isMoving = false
	local beginningOfWord = nil
	local rectFacebook
	local rectTwitter
	
	local data = {
		name = "KernStop",
		lines = {0,21,62,82},
		letters = {
			{x = 0, y = 2},
			{x = 64, y = 22},
			{x = 105, y = 22},
			{x = 143, y = 22},
			{x = 219, y = 0},
			{x = 267, y = 11},
			{x = 302, y = 21},
			{x = 345, y = 21}
		}
	}
		
	--CONSTRUCTOR
	function construct()
		showLines()
		showLetters()
		wordAndLines.letters[2].alpha = 0.5
		--wordAndLines.letters[2]:setFillColor(187,20,97)
		wordAndLines:insert(wordAndLines.letters[2])
		
		m.blerdo = display.newImage("logo.png", 0, 0)
		m.blerdo.x = _W * 0.5
		m.blerdo.y = _H - 50
		m.blerdo:scale(0.5,0.5)
		m:insert(m.blerdo)
		
		m.rect = display.newRect(0, 0, _W, _H)
		m.rect.alpha = 0.01
		m.rect.touch = onRectTouch
		m:insert(m.rect)
		m.active = true
 		
 		timer.performWithDelay(1300, showFacebook, 1)
 		timer.performWithDelay(1300, showTwitter, 1)
 		timer.performWithDelay(5500, showTip, 1)
 		
 		_G.setSpriteSheet = SpriteGrabber.grabSheet("SetA")
		
		print "MainMenu created"
	end
	
	-- dodana linia
	
	function showLines()
		wordAndLines.lineOne = display.newRect(0, data.lines[1], _W , 1)
		wordAndLines.lineOne:setFillColor(187,20,97)
		wordAndLines:insert(wordAndLines.lineOne)
		
		wordAndLines.lineTwo = display.newRect(0, data.lines[2], _W , 1)
		wordAndLines.lineTwo:setFillColor(187,20,97)
		wordAndLines:insert(wordAndLines.lineTwo)
		
		wordAndLines.lineThree = display.newRect(0, data.lines[3], _W , 1)
		wordAndLines.lineThree:setFillColor(187,20,97)
		wordAndLines:insert(wordAndLines.lineThree)
		
		wordAndLines.lineFour = display.newRect(0, data.lines[4], _W , 1)
		wordAndLines.lineFour:setFillColor(187,20,97)
		wordAndLines:insert(wordAndLines.lineFour)
		
		wordAndLines.x = 0
		wordAndLines.y = _H * 0.5 - data.lines[4] * 0.5
	end
	
	function showLetters()
		m.setSpriteSheet = SpriteGrabber.grabSheet("KernStop")
		wordAndLines.letters = {}
		
		for i = 1,8 do
			wordAndLines.letters[i] = m.setSpriteSheet:grabSprite(data.name .. "_" .. i)
			wordAndLines.letters[i]:show(500, data.letters[i].y,"tl")
			wordAndLines:insert(wordAndLines.letters[i])
		end
		
		beginningOfWord = (_W - (data.letters[8].x + wordAndLines.letters[8].width )) * 0.5

		moveLetters()
	end
	
	function moveLetters()
		for i = 1,7 do 
			wordAndLines.letters[i].tween = GTween.new(wordAndLines.letters[i], .75, {x = data.letters[i].x + beginningOfWord, y = data.letters[i].y}, {delay = i * 0.5 + 1, ease = GEase.outQuintic})
		end
		
		wordAndLines.letters[8].tween = GTween.new(wordAndLines.letters[8], .75, {x = data.letters[8].x + beginningOfWord, y = data.letters[8].y}, {delay = 8 * 0.5 + 1, ease = GEase.outQuintic, onComplete = function() isMoving = true; moveLetterE(); m.rect:addEventListener("touch",m.rect) end })
		
	end	
	
	function showTip()
		m.tip = display.newGroup()
		m.tip1 = display.newText("tap the screen", 0,0, _G.font.mainfont, 16)
		m.tip1:setReferencePoint(display.CenterLeftReferencePoint)
		m.tip1.x = 0
		m.tip1:setTextColor(187,20,97)
		m.tip:insert(m.tip1)
		m.tip2 = display.newText(" to start the game", 0, 0, _G.font.mainfont, 16)
		m.tip2:setReferencePoint(display.CenterLeftReferencePoint)
		m.tip2.x = m.tip1.width * .5
		m.tip2:setTextColor(111,111,111)
		m.tip:insert(m.tip2)
		
		m.tip:setReferencePoint(display.CenterReferencePoint)
		m.tip.x, m.tip.y = _W * .5, wordAndLines.y - 40
		m:insert(m.tip)
		m.tip.alpha = 0
		m.tip.tween0 = transition.to(m.tip, {time=700, alpha=1})
		
		m.tip.tween = GTween.new(m.tip, 1, {alpha=0}, {delay = 2.5, reflect=true, repeatCount=100, onComplete = function() m.tip:removeSelf(); m.tip = nil end})
	end
	
	function onRectTouch(self,e)
		if(e.phase == "began" and m.active) then
			m.active = false
			if m.tip then m.tip.tween:pause() end
			isMoving = false
			local event = GameEvent.getEvent(GameEvent.NEXT,m,nil)
			Runtime:dispatchEvent(event)
		end
	end
	
	function onFacebookTouch()
		system.openURL("http://www.facebook.com/blerdo")
		return true
	end
	
	function onTwitterTouch()
		system.openURL("http://www.twitter.com/blerdo_com")
		return true
	end
	
	function showFacebook()
		m.rectFacebook = RectButton.new({text = "F", w = 44})
 		m.rectFacebook.x = 50
 		m.rectFacebook.y = _H - 50
 		m.rectFacebook.onTouch = onFacebookTouch
 		m:insert(m.rectFacebook)
	end
	
	function showTwitter()
		m.rectTwitter = RectButton.new({text = "T", w = 44})
 		m.rectTwitter.x = 120
 		m.rectTwitter.y = _H - 50
 		m.rectTwitter.onTouch = onTwitterTouch
 		m:insert(m.rectTwitter)
	end
	
	function moveLetterE()
		if(isMoving) then
			wordAndLines.letters[2].tween1 = GTween.new(wordAndLines.letters[2], 0.75, {x = data.letters[2].x + beginningOfWord + 20 ,y = data.letters[2].y}, {delay = 0})
				
			wordAndLines.letters[2].tween2 = GTween.new(wordAndLines.letters[2], 1.5, {x = data.letters[2].x + beginningOfWord - 20,y = data.letters[2].y}, {delay = 0.75})
				
			wordAndLines.letters[2].tween3 = GTween.new(wordAndLines.letters[2], 0.75, {x = data.letters[2].x + beginningOfWord ,y = data.letters[2].y}, {delay = 2.25, onComplete = function() moveLetterE(); end })
		end
	end
	
	-- DESTRUCTOR	
	m.oldRemoveSelf = m.removeSelf
	function m:removeSelf()
		self.setSpriteSheet:remove()
	
		print "MainMenu destroyed"
		self:oldRemoveSelf()
		self = nil
	end
	
	construct()
	return m
end

return MainMenu