-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require("physics")
physics.start()

media.playSound("sunset-riders-bonus-stage.mid", true);

local relincho = audio.loadSound("relincho.wav");



-->add imagem de fundo
local  fundo = display.newImage("light1.jpg")
fundo.height = 700
fundo.width = 700
fundo.x = display.contentWidth /2
fundo.y = display.contentHeight /2

-->add botao voltar
local botaoVoltar = display.newImage("buttonblue.png",true)
botaoVoltar.height = 75  
botaoVoltar.width = 75
botaoVoltar.x = 25
botaoVoltar.y = 0

-->add botao pausar
local botaoPause = display.newImage("buttonblue.png",true)
botaoPause.height = 75
botaoPause.width = 75
botaoPause.x = 70
botaoPause.y = 0
--system.activate("multitouch")



local botao = {}


-->add botao na posicao1
botao[1] = display.newImage("botao2.png")
botao[1].height = 100
botao[1].width = 100
botao[1].x = 60
botao[1].y = 200
botao[1].ligado = 0
-->add botao na posicao2
botao[2] = display.newImage("botao2.png",true)
botao[2].height = 100
botao[2].width = 100
botao[2].x = 160
botao[2].y = 200
botao[2].ligado = 0
-->add botao na posicao3
botao[3] = display.newImage("botao2.png",true)
botao[3].height = 100
botao[3].width = 100
botao[3].x = 260
botao[3].y = 200
botao[3].ligado = 0
-->add botao na posicao4
botao[4] = display.newImage("botao2.png",true)
botao[4].height = 100
botao[4].width = 100
botao[4].x = 60
botao[4].y = 300
botao[4].ligado = 0
-->add botao na posicao5
botao[5] = display.newImage("botao2.png",true)
botao[5].height = 100
botao[5].width = 100
botao[5].x = 160
botao[5].y = 300
botao[5].ligado = 0
-->add botao na posicao6
botao[6] = display.newImage("botao2.png",true)
botao[6].height = 100
botao[6].width = 100
botao[6].x = 260
botao[6].y = 300
botao[6].ligado = 0
-->add botao na posicao7
botao[7] = display.newImage("botao2.png",true)
botao[7].height = 100
botao[7].width = 100
botao[7].x = 60
botao[7].y = 400
botao[7].ligado = 0
-->add botao na posicao8
botao[8] = display.newImage("botao2.png",true)
botao[8].height = 100
botao[8].width = 100
botao[8].x = 160
botao[8].y = 400
botao[8].ligado = 0
-->add botao na posicao9
botao[9] = display.newImage("botao2.png",true)
botao[9].height = 100
botao[9].width = 100
botao[9].x = 260
botao[9].y = 400
botao[9].ligado = 0


function acenderBotao(event)

posicao = math.random(1, 9)

altura = botao[posicao].height
largura = botao[posicao].width
x = botao[posicao].x
y = botao[posicao].y

botao[posicao] = display.newImage("botao1.png")
botao[posicao].height = altura
botao[posicao].width = largura
botao[posicao].x = x
botao[posicao].y = y
botao[posicao].ligado = 1



timer.performWithDelay(1200, acenderBotao )




end


function apagarBotao(event)

posicao = math.random(1, 9)

altura = botao[posicao].height
largura = botao[posicao].width
x = botao[posicao].x
y = botao[posicao].y


botao[posicao] = display.newImage("botao2.png")
botao[posicao].height = altura
botao[posicao].width = largura
botao[posicao].x = x
botao[posicao].y = y
botao[posicao].ligado = 0


timer.performWithDelay(1000, apagarBotaoBotao )

end



local function onBotaoTouch (event)



if ( event.phase == "began") then
  
  if (botao[posicao].ligado == 1) then
     imagempontok = display.newImage("buttonblue.png")
     imagempontok.height = 75
     imagempontok.width = 75
     imagempontok.x = 105
     imagempontok.y = 250
	 
	 
end


end
   return true

end
 


local object = display.newImage( "buton.png" )
object.id = "buton object"

object.height = 75
object.width = 75
object.x = 165 
object.y = 480

local function onObjectTouch( event )
    if ( event.phase == "began" ) then
	audio.play(relincho)
        
imagempontow = display.newImage("wait.png")
imagempontow.height = 55
imagempontow.width = 80
imagempontow.x = 160 
imagempontow.y = 10



    elseif ( event.phase == "ended" ) then
        

imagempontoz = display.newImage("wait.png")
imagempontoz.height = 55
imagempontoz.width = 100
imagempontoz.x = 750
imagempontoz.y = 100



    end
    return true
end

--botao.touch = onBotaoTouch
--botao: addEventListener ("touch", botao)
--Runtime: addEventListener("enterFrame",botao)

object:addEventListener( "touch", onObjectTouch )
Runtime: addEventListener("enterFrame",object) 

botao.enterFrame = acenderBotao
Runtime:addEventListener("enterFrame", botao)
timer.performWithDelay(1200,acenderBotao )


botao.enterFrame = apagarBotao
Runtime:addEventListener("enterFrame", botao)
timer.performWithDelay(900,apagarBotao)
	

--local object = display.newImage( "ball.png" )
--object.id = "ball object"

--local function onObjectTouch( self, event )
  --  if ( event.phase == "began" ) then
    --    print( "Touch event began on: " .. self.id )
    --end
    --return true
--end 

--object.touch = onObjectTouch
--object:addEventListener( "touch", object )


--local object = display.newImage( "ball.png" )
--object.id = "ball object"

--function object:touch( event )
--    if ( event.phase == "began" ) then
  --      print( "Touch event began on: " .. self.id )
    --end
    --return true
--end 
--object:addEventListener( "touch", object )