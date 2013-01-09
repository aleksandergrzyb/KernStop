local Button = {}
    --[[
    
    onEvent
    onPress
    onRelease
    
    active
    
    normal
    normalWidth
    normalHeight
    
    normalText
    font
    textSize
    textColorNormal{}
    
    over
    overWidth
    overHeight
    
	overText
    font
    textSize
    textColorOver{}
    
    onEvent
    onPress
    onRelease
    
    ]]

local function newAdvBtnHandler( self, event )

	local result = true

	local default = self[1]
	local over = self[2]
	
	-- General "onEvent" function overrides onPress and onRelease, if present
	local onEvent = self._onEvent
	
	local onPress = self._onPress
	local onRelease = self._onRelease

	local buttonEvent = {}
	if (self._id) then
		buttonEvent.id = self._id
	end

	local phase = event.phase
	if "began" == phase then
		if over then 
			default.isVisible = false
			over.isVisible = true
		end

		if onEvent then
			buttonEvent.phase = "press"
			result = onEvent( buttonEvent )
		elseif onPress then
			result = onPress( event )
		end

		-- Subsequent touch events will target button even if they are outside the contentBounds of button
		display.getCurrentStage():setFocus( self, event.id )
		self.isFocus = true
		
	elseif self.isFocus then
		local bounds = self.contentBounds
		local x,y = event.x,event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if "moved" == phase then
			if over then
				-- The rollover image should only be visible while the finger is within button's contentBounds
				default.isVisible = not isWithinBounds
				over.isVisible = isWithinBounds
			end
			
		elseif "ended" == phase or "cancelled" == phase then 
			if over then 
				default.isVisible = true
				over.isVisible = false
			end
			
			if "ended" == phase then
				-- Only consider this a "click" if the user lifts their finger inside button's contentBounds
				if isWithinBounds then
					if onEvent then
						buttonEvent.phase = "release"
						result = onEvent( buttonEvent )
					elseif onRelease then
						result = onRelease( event )
					end
				end
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
		end
	end

	return result
end

Button.newAdvBtn = function(params)
    local params = params
    if not params then
        error("You must supply parameters to make a new button")
        return false
    end

    local button = display.newGroup()
    button.active = tostring(params.active) ~= "false"

    local normalImg
    if params.normalWidth and params.normalHeight then
        normalImg = display.newImageRect(params.normal, params.normalWidth, params.normalHeight)
        normalImg:setReferencePoint(params.ref or display.TopLeftReferencePoint)
    elseif params.normalText then
        params.textColorNormal = params.textColorNormal or {255,255,255}
        normalImg = display.newText(params.normalText, 0, 0, params.font, params.textSize)
        normalImg:setReferencePoint(params.ref or display.CenterLeftReferencePoint)
        normalImg:setTextColor(params.textColorNormal[1],params.textColorNormal[2],params.textColorNormal[3])
    else
        normalImg = display.newImage(params.normal)
        normalImg:setReferencePoint(params.ref or display.TopLeftReferencePoint)
    end
    normalImg.x, normalImg.y = 0, 0

    local overImg
    if params.overWidth and params.overHeight then
        overImg = display.newImageRect(params.over, params.overWidth, params.overHeight)
        overImg:setReferencePoint(params.ref or display.TopLeftReferencePoint)
    elseif params.overText then
        params.textColorOver = params.textColorNormal or {0,0,0}
        overImg = display.newText(params.overText, 0, 0, params.font, params.textSize)
        overImg:setReferencePoint(params.ref or display.CenterLeftReferencePoint)
        overImg:setTextColor(params.textColorOver[1],params.textColorOver[2],params.textColorOver[3])
    else
        overImg = display.newImage(params.over)
        overImg:setReferencePoint(params.ref or display.TopLeftReferencePoint)
    end
    overImg.x, overImg.y = 0, 0

    if not button.active then
        normalImg.isVisible  = false
    else
        overImg.isVisible = false
    end

    button:insert(normalImg)
    button:insert(overImg)

    button.touch = newAdvBtnHandler
    
    if normalImg.text then
        normalImgRect = display.newRect(0, 0, normalImg.contentWidth, normalImg.contentHeight*.5)
        normalImgRect:setReferencePoint(display.CenterLeftReferencePoint)
        normalImgRect:setFillColor(0,0,0,0)
        overImgRect = display.newRect(0, 0, overImg.contentWidth, overImg.contentHeight*.5)
        overImgRect:setReferencePoint(display.CenterLeftReferencePoint)
        overImgRect:setFillColor(0,0,0,0)
        local rectGroup = display.newGroup(normalImgRect, overImgRect)
        rectGroup:addEventListener("touch", button)
        button:insert(rectGroup)
    else
        button:addEventListener("touch", button)
    end
	
	if ( params.onPress and ( type(params.onPress) == "function" ) ) then
		button._onPress = params.onPress
	end
	if ( params.onRelease and ( type(params.onRelease) == "function" ) ) then
		button._onRelease = params.onRelease
	end
	
	if (params.onEvent and ( type(params.onEvent) == "function" ) ) then
		button._onEvent = params.onEvent
	end
	
	button.oldRemoveSelf = button.removeSelf
	function button:removeSelf()
		button:removeEventListener("touch", button)
		button:oldRemoveSelf()
		button = nil
	end

    return button
