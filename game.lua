-- Physics Demo: Radial Gravity | Version: 1.0
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
local composer = require( "composer" )
  local screenW, screenH = display.contentWidth, display.contentHeight 
  local scene = composer.newScene()
  
  function scene:create( event )
  
 
  
  local sceneGroup = self.view
  
  
local physics = require("physics") ; physics.start() ; physics.setGravity( 0,0 ) ; physics.setDrawMode( "normal" )
display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

--set up some references and other variables
local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
local cw, ch = display.contentWidth, display.contentHeight


--set up collision filters
local screenFilter = { categoryBits=1, maskBits=1 }
local objFilter = { categoryBits=1, maskBits=14 }
local fieldFilter = { categoryBits=4, maskBits=1 }
local magnetFilter = { categoryBits=5, maskBits=1}

  
  local timeT
  local time = 60
  local scoreT
  local score = 0 


  media.playSound("sons/musicfast.ogg", true);
  
  system.activate("multitouch")
  
  local musicafast = audio.loadSound("sons/explosion.wav");
  
  local botaofast = audio.loadSound("sons/impact.wav");
  
  local astromusic = audio.loadSound ("sons/astro.ogg")


--set initial magnet pull
local magnetPull = 0.50

--set up world and background
back = display.newImageRect( "ceu1.jpg", 1024, 768 ) ; back.x = cw/2 ; back.y = ch/2 ; back:scale( 1.4,1.4 )
--back = display.newImageRect( "estrelas.png", 1024, 768 ) ; back.x = cw/2 ; back.y = ch/2 ; back:scale( 1.4,1.4 )
local jupter = display.newImage("luax.png");jupter.x = 100 jupter.y = 200 

background1 = display.newImage("asteroids.png")
background1.x = 10
background1.y = 500

background2 = display.newImage("asteroids.png")
background2.x = 10000
background2.y = 500


function scrollCity(self)
	if self.x < -1500 then
		self.x = 1500
	else 
		self.x = self.x - 3
	end
	
end

background1.enterFrame = scrollCity
Runtime:addEventListener("enterFrame", background1)
	
background2.enterFrame = scrollCity
Runtime:addEventListener("enterFrame", background2)


local screenBounds = display.newRect( -ox, -oy, display.contentWidth+ox+ox, display.contentHeight+oy+oy )
screenBounds.name = "screenBounds"
screenBounds.isVisible = false ; physics.addBody( screenBounds, "static", { isSensor=true, filter=screenFilter } )



local function newPositionVelocity( object )

	local math_random = math.random
	local side = math_random( 1,10) ; local posX ; local posY ; local velX ; local velY

	if ( side == 1 or side == 9 ) then
		posX = math_random(1,display.pixelHeight)
		velX = math_random( -10,10) * 3
		if ( side == 10 ) then posY = -oy-10; velY = math_random( 8,18 ) * 16
		else posY = display.contentHeight+oy+10 ; velY = math_random( 8,16 ) * -16
		end
	else
		posY = math_random(1,display.pixelWidth)
		velY = math_random( -10,10) * 3
		if ( side == 9) then posX = -ox-10; velX = math_random( 8,16 ) * 16
		else posX = display.contentWidth+ox+10 ; velX = math_random( 8,16 ) * -16
		end
	end
	object.x = posX ; object.y = posY
	object:setLinearVelocity( velX, velY )
	object.angularVelocity = math_random( -3,3 ) * 180
	object.alpha = 5

end



local function objectCollide( self, event )



	local otherName = event.other.name
	
	local function onDelay( event )
	

		local action = ""
		if ( event.source ) then action = event.source.action ; timer.cancel( event.source ) end
		
		if ( action == "makeJoint" ) then
			self.hasJoint = true
			self.touchJoint = physics.newJoint( "touch", self, self.x, self.y )
			self.touchJoint.frequency = magnetPull
			self.touchJoint.dampingRatio = 0.9
			self.touchJoint:setTarget( 512, 384 )
	
	
	
			
		elseif ( action == "leftField" ) then
			self.hasJoint = false ; self.touchJoint:removeSelf() ; self.touchJoint = nil
			
		else
			if ( self.hasJoint == true ) then self.hasJoint = false ; self.touchJoint:removeSelf() ; self.touchJoint = nil end
			newPositionVelocity( self )
			-----
			audio.play(musicafast)
			updateScore()
			--time = time -10
			--local esplosao = display.newImage("magnet.png",70,70)
			--esplosao.x = display.contentCenterX ; esplosao.y = display.contentCenterY
	
		end
	end

	if ( event.phase == "ended" and otherName == "screenBounds" ) then
		local tr = timer.performWithDelay( 10, onDelay ) ; tr.action = "leftScreen"
		
		
	elseif ( event.phase == "began" and otherName == "magnet" ) then
		transition.to( self, { time=10, alpha=0, onComplete=onDelay } )
		
	elseif ( event.phase == "began" and otherName == "field" and self.hasJoint == false ) then
		local tr = timer.performWithDelay(10, onDelay ) ; tr.action = "makeJoint"
		
		
	elseif ( event.phase == "ended" and otherName == "field" and self.hasJoint == true ) then
		local tr = timer.performWithDelay( 10, onDelay ) ; tr.action = "leftField"
		
	end
		
	

