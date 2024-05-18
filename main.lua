local bump       = require 'bump'
local bump_debug = require 'bump_debug'

local my_background = love.graphics.newImage('purpleBlock.png')
local Final_Computer_Room_Backgroud = love.graphics.newImage('RoomFinal.png')
local Final_Ryan_Image = love.graphics.newImage('ryan.jpg')
local Final_Clue = love.graphics.newImage('cluepicture.png')
local Final_Code_1 = love.graphics.newImage('code1.png')
local Final_Code_2 = love.graphics.newImage('code2.png')
local Final_Code_3 = love.graphics.newImage('code3.png')
local Final_LockScreen = love.graphics.newImage('lockscreen.jpg')
local Final_Question_1 = love.graphics.newImage('image.png')
local Final_Question_2 = love.graphics.newImage('image1.png')
local Final_Question_3 = love.graphics.newImage('image3.png')
local Final_Question_4 = love.graphics.newImage('image4.png')
local Final_Question = love.graphics.newImage('finalquestion.png')
local Final_Character = love.graphics.newImage('littleMan.png')
local Final_Character_Reversed = love.graphics.newImage('littleManReversed.png')
local menu = "Computer Lab"

local time_per_letter = .01
local time_passed = 0
local current_letter = 0
local roomNumber = 0 --default is 0
local worldLoaded = false
local characterMessage = "character dialogue: \ncrabs"
local loadRyan = false
local loadCode1 = false
local loadCode2 = false
local loadCode3 = false
local loadClue = false
local solvedPassword = false
local questionLoaded = 1
local isMovingLeft = false

--current password is 2213
local lock1PasscodeAttempt = {0, 0, 0, 0}
local lock1PasscodeSelectedSlot = 1
local isAtLock1Location = false
--passworld is 386
local lock2PasscodeAttempt = {0, 0, 0}
local lock2PasscodeSelectedSlot = 1
local isAtLock2Location = false

local showBorders = false

local shouldDrawSpeechBox = falses
local shouldDrawWorld = false

local cols_len = 0 -- how many collisions are happening

-- World creation
local world = bump.newWorld()

-- helper function
local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,0.001)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  if showBorders == true then
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end
end

--j for player


function love.load()
      love.graphics.setBackgroundColor( 255, 255, 255 )
end


-- Player functions
local player = { x=400,y=200,w=20,h=20, speed = 200 }

local function updatePlayer(dt)
  local speed = player.speed

  if roomNumber ~= 0 then
    local dx, dy = 0, 0
    if love.keyboard.isDown('d') then
    	isMovingLeft = false
      dx = speed * dt
    elseif love.keyboard.isDown('a') then
    	isMovingLeft = true
      dx = -speed * dt
    end
    if love.keyboard.isDown('s') then
      dy = speed * dt
    elseif love.keyboard.isDown('w') then
      dy = -speed * dt
    end

    if dx ~= 0 or dy ~= 0 then
      player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
    end
  end
end

local function drawBoxPlayer(box, r,g,b)
  love.graphics.setColor(r,g,b,0.001)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
  love.graphics.setColor(100,100,100,255)
  if isMovingLeft == true then
  	love.graphics.draw(Final_Character_Reversed, player.x, player.y)
  elseif isMovingLeft == false then
  	love.graphics.draw(Final_Character, player.x, player.y)
  end
end

local function drawPlayer()
  drawBoxPlayer(player, 0, 1, 0)
end	

-- Block functions

local blocks = {}

