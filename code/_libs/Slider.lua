
--module(..., package.seeall)  --ACTIVATE THIS LINE IF USING DIRECTOR; REMOVE IF NOT

local math_abs = math.abs
local cw, ch, ox, oy = display.contentWidth, display.contentHeight, math_abs(display.screenOriginX), math_abs(display.screenOriginY)
--"ox" and "oy" calculate the X/Y 'offset' at different screen proportions, i.e. iPhone vs. Galaxy Tab vs. iPad



------------------------
--Setup Display Groups
------------------------

--IF -NOT- USING DIRECTOR
local sliderGroup = display.newGroup()
local dotGroup = display.newGroup()
--IF USING DIRECTOR
--local localGroup = display.newGroup()
--local sliderGroup = display.newGroup() ; localGroup:insert(sliderGroup)
--local dotGroup = display.newGroup() ; localGroup:insert(dotGroup)



------------------------
--Forward Declarations
------------------------

local pageDots = {}  --"container" table to reference dots (which indicate current slide position, as on iOS)
local slideDist = cw+ox+ox  --total left-to-right distance of a slide
local slideIndex = 0
local touchPos = 0
local lastPos = 0
local touchTime = 0
--A 'swipe' is basically just a SHORT (distance) and FAST (time) screen touch. The variable "coreSwipeDist" sets the DISTANCE aspect
--of a swipe. Default in this module is 1/10th the screen width. Adjust if you desire a longer or shorter distance to register as a 'swipe'
--The variable "coreSwipeTime" is the TIME aspect (in milliseconds) which registers as a swipe. If the user's touch is longer than this value,
--this module considers that motion a DRAG/HOLD, not a swipe. Adjust this time value to your desire.
--NOTE!!! After you determine the values that feel right to you, I suggest you replace these variables below (in function "screenMotion")
--with the hard-coded values, so Corona doesn't need to waste effort on upvalue lookups.
local coreSwipeDist = cw/10
local coreSwipeTime = 300
--------------------
local slideTrans = 0  --the tween transition variable; when set to 0, transition is not happening.
local maxSlideIndex = 0  --max number of slides, to be automatically set later.
local resist = 1



------------------------------
--Update slide position dots
------------------------------
--If you choose to eliminate the dots, you may remove this entire function, and all references to "pageDots"
local function updateDots( sIndex )

		for d=1,#pageDots do
		if ( d == sIndex+1 ) then pageDots[d].alpha = 1.0 else pageDots[d].alpha = 0.3 end
		end
end



-----------------------------
--Complete slide transition
-----------------------------
--Line 70: Cancels any existing tween transition (probably not necessary because transition is also cancelled on touch "began" phase)
--Line 71: Snaps the slide to its proper ending position (probably not necessary, but a minor fail-safe)
--Line 72: Calls the function to update the slide position dots.
local function transComplete( event )
	
		transition.cancel( slideTrans ) ; slideTrans = 0
		local targetX = (slideIndex*-slideDist) ; if ( sliderGroup.x ~= targetX ) then sliderGroup.x = targetX end
		updateDots( slideIndex )
end



----------------------------
--Transition to next slide
----------------------------
local function slideTween( targetX )

		--Overall transition time is 400 milliseconds by default. Adjust if you desire slower or faster slide movement.
		local transTime = ( (math_abs(sliderGroup.x-targetX))/slideDist) * 400
		if ( slideTrans ~= 0 ) then transition.cancel( slideTrans ) ; slideTrans = 0 end
		slideTrans = transition.to( sliderGroup, { x=targetX, time=transTime, transition = easing.outQuad, onComplete=transComplete } )
end



------------------------------------
--'Go to slide' function, optional
------------------------------------
--This function can be used to either "snap" or "move" to a specific slide in your stack.
--Usage:	FOR SNAP: gotoSlide( [slide], "snap" )
--			FOR MOVE: gotoSlide( [slide], "move" )
--Potential usage for this function: if you save the current slide position somewhere in your code (or in an external text file), you
--can retrieve that value later (i.e. on a future application load) to snap to the same slide that the user was previously viewing.
--Another possible usage: Call this function once using "snap" to go to a specific slide (perhaps a level screen). Then call the function
--again (after an elapsed time) and use "move" to drift to the next slide, indicating that the user has "unlocked" a new level.
local function gotoSlide( targetSlide, method )

		if ( slideTrans ~= 0 ) then transition.cancel( slideTrans ) ; slideTrans = 0 end
		local si = targetSlide-1 ; slideIndex = si ; local destX = (si*-slideDist)
		if ( method == "snap" ) then sliderGroup.x = destX ; updateDots( si )
		else slideTween( destX )
		end
end