end


local function setupWorld()


	for i=1,5 do
	
		local obj = display.newImageRect( "meteorito.png", 150, 150 )
		physics.addBody( obj, { bounce=0, radius=50, filter=objFilter } )
		newPositionVelocity( obj )
		obj.hasJoint = false
		obj.collision = objectCollide ; obj:addEventListener( "collision", obj )
		
	end

	local field = display.newImageRect( "field.png", 300,300 ) ; field.alpha = 0.03
	field.name = "field"
	field.x = display.contentCenterX ; field.y = display.contentCenterY
	physics.addBody( field, "static", { isSensor=true, radius= 120, filter=fieldFilter } )
	
	local magnet = display.newImageRect( "foguet.png",90,60)
	magnet.name = "magnet"
	magnet.x = display.contentCenterX ; magnet.y = display.contentCenterY
	physics.addBody( magnet, "static", { bounce=0, radius=50, filter=magnetFilter } )
	
	
end	
local function meteorito()

	for i=1,2 do
		local obj = display.newImageRect( "meteorito.png", 130, 130 )
		physics.addBody( obj, { bounce=0, radius=30, filter=objFilter } )
		newPositionVelocity( obj )
		obj.hasJoint = false
		obj.collision = objectCollide ; obj:addEventListener( "collision", obj )
	end
end

setupWorld()
meteorito()
--Runtime: addEventListener("touch",meteorito)

  function updateTime()
  
      time = time - 0.01
      timeT.text = time
		if time <= 0 then
			print "perdeu"
			composer.removeHidden()
			composer.gotoScene( "menu")
		end
	
	  
  end
  
 


   timeT = display.newText('0',500,20,system.nativeFont,30)
        timeT:setTextColor(0,2,0)
	
		
   scoreT = display.newText('0',1000,20,system.nativeFont,30)
        scoreT:setTextColor(0,2,0)     



  function updateScore()
    score = score + 10
    scoreT.text = score
    
  end
    
  
  
  tiro = display.newImage( "buttonblue.png" )
  tiro.id = "butonblue tiro"

  tiro.height = 175
  tiro.width = 175
  tiro.x = -110 
  tiro.y = 715

  local function onTiroTouch( event )
      if ( event.phase == "began") then
  	
	audio.play(musicafast)
          
     updateScore()
	 magnetPull = 10
	

      end
      return true
	
  end
 
  
  tp = display.newImage( "butontp.png" )
  tp.id = "butontp tp"
  

  tp.height = 120
  tp.width = 120
  tp.x = 30 
  tp.y = 715

  local function onTempoTouch( event )
      if ( event.phase == "began") then
  	audio.play(astromusic)
          
		  
      time = time - 5
	 meteorito()

      end
      return true
  end
  
  
  
tiro:addEventListener( "touch", onTiroTouch )
 

 tp:addEventListener( "touch", onTempoTouch )
 --Runtime: addEventListener("enterFrame",tp)
 --timer.performWithDelay(8000,onTempoTouch) 
  
  Runtime: addEventListener("enterFrame",updateTime) --- funcao tempo decre..
  
  end
  
  -- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view
	--  Runtime: removeEventListener("enterFrame",updateTime)
	 -- Runtime:removeEventListener("enterFrame", background1)
	 -- Runtime:removeEventListener("enterFrame", background2)
	 -- tiro:removeEventListener( "touch", onTiroTouch )
	 --  tp:removeEventListener( "touch", onTempoTouch )
	 --  tp=nil
	 --  tp.removeSelf()
	 --  tiro=nil
	 --  tiro.removeSelf()
	 --  background1.removeSelf()
	  -- background2.removeSelf()
	  -- back.removeSelf()
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
  
  
 