local function addBlock(x,y,w,h)
  local block = {x=x,y=y,w=w,h=h}
  blocks[#blocks+1] = block
  world:add(block, x,y,w,h)
end

local function drawBlocks()
  for _,block in ipairs(blocks) do
    drawBox(block, 1,0,0)
  end
end

-- Main LÖVE functions

  --this would be room one or Ms.Wangs Room, we can add more in the future.
  local function drawWorld()
  if roomNumber == 1 and worldLoaded == false then
    world:add(player, player.x, player.y, player.w, player.h)
    --world borders
    addBlock(0,       0,     800, 1)
    addBlock(0,      1,      1, 600)
    addBlock(800, 1,      1, 600)
    addBlock(0,      600, 800, 1)

    --all the object borders. 
    --P.S. This took so freaking long, appx 1.5 hr
    addBlock(0,      0, 222, 113)
    addBlock(271,      0, 285, 87)
    addBlock(595,      0, 205, 110)
    addBlock(340,      125, 160, 50)
    addBlock(560,      195, 40, 55)
    addBlock(615,      150, 180, 30)
    addBlock(650,      190, 115, 40)
    addBlock(760,      195, 45, 155)
    addBlock(575,      400, 170, 60)
    addBlock(745,      400, 55, 140)
    addBlock(375,      405, 110, 65)
    addBlock(0,      115, 60, 385)
    addBlock(60,      345, 100, 115)
    addBlock(90,      288, 75, 50)
    addBlock(338,      280, 35, 50)
    addBlock(400,      305, 120, 35)
    addBlock(0, 530, 140, 70)
    addBlock(695, 530, 105, 70)

   
    worldLoaded = true
    shouldDrawWorld = true
  end
end

local function charInteract()
  if player.x >= 222 and player.y >= 1 and player.x <= 251 and player.y <= 65 then
    shouldDrawSpeechBox = true
  end
  if player.x >= 540 and player.y >= 175 and player.x <= 600 and player.y <= 250 then
    loadRyan = true
  end
  if player.x >= 710 and player.y >= 230 and player.x <= 740 and player.y <= 230 then
    loadCode1 = true
  end
  if player.x >= 318 and player.y >= 258 and player.x <= 372 and player.y <= 330 then
    loadCode2 = true
  end
  if player.x >= 60 and player.y >= 460 and player.x <= 60 and player.y <= 500 then
    loadCode3 = true
  end
  if player.x >= 760 and player.y >= 350 and player.x <= 780 and player.y <= 350 then
    loadClue = true
  end
  if player.x >= 370 and player.y >= 470 and player.x <= 465 and player.y <= 470 then
    shouldDrawSpeechBox2 = true
  end
end

local function drawUpdate(dt)
  if player.x < 222 or player.y < 1 or player.x > 251 or player.y > 65 then
    shouldDrawSpeechBox = false
  end
  if player.x < 370 or player.y < 470 or player.x > 465 or player.y > 470 then
    shouldDrawSpeechBox2 = false
  end
  if player.x < 540 or player.y < 175 or player.x > 600 or player.y > 250 then
    loadRyan = false
  end
  if player.x < 710 or player.y < 230 or player.x > 740 or player.y > 230 then
    loadCode1 = false
  end
  if player.x < 318 or player.y < 258 or player.x > 372 or player.y > 330 then
    loadCode2 = false
  end
  if player.x < 60 or player.y < 460 or player.x > 60 or player.y > 500 then
    loadCode3 = false
  end
  if player.x < 760 or player.y < 350 or player.x > 780 or player.y > 350 then
    loadClue = false
  end
end

local function drawSpeechBox()
  if roomNumber == 1 then
   love.graphics.rectangle('fill', 0, 600-96, 800, 96)
   love.graphics.setColor(0,0,0,255)
   local chars1 = "Insert Final Password: slot: " .. lock1PasscodeSelectedSlot .. " slot1val: " .. lock1PasscodeAttempt[1] .. " slot2val: " .. lock1PasscodeAttempt[2] .. " slot3val: " .. lock1PasscodeAttempt[3] .. " slot4val: " .. lock1PasscodeAttempt[4]
   love.graphics.print(chars1, 50, 600-96, 0, 1, 1, 0, 0, 0, 0)
  end
end

local function drawSpeechBox2()
  if roomNumber == 1 then
   love.graphics.rectangle('fill', 0, 600-96, 800, 96)
   love.graphics.setColor(0,0,0,255)
   local chars1 = "Insert Computer Password: slot: " .. lock2PasscodeSelectedSlot .. " slot1val: " .. lock2PasscodeAttempt[1] .. " slot2val: " .. lock2PasscodeAttempt[2] .. " slot3val: " .. lock2PasscodeAttempt[3]
   love.graphics.print(chars1, 50, 600-96, 0, 1, 1, 0, 0, 0, 0)
  end
end

local function drawPlayerLoc()
   love.graphics.rectangle('fill', 0, 600-96, 800, 96)
   love.graphics.setColor(0,0,0,255)
   local chars1 = "player x: " .. player.x .. " player y: " .. player.y
   love.graphics.print(chars1, 50, 600-96, 0, 1, 1, 0, 0, 0, 0)
end

local function checkPassword1()
  if lock1PasscodeAttempt[1] == 2 and lock1PasscodeAttempt[2] == 2 and lock1PasscodeAttempt[3] == 1 and lock1PasscodeAttempt[4] == 3 then
    love.event.quit()
  end
end

local function checkPassword2()
  if lock2PasscodeAttempt[1] == 3 and lock2PasscodeAttempt[2] == 8 and lock2PasscodeAttempt[3] == 6 then
    solvedPassword = true
  end
end

local function drawRyan()
  love.graphics.draw(Final_Ryan_Image, 100, 100)
end

local function drawClue()
  love.graphics.draw(Final_Clue, 100, 100)
end
local function drawCode1()
  love.graphics.draw(Final_Code_1, 100, 100)
end
local function drawCode2()
  love.graphics.draw(Final_Code_2, 100, 100)
end
local function drawCode3()
  love.graphics.draw(Final_Code_3, 100, 100)
end
local function drawLockScreen()
  love.graphics.draw(Final_LockScreen, 100, 100)
end
local function drawQuestions()
	if questionLoaded == 1 then
	love.graphics.draw(Final_Question_1, 100, 100)
	elseif questionLoaded == 2 then	
	love.graphics.draw(Final_Question_2, 100, 100)
	elseif questionLoaded == 3 then
	love.graphics.draw(Final_Question_3, 100, 100)
	elseif questionLoaded == 4 then
	love.graphics.draw(Final_Question_4, 100, 100)
	end
end

function love.update(dt)
  cols_len = 0
  updatePlayer(dt)
  drawUpdate(dt)
  checkPassword1()
  checkPassword2()
end

function love.draw()
love.graphics.setColor(100,100,100,255)
  love.graphics.draw(my_background)
  if shouldDrawWorld then
  	love.graphics.setColor(100,100,100,255)
  	love.graphics.draw(Final_Computer_Room_Backgroud)
    if shouldDrawSpeechBox == true then
      drawSpeechBox()
    end
    if loadRyan == true then
    drawRyan()
  end
  if loadClue == true then
    drawClue()
  end
  if loadCode1 == true then
    drawCode1()
  end
  if loadCode2 == true then
    drawCode2()
  end
  if loadCode3 == true then
    drawCode3()
  end
  if shouldDrawSpeechBox2 == true and solvedPassword == false then
  	drawLockScreen()
  	drawSpeechBox2()
  end
  if solvedPassword == true and shouldDrawSpeechBox2 then
  	drawQuestions()
  end
    if showBorders == true then
      drawPlayerLoc()
    end
    drawBlocks()
    drawPlayer()  
  end
end

-- Non-player keypresses
function love.keypressed(k)
  if k=="escape" then love.event.quit() end
  if k=="delete" then collectgarbage("collect") end
  if k=="e" then
    -- current_letter = 0
    charInteract() end
  if k=="1" then
    roomNumber = 1
    drawWorld()
  end
  if k=="c" then
  	showBorders = false
  end
  if k=="v" then
  	showBorders = true
  end
  if k=="right" then
  	if shouldDrawSpeechBox == true then
    if 1 + lock1PasscodeSelectedSlot > 4 then
      lock1PasscodeSelectedSlot = 1
    else 
      lock1PasscodeSelectedSlot = 1 + lock1PasscodeSelectedSlot
    end
	end
	if shouldDrawSpeechBox2 == true then
    if 1 + lock2PasscodeSelectedSlot > 3 then
      lock2PasscodeSelectedSlot = 1
    else 
      lock2PasscodeSelectedSlot = 1 + lock2PasscodeSelectedSlot
    end
	end
	if solvedPassword == true and shouldDrawSpeechBox2 == true then
		if 1 + questionLoaded > 4 then
			questionLoaded = 1
		else
			questionLoaded = questionLoaded + 1
		end
	end
  end
  if k=="left" then
  	if shouldDrawSpeechBox == true then
    if lock1PasscodeSelectedSlot - 1 < 1 then
      lock1PasscodeSelectedSlot = 4
    else 
      lock1PasscodeSelectedSlot = lock1PasscodeSelectedSlot - 1
    end
	end
	if shouldDrawSpeechBox2 == true then
    if lock2PasscodeSelectedSlot - 1 < 1 then
      lock2PasscodeSelectedSlot = 3
    else 
      lock2PasscodeSelectedSlot = lock2PasscodeSelectedSlot - 1
    end
	end
	if solvedPassword == true and shouldDrawSpeechBox2 == true then
		if  questionLoaded - 1 < 1 then
			questionLoaded = 4
		else
			questionLoaded = questionLoaded - 1
		end
	end
  end

  if k=="down" then
  	if shouldDrawSpeechBox == true then
    if lock1PasscodeAttempt[lock1PasscodeSelectedSlot] < 1 then
      lock1PasscodeAttempt[lock1PasscodeSelectedSlot] = 5
    else 
      lock1PasscodeAttempt[lock1PasscodeSelectedSlot] = lock1PasscodeAttempt[lock1PasscodeSelectedSlot] -1
    end
	end
	if shouldDrawSpeechBox2 == true then
    if lock2PasscodeAttempt[lock2PasscodeSelectedSlot] < 1 then
      lock2PasscodeAttempt[lock2PasscodeSelectedSlot] = 9
    else 
      lock2PasscodeAttempt[lock2PasscodeSelectedSlot] = lock2PasscodeAttempt[lock2PasscodeSelectedSlot] -1
    end
	end
  end
  if k=="up" then
  	if shouldDrawSpeechBox == true then
    if lock1PasscodeAttempt[lock1PasscodeSelectedSlot] > 4 then
      lock1PasscodeAttempt[lock1PasscodeSelectedSlot] = 1
    else 
      lock1PasscodeAttempt[lock1PasscodeSelectedSlot] = lock1PasscodeAttempt[lock1PasscodeSelectedSlot] + 1
    end
	end
	if shouldDrawSpeechBox2 == true then
    if lock2PasscodeAttempt[lock2PasscodeSelectedSlot] > 8 then
      lock2PasscodeAttempt[lock2PasscodeSelectedSlot] = 1
    else 
      lock2PasscodeAttempt[lock2PasscodeSelectedSlot] = lock2PasscodeAttempt[lock2PasscodeSelectedSlot] + 1
    end
	end
  end
end