end


local function newBtnHandler( self, event )

	local result = true
	local image = self[1]
	local onEvent = self.onEvent
	local mode = self._mode
	local shift = self._shift
	local scale = self._scale
	local active = self.active--TODO active
	
	local buttonEvent = {}
	if (self._id) then
		buttonEvent.id = self._id
	end

	local phase = event.phase
	if "began" == phase then
		if(mode == "shift") then
			image.y = shift
			image.alpha = self._alpha
		else
			image:setScale(scale)
			image.alpha = self._alpha
		end
		display.getCurrentStage():setFocus( self, event.id )
		self.isFocus = true
		
	elseif self.isFocus then
		local bounds = self.contentBounds
		local x,y = event.x,event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if "moved" == phase then
			if not isWithinBounds then
				--normal state
				if(mode == "shift") then
					image.y = 0
					image.alpha = 1
				else
					image:setScale(1)
					image.alpha = 1
				end
			end
		elseif "ended" == phase or "cancelled" == phase then 
			--normal state
			if(mode == "shift") then
				image.y = 0
				image.alpha = 1
			else
				image:setScale(1)
				image.alpha = 1
			end
			
			if "ended" == phase then
				-- Only consider this a "click" if the user lifts their finger inside button's contentBounds
				if isWithinBounds then
					if onEvent then
						buttonEvent.phase = "release"
						if active then
							result = onEvent( buttonEvent )
						end
					end
				end
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
		end
	end

	return result
end


	--[[
	onEvent
	image
	width
	height
	overScale
	overAlpha
	active
	
	]]
Button.newBtn = function(params)
    local params = params
    if not params then
        error("You must supply parameters to make a new button")
        return false
    end

    local button = display.newGroup()
    button.active = tostring(params.active) ~= "false"
    button._scale = params.scale or 0.9
    button._alpha = params.alpha or 0.9
    button._mode = params.mode or "scale"
    button._shift = params.shift or 5

    local normalImg
    if params.image and params.width and params.height then
        normalImg = display.newImageRect(params.image, params.width, params.height)
        --normalImg:setReferencePoint(display.TopLeftReferencePoint)
        --reference point
    else
        error("You must supply at least image path, width and height")
    end
    normalImg.x, normalImg.y = 0, 0
    button:insert(normalImg)

    button.touch = newBtnHandler
    button:addEventListener("touch", button)
	
	if (params.onEvent and ( type(params.onEvent) == "function" ) ) then
		button.onEvent = params.onEvent
	end
	
	button.oldRemoveSelf = button.removeSelf
	function button:removeSelf()
		button:removeEventListener("touch", button)
		button:oldRemoveSelf()
		button = nil
	end

    return button
end



return Button