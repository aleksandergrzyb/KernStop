--Controller
local GameManager = {}

local SpriteGrabber = require "SpriteGrabber"  
local GTween = require "GTween"
local RectButton = require "RectButton"
local GameEvent = require "GameEvent"
local GEase = GTween.easing

local setTimer = timer.performWithDelay
local clearTimer = timer.cancel
local _W = display.contentWidth
local _H = display.contentHeight


GameManager.new = function()
	-- functions
	local construct
	local buildLines -- tworzy linie do slowa
	local loadLetters
	local moveLetters
	local chooseLetters
	local shakeLatter
	local shakeAnimation
	local scoreAnimation
	local onRectTouch
	local onNextTouch
	local showCorrectLetters
	local showProgress
	local calculateResult
	local loadData
	local showNext
	local showTip
	local endAnimation
	
	local m = display.newGroup()
	local wordAndlines = display.newGroup()
	local nextButton = display.newGroup()
	m:insert(wordAndlines)
	m:insert(nextButton)
	
	local turnResult = {}
	local whichOne = {}
	local beginningOfWord
	local activeLetter = 0
	local rect
	local velocity
	local turnResultTemp
	local result
	local number = 0
	local scoreAddNumber = 0
	
	local lengthOfWord
	local numberToChooseLetters
	local letterX = {}
	local letterY = {}
		
	function onRectTouch(self,e)
		if(e.phase == "began" and m.isActive) then
			assert(wordAndlines.letters[whichOne[activeLetter]].tween1,"error tween doesnt exist")
			wordAndlines.letters[whichOne[activeLetter]].tween1:pause()
			wordAndlines.letters[whichOne[activeLetter]].tween2:pause()
			wordAndlines.letters[whichOne[activeLetter]].tween3:pause()
			turnResult[activeLetter] = turnResultTemp
			print("turnRes " .. turnResult[number])
			m.isActive = false
			timer.performWithDelay(500,shakeLetter,1)
		end
	end
	
	function onNextTouch()
		m.nextButton.active = false
		endAnimation()
	end
	
	--CONSTRUCTOR
	function construct()
		m.isActive = false
		if(_G.activeWord > 1) then
			showProgress()
		end
		loadData()
		buildLines()
		loadLetters()
		timer.performWithDelay(5000, chooseLetters ,1)
		timer.performWithDelay(6000, shakeLetter ,1)
		timer.performWithDelay(6250, showTip ,1)
		
		rect = display.newRect(0,0,_W,_H)
		rect.touch = onRectTouch
		rect:addEventListener("touch",rect)
		rect.alpha = 0.01
		
		print "GameManager created"
	end
	
			
	function loadData()
		lengthOfWord = #_G.configurationData.sets[1].words[_G.activeWord].letters
		numberToChooseLetters = _G.configurationData.sets[1].words[_G.activeWord].randomLetters
		print("NUMER:" .. numberToChooseLetters)
		for i = 1,lengthOfWord do
			letterX[i] = _G.configurationData.sets[1].words[_G.activeWord].letters[i].x
			letterY[i] = _G.configurationData.sets[1].words[_G.activeWord].letters[i].y
		end
	end
	
	
	function buildLines()
		wordAndlines.lineOne = display.newRect(0, _G.configurationData.sets[1].words[_G.activeWord].lines[1], _W , 1)
		wordAndlines.lineOne:setFillColor(187,20,97)
		wordAndlines:insert(wordAndlines.lineOne)
		
		wordAndlines.lineTwo = display.newRect(0, _G.configurationData.sets[1].words[_G.activeWord].lines[2], _W , 1)
		wordAndlines.lineTwo:setFillColor(187,20,97)
		wordAndlines:insert(wordAndlines.lineTwo)
		
		wordAndlines.lineThree = display.newRect(0, _G.configurationData.sets[1].words[_G.activeWord].lines[3], _W , 1)
		wordAndlines.lineThree:setFillColor(187,20,97)
		wordAndlines:insert(wordAndlines.lineThree)
		
		wordAndlines.lineFour = display.newRect(0, _G.configurationData.sets[1].words[_G.activeWord].lines[4], _W , 1)
		wordAndlines.lineFour:setFillColor(187,20,97)
		wordAndlines:insert(wordAndlines.lineFour)
		
		wordAndlines.x = 0
		wordAndlines.y = _H * 0.5 - _G.configurationData.sets[1].words[_G.activeWord].lines[4] * 0.5
	end
	
	function loadLetters()
		
		wordAndlines.letters = {}
		
		for i = 1,lengthOfWord do
			wordAndlines.letters[i] = _G.setSpriteSheet:grabSprite(_G.configurationData.sets[1].words[_G.activeWord].name .. "_" .. i)
			wordAndlines.letters[i]:show(500, _G.configurationData.sets[1].words[_G.activeWord].letters[i].y,"tl")
			wordAndlines:insert(wordAndlines.letters[i])
		end
		
		beginningOfWord = (_W - (_G.configurationData.sets[1].words[_G.activeWord].letters[lengthOfWord].x + wordAndlines.letters[lengthOfWord].width )) * 0.5

		moveLetters()
	end
	
	function showProgress()
		m.progress = display.newGroup()
		m:insert(m.progress)
		
		m.progressRect = display.newRect(0,0, 40, 40)
		m.progressRect:setFillColor(187,20,97)
		m.progress:insert(m.progressRect)
		
		m.progressTextOne = display.newText("" .. _G.activeWord, 60, _H - 80, _G.font.mainfont, 15)
		m.progressTextOne.x, m.progressTextOne.y = 10, 10
		m.progress:insert(m.progressTextOne)
		
		m.progressTextTwo = display.newText("/", 70, _H - 70, _G.font.mainfont, 36)
		m.progressTextTwo.x, m.progressTextTwo.y = 20, 20
		m.progressTextTwo.rotation = 15
		m.progress:insert(m.progressTextTwo)
		
		m.progressTextThree = display.newText("" .. #_G.configurationData.sets[1].words, 80, _H - 65, _G.font.mainfont, 15)
		m.progressTextThree.x, m.progressTextThree.y = 30, 25
		m.progress:insert(m.progressTextThree)
		
		m.progress:setReferencePoint(display.CenterReferencePoint)
		m.progress.x = 50
		m.progress.y = _H - 50
		m.progress.alpha = 0
		m.progress.tween = transition.to(m.progress, {time=1000, alpha=1})
	end
	
	function showTip()
		m.tip = display.newGroup()
		m.tip1 = display.newText("tap the screen", 0,0, _G.font.mainfont, 16)
		m.tip1:setReferencePoint(display.CenterLeftReferencePoint)
		m.tip1.x = 0
		m.tip1:setTextColor(187,20,97)
		m.tip:insert(m.tip1)
		m.tip2 = display.newText(" to stop the letter", 0, 0, _G.font.mainfont, 16)
		m.tip2:setReferencePoint(display.CenterLeftReferencePoint)
		m.tip2.x = m.tip1.width * .5
		m.tip2:setTextColor(111,111,111)
		m.tip:insert(m.tip2)
		
		m.tip:setReferencePoint(display.CenterReferencePoint)
		m.tip.x, m.tip.y = _W * .5, wordAndlines.y - 40
		m:insert(m.tip)
		m.tip.alpha = 0
		m.tip.tween0 = transition.to(m.tip, {time=700, alpha=1})
		
		m.tip.tween = GTween.new(m.tip, 1, {alpha=0}, {delay = 2.5, reflect=true, repeatCount=2, onComplete = function() m.tip:removeSelf(); m.tip = nil end})
	end
	
	function moveLetters()
		for i = 1,lengthOfWord do 
			wordAndlines.letters[i].tween = GTween.new(wordAndlines.letters[i], .75, {x=_G.configurationData.sets[1].words[_G.activeWord].letters[i].x + beginningOfWord,y=_G.configurationData.sets[1].words[_G.activeWord].letters[i].y}, {delay = i * 0.5 + 1, ease = GEase.outQuintic})
		end
		if(_G.activeWord == 1) then
			timer.performWithDelay(450, function() showProgress() end,1)
		end
	end
	
	function chooseLetters()
		if _G.allChoose == false then 
			for i = 1,numberToChooseLetters do
				whichOne[i] = math.random(2,lengthOfWord - 1)
				local state = true
				while state do
					local c = 0
					
					for a = 1,i do
						if i ~= a then
				 			if whichOne[i] == whichOne[a] then
				 				repeat
				 					whichOne[i] = math.random(2,lengthOfWord - 1)
				 					state = true
				 				until whichOne[i] ~= whichOne[a]
				 			elseif whichOne[i] ~= whichOne[a] then
				 				c = c + 1
				 				if(c == i - 1) then
				 					state = false
				 				end
				 			end
				 		end
				 	end
				 	
				 	if(i == 1) then
				 		state = false
				 	end
				 	
			 	end
			end
		elseif _G.allChoose == true then
			for i = 1,numberToChooseLetters do
				whichOne[i] = math.random(1,lengthOfWord)
				local state = true
				while state do
					local c = 0
					
					for a = 1,i do
						if i ~= a then
				 			if whichOne[i] == whichOne[a] then
				 				repeat
				 					whichOne[i] = math.random(1,lengthOfWord)
				 					state = true
				 				until whichOne[i] ~= whichOne[a]
				 			elseif whichOne[i] ~= whichOne[a] then
				 				c = c + 1
				 				if(c == i - 1) then
				 					state = false
				 				end
				 			end
				 		end
				 	end
				 	
				 	if(i == 1) then
				 		state = false
				 	end
				 	
			 	end
			end
		end
		for i = 1, #whichOne do
			wordAndlines.letters[whichOne[i]].alpha = 0.5
		end
		table.sort(whichOne, function(a,b) return a<b end)
	end
	
	function shakeLetter()
		
		for i = 1,#wordAndlines.letters do 
			wordAndlines.letters[i].alpha = 1
			--wordAndlines.letters[i]:setFillColor(255,255,255)
			wordAndlines.letters[i].turns = 2
		end
		
		activeLetter = activeLetter + 1
		number = number + 1
		if(activeLetter <= #whichOne) then
			wordAndlines.letters[whichOne[activeLetter]].alpha = 0.5
			--wordAndlines.letters[whichOne[activeLetter]]:setFillColor(187,20,97)
			wordAndlines:insert(wordAndlines.letters[whichOne[activeLetter]])
			
			local startingPosition = math.random(1,40)
			startingPosition = startingPosition - 20
			velocity = 0.0375 * (20 - startingPosition)
			wordAndlines.letters[whichOne[activeLetter]].tween0 = GTween.new(wordAndlines.letters[whichOne[activeLetter]], .05, {x = letterX[whichOne[activeLetter]] + beginningOfWord + startingPosition,y = letterY[whichOne[activeLetter]]}, {delay = 0 , onComplete = function() shakeAnimation(whichOne[activeLetter]); m.isActive = true end})
		elseif(activeLetter > #whichOne) then
			m.isActive = false
			activeLetter = 0
			showCorrectLetters()
			calculateResult()
			showNext()
		end
	end
	
	function shakeAnimation(numberOfLetter)
		local a = numberOfLetter

		if(wordAndlines.letters[a].turns > 0) then
			if(wordAndlines.letters[a].turns < 2) then
				velocity = 0.75
			end
			
			turnResultTemp = wordAndlines.letters[a].turns
			
			wordAndlines.letters[a].tween1 = GTween.new(wordAndlines.letters[a], velocity, {x=_G.configurationData.sets[1].words[_G.activeWord].letters[a].x + beginningOfWord + 20 ,y=_G.configurationData.sets[1].words[_G.activeWord].letters[a].y}, {delay = 0 })
			
			wordAndlines.letters[a].tween2 = GTween.new(wordAndlines.letters[a], 1.5, {x=_G.configurationData.sets[1].words[_G.activeWord].letters[a].x + beginningOfWord - 20,y=_G.configurationData.sets[1].words[_G.activeWord].letters[a].y}, {delay = velocity })
			
			wordAndlines.letters[a].tween3 = GTween.new(wordAndlines.letters[a], .75, {x=_G.configurationData.sets[1].words[_G.activeWord].letters[a].x + beginningOfWord ,y=_G.configurationData.sets[1].words[_G.activeWord].letters[a].y}, {delay = velocity + 1.5, onComplete = function() wordAndlines.letters[a].turns = wordAndlines.letters[a].turns - 1 ; shakeAnimation(a) end })
			
		elseif(wordAndlines.letters[a].turns == 0) then
			turnResult[activeLetter] = 0
			m.isActive = false
			wordAndlines.letters[a].tween4 = GTween.new(wordAndlines.letters[a], .75, {x=_G.configurationData.sets[1].words[_G.activeWord].letters[a].x + beginningOfWord + 20,y=_G.configurationData.sets[1].words[_G.activeWord].letters[a].y}, {delay = 0, onComplete = function() timer.performWithDelay(500,shakeLetter(),1) end })
		end
	end
	
		
	function showCorrectLetters()
		for i = 1,#whichOne do
			wordAndlines.letters[lengthOfWord + i] = _G.setSpriteSheet:grabSprite(_G.configurationData.sets[1].words[_G.activeWord].name .. "_" .. whichOne[i])
			wordAndlines.letters[lengthOfWord + i]:show(_G.configurationData.sets[1].words[_G.activeWord].letters[whichOne[i]].x + beginningOfWord, _G.configurationData.sets[1].words[_G.activeWord].letters[whichOne[i]].y,"tl")
			wordAndlines.letters[lengthOfWord + i].alpha = 0.5
			wordAndlines:insert(wordAndlines.letters[lengthOfWord + i])
		end
	end
	
	function calculateResult()
		local mistake = 0
		_G.result[_G.activeWord] = 0
		for i = 1,#whichOne do
			mistake = math.abs(_G.configurationData.sets[1].words[_G.activeWord].letters[whichOne[i]].x + beginningOfWord - wordAndlines.letters[whichOne[i]].x)
			local letterResult = 20 - mistake
			if(letterResult <= 5) then
				if(turnResult[i] == 2) then
					_G.result[_G.activeWord] = letterResult * 1.5 + 15 + _G.result[_G.activeWord]
				elseif(turnResult[i] == 1) then
					_G.result[_G.activeWord] = letterResult * 1.5 + 10 + _G.result[_G.activeWord]
				else
					_G.result[_G.activeWord] = 0 + _G.result[_G.activeWord]
				end
			elseif(letterResult > 5 and letterResult <= 10) then
				if(turnResult[i] == 2) then
					_G.result[_G.activeWord] = letterResult * 2 + 20 + _G.result[_G.activeWord]
				elseif(turnResult[i] == 1) then
					_G.result[_G.activeWord] = letterResult * 2 + 10 + _G.result[_G.activeWord]
				else
					_G.result[_G.activeWord] = 0 + _G.result[_G.activeWord]
				end
			elseif(letterResult > 10 and letterResult <= 15) then
				if(turnResult[i] == 2) then
					_G.result[_G.activeWord] = letterResult * 2.5 + 25 + _G.result[_G.activeWord]
				elseif(turnResult[i] == 1) then
					_G.result[_G.activeWord] = letterResult * 2.5 + 15 + _G.result[_G.activeWord]
				else
					_G.result[_G.activeWord] = 0 + _G.result[_G.activeWord]
				end
			elseif(letterResult > 15 and letterResult <= 20) then
				if(turnResult[i] == 2) then
					_G.result[_G.activeWord] = letterResult * 3.5 + 30 + _G.result[_G.activeWord]
				elseif(turnResult[i] == 1) then
					_G.result[_G.activeWord] = letterResult * 3.5 + 15 + _G.result[_G.activeWord]
				else
					_G.result[_G.activeWord] = 0 + _G.result[_G.activeWord]
				end
			end
		end
		_G.result[_G.activeWord] = _G.result[_G.activeWord] / #whichOne
		_G.result[_G.activeWord] = math.floor(_G.result[_G.activeWord])
		if _G.result[_G.activeWord] > 100 then _G.result[_G.activeWord] = 100 end
		
		m.score = display.newGroup()
		m:insert(m.score)
		
		m.scoreTextOne = display.newText("" .. 0, _W * 0.5 - 25, _H * 0.75 - 5, system.nativeFont, 20)
		m.scoreTextOne:setReferencePoint(display.CenterRightReferencePoint)
		m.scoreTextOne.x, m.scoreTextOne.y = -25, -5
		m.score:insert(m.scoreTextOne)
		
		m.scoreTextTwo = display.newText("/", _W * 0.5, _H * 0.75, system.nativeFont, 40)
		m.scoreTextTwo.rotation = 15
		m.scoreTextTwo.x, m.scoreTextTwo.y = 0, 0
		m.score:insert(m.scoreTextTwo)
		
		m.scoreTextThree = display.newText("" .. 100, _W * 0.5 + 25, _H * 0.75 + 10, system.nativeFont, 20)
		m.scoreTextThree.x, m.scoreTextThree.y = 25, 10
		m.score:insert(m.scoreTextThree)
		
		m.score.x, m.score.y = _W * .5, _H - 50
		m.score.alpha = 0
		scoreAddNumber = 0
		transition.to(m.score, {time=500, alpha=1, onComplete=function() 
			if _G.result[_G.activeWord] > 0 then
				timer.performWithDelay(10, scoreAnimation, _G.result[_G.activeWord] )
			else 
				m.scoreTextOne.text = "0"
			end	
		end})
	end
	
	function scoreAnimation()
		m.scoreTextOne.text = "" .. scoreAddNumber
		scoreAddNumber = scoreAddNumber + 1
	end

	
	function showNext()
		m.nextButton = RectButton.new({text = "next", w = 40, h = 44, isNext = true })
		m.nextButton:setReferencePoint(display.CenterReferencePoint)
		m.nextButton.x = _W + 50
		m.nextButton.y = _H - 50
		m.nextButton.onTouch = onNextTouch		
		transition.to(m.nextButton, {x = _W - 50, delay = 1000})
		m:insert(m.nextButton)
	end
	
	function endAnimation()
		for i = 1, #whichOne do
			wordAndlines.letters[whichOne[i]].tween = GTween.new(wordAndlines.letters[whichOne[i]], .50, {x = letterX[whichOne[i]] + beginningOfWord}, {delay = 0, ease = GEase.outQuintic})
		end
		
		timer.performWithDelay(530, function()
			for i = 1, #whichOne do 
				wordAndlines.letters[lengthOfWord + i]:hide()
			end
		end)	
		
		for i = 1,lengthOfWord do 
			wordAndlines.letters[i].tween = GTween.new(wordAndlines.letters[i], .50, {x = - 100,y=_G.configurationData.sets[1].words[_G.activeWord].letters[i].y}, {delay = i * 0.1 + 1, ease = GEase.outQuintic, onComplete = function(e) e.target:hide()  end})
		end
		
		_G.activeWord = _G.activeWord + 1

		
		if(_G.activeWord - 1 ==  #_G.configurationData.sets[1].words) then
			--m.progress:removeSelf()
			print("Last Word")
			transition.to(m.nextButton, {x = _W + 50, delay = 1000})
			transition.to(wordAndlines, {y = 0, x = 0, delay = 2000})
			transition.to(wordAndlines.lineOne, {y = - 1, delay = 2000})
			transition.to(wordAndlines.lineTwo, {y = - 1, delay = 2000})
			transition.to(wordAndlines.lineThree, {y = 361, delay = 2000})
			transition.to(m.progress, {alpha = 0, delay = 1500})
			transition.to(m.score, {alpha = 0, delay = 1500})
			transition.to(wordAndlines.lineFour, {y = 361 , delay = 2000, onComplete = function()
				_G.setSpriteSheet:remove()
				local event = GameEvent.getEvent(GameEvent.RESULT,m,nil)
				Runtime:dispatchEvent(event)
			end})
		else
			print("next word")
			transition.to(m.nextButton, {x = _W + 50, delay = 1000})
			transition.to(wordAndlines.lineOne, {y = _G.configurationData.sets[1].words[_G.activeWord].lines[1], delay = 2000})
			transition.to(wordAndlines.lineTwo, {y = _G.configurationData.sets[1].words[_G.activeWord].lines[2], delay = 2000})
			transition.to(wordAndlines.lineThree, {y = _G.configurationData.sets[1].words[_G.activeWord].lines[3], delay = 2000})
			transition.to(wordAndlines.lineFour, {y = _G.configurationData.sets[1].words[_G.activeWord].lines[4], delay = 2000})
			transition.to(m.progress, {alpha = 0, delay = 1500})
			transition.to(m.score, {alpha = 0, delay = 1500})		
			transition.to(wordAndlines, {y=_H * 0.5 - _G.configurationData.sets[1].words[_G.activeWord].lines[4] * 0.5, delay = 2000, onComplete = function() 
				local event = GameEvent.getEvent(GameEvent.NEXT,m,nil)
				Runtime:dispatchEvent(event)
			end})
		end
	end
	
	-- DESTRUCTOR	
	m.oldRemoveSelf = m.removeSelf
	function m:removeSelf()
		print "GameManager destroyed"
		self:oldRemoveSelf()
		self = nil
	end
	
	construct()
	return m
end

return GameManager