-----------------------------------------------
--Core touch sensor + movement/swipe function
-----------------------------------------------
local function screenMotion( event )

		local phase = event.phase ; local eventX = event.x
		
		if ( "began" == phase ) then
			if ( slideTrans ~= 0 ) then transition.cancel( slideTrans ) ; slideTrans = 0 end
			touchPos = eventX ; lastPos = eventX ; touchTime = event.time

		elseif ( "moved" == phase ) then
			local dist = eventX-lastPos ; local res = resist
			--"resist" is the ratio (percentage) for the end-of-stack spring resistance effect. At either end of your stack of slides, if the
			--user tries to slide further, this module "resists" that movement to indicate that there are no more slides, just like iOS! :)
			--Default is "0.3" on line 126 ; you may change this, but 0.5 or higher risks the ability to move the slide off the screen!
			if ( ( slideIndex == 0 and dist > 0 ) or ( slideIndex == maxSlideIndex and dist < 0 ) ) then res = 0.3 else res = 1 end
			sliderGroup.x = sliderGroup.x+(dist*res) ; lastPos = eventX ; resist = res

		else
			local motionTime = system.getTimer()-touchTime
			local dist = eventX-touchPos ; local swipeDist = math_abs( dist )
			local overallDist = math_abs( sliderGroup.x+(slideIndex*slideDist) )
			local goNextSlide = false

			if ( resist ~= 1 ) then goNextSlide = false
			elseif ( motionTime <= coreSwipeTime and swipeDist >= coreSwipeDist ) then goNextSlide = true
			elseif ( motionTime > coreSwipeTime and overallDist >= slideDist*0.5 ) then goNextSlide = true end
		
			if ( goNextSlide == true and dist < 0 and resist == 1 ) then slideIndex = slideIndex+1
			elseif ( goNextSlide == true and dist > 0 and resist == 1 ) then slideIndex = slideIndex-1 end
			slideTween( slideIndex*-slideDist )
		end
end



---------------------------------------
--Initial setup, slide creation, etc.
---------------------------------------
local function initSetup()

		--You may create your slides individually, or in a loop. Each slide is a display group, so objects placed within each "slide" are
		--in positional reference to that slide! If you set something to "x=20", it will be x=20 in relation to the slide, not the screen.
		--IMPORTANT!!!!! Every element that you add to a slide (images, text, whatever) MUST be added to its display group "thisSlideGroup".
		
		local thisSlideGroup

		--create 4 sample slides using a loop:
		for i=1,4 do

			thisSlideGroup = display.newGroup() --IMPORTANT!!! Create a new display group for each slide!
			--localGroup:insert(thisSlideGroup) --ACTIVATE THIS LINE IF USING DIRECTOR

			-- slide background (image or just a simple rect in this example)
			local rect = display.newRect( -ox, -oy, cw+ox+ox, ch+oy+oy-110 )
			thisSlideGroup:insert( rect )
			rect:setFillColor( i*55, 255-i*55, 220 )
			-- add more elements to slide
			local txt = display.newText( "  SLIDE "..i, 0, 0, native.systemFontBold, 48 )
			thisSlideGroup:insert( txt )
			txt:setTextColor( 255, 255, 255 )
			txt:setReferencePoint(display.CenterLeftReferencePoint) ; txt.x = 0 ; txt.y = 128

			sliderGroup:insert( thisSlideGroup )
			thisSlideGroup.x = ((sliderGroup.numChildren-1)*slideDist)
		end

		maxSlideIndex = sliderGroup.numChildren-1

		--Configure slide position dots. If using images for the dots (preferable), you should create an image which is designed for the
		--proper resolution in your app. You may also use Corona's "display.newCircle" function, but the dots will not be anti-aliased and
		--thus might appear slightly jagged.
		local pageDots = pageDots
		for i = 1,maxSlideIndex+1 do
			--local dot = display.newCircle( dotGroup, i*40, 0, 6 ) ; dot:setFillColor(255,255,255)
			local dot = display.newImageRect( dotGroup, "dot.png", 12, 12 ) ; dot.x = i*40
			pageDots[#pageDots+1] = dot
		end
		dotGroup:setReferencePoint(display.BottomCenterReferencePoint) ; dotGroup.x = cw*0.5 ; dotGroup.y = ch-50+oy
		updateDots( 0 )

		sliderGroup:addEventListener( "touch", screenMotion )  --core touch listener (only touch listener)
end



---------------------
--Clean-up function
---------------------
--You may use this function to clean up the dots and touch listener, or borrow these code elements to use elsewhere for the same purpose.
--IMPORTANT!!! If you are using Director, you do NOT need to write any further code to clean up the slides. Because each slide is added
--to Director's "localGroup", Director's recursive clean-up function will clean up the elements within each group AND the group itself.
--
--If you are NOT using Director, you might want to copy Director's recursive cleanup function to remove the slides & contents.
function cleanUp()

		sliderGroup:removeEventListener( "touch", screenMotion )
		if ( slideTrans ~= 0 ) then transition.cancel( slideTrans ) end ; slideTrans = nil
		for d=#pageDots,1,-1 do local del = pageDots[d] ; pageDots[d] = nil ; display.remove( del ) ; del = nil end
		pageDots = nil
end



--Call initial setup function
initSetup()


--ACTIVATE THE FOLLOWING FUNCTION IF USING DIRECTOR; REMOVE IF NOT
--function new()
--return localGroup
--end
