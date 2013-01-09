local RectButton = {}


local function onBtnTouch( self, event )

	local capture = true
	local onEvent = self.onTouch
	local mode = self._mode
	local shift = self._shift
	local scale = self._scale
	local active = self.active--TODO active
	
	local buttonEvent = {}

	local phase = event.phase
	if "began" == phase then
		self.alpha = self._alpha
		self.xScale, self.yScale = self._scale, self._scale
		
		display.getCurrentStage():setFocus( self, event.id )
		self.isFocus = true
		
	elseif self.isFocus then
		local bounds = self.contentBounds
		local x,y = event.x,event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if "moved" == phase then
			if not isWithinBounds then
				self.alpha = 1
				self.xScale, self.yScale = 1,1
			end
		elseif "ended" == phase or "cancelled" == phase then 
			--normal state
			self.alpha = 1
			self.xScale, self.yScale = 1,1
			
			if "ended" == phase then
				-- Only consider this a "click" if the user lifts their finger inside button's contentBounds
				if isWithinBounds then
					if onEvent then
						buttonEvent.phase = "release"
						if active then
							capture = onEvent( buttonEvent )
						end
					end
				end
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
		end
	end

	return capture
end


	--[[
	onTouch
	text
	image
	imageW
	imageH
	w
	h
	scale
	alpha
	color = {r,g,b}
	textColor = {r,g,b} 
	]]
RectButton.new = function(params)
	local params = params
	assert(params, "You must supply parameters to make a new button")
	
	local button = display.newGroup()
	button.active = tostring(params.active) ~= "false"
	button._scale = params.scale or 1
	button._alpha = params.alpha or 0.8
	button.rect = nil
	button.color = params.color or {58,58,69}
	button.textColor = params.textColor or {255,255,255}
	button.isNext = tostring(params.isNext) ~= "false"
	
	if params.w then
		button.rect = display.newRect(0,0, params.w, params.h or params.w)
		button.rect:setReferencePoint(display.CenterReferencePoint)
		button.rect.x, button.rect.y = 0,0
		button.rect:setFillColor(button.color[1],button.color[2],button.color[3])
		button:insert(button.rect)
		if params.isNext then
	    	button.rect2 = display.newRect(0,0, params.h * math.sqrt(2) * 0.5, params.h * math.sqrt(2) * 0.5)
	    	button.rect2:setReferencePoint(display.CenterReferencePoint)
	    	button.rect2.x, button.rect2.y = params.w * 0.5,0
			button.rect2:setFillColor(button.color[1],button.color[2],button.color[3])
			button.rect2.rotation = 45
			button:insert(button.rect2)
	    end
	    --normalImg:setReferencePoint(display.TopLeftReferencePoint)
	    --reference point
	else
	    error("You must supply at least width")
	end
	
	if params.text then
		button.label = display.newText(params.text, 0,0, _G.font.mainfont, 15)
		button.label:setTextColor(button.textColor[1],button.textColor[2],button.textColor[3])
		button:insert(button.label)
	elseif params.image then
		button.image = display.newImageRect(params.image, params.imageW, params.imageH)
		button:insert(button.image)
	else
	    error("You must supply at least label text or image")
	end
	
	button.touch = onBtnTouch
	button:addEventListener("touch", button)
	
	if (params.onTouch and ( type(params.onTouch) == "function" ) ) then
		button.onTouch = params.onTouch
	end
	
	button.oldRemoveSelf = button.removeSelf
	function button:removeSelf()
		self:removeEventListener("touch", button)
		self:oldRemoveSelf()
		self = nil
	end
	
	return button
end

return RectButton