local bump       = require 'bump'
local bump_debug = require 'bump_debug'

local my_background = love.graphics.newImage('purpleBlock.png')
local Final_Computer_Room_Backgroud = love.graphics.newImage('RoomFinal.png')
local menu = "Computer Lab"

local time_per_letter = .01
local time_passed = 0
local current_letter = 0
local roomNumber = 0 --default is 0
local worldLoaded = false
local characterMessage = "character dialogue: \ncrabs"

local showBorders = false

local shouldDrawSpeechBox = false
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
local function drawBoxPlayer(box, r,g,b)
  love.graphics.setColor(r,g,b,0.001)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

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
      dx = speed * dt
    elseif love.keyboard.isDown('a') then
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
  if player.x < 100 and player.y < 100 then
    shouldDrawSpeechBox = true
    -- love.event.quit()
  end
end

local function speechUpdate(dt)
  if player.x > 100 or player.y
    > 100 then
    shouldDrawSpeechBox = false
  else
    time_passed = time_passed + dt
    if time_passed >= time_per_letter then
      time_passed = 0
      current_letter = current_letter + 1
    end
  end
end

local function drawSpeechBox()
  if roomNumber == 1 then
    love.graphics.draw(love.graphics.newImage("larry.jpg"), 100, 100)
   love.graphics.rectangle('fill', 0, 600-96, 800, 96)
   love.graphics.setColor(0,0,0,255)
   local chars = characterMessage:sub(1, current_letter)
   love.graphics.print(chars, 50, 600-96, 0, 1, 1, 0, 0, 0, 0)
  end
end

local function drawPlayerLoc()
   love.graphics.rectangle('fill', 0, 600-96, 800, 96)
   love.graphics.setColor(0,0,0,255)
   local chars1 = "player x: " .. player.x .. " player y: " .. player.y
   love.graphics.print(chars1, 50, 600-96, 0, 1, 1, 0, 0, 0, 0)
end

function love.update(dt)
  cols_len = 0
  updatePlayer(dt)
  speechUpdate(dt)
end

function love.draw()
love.graphics.setColor(100,100,100,255)
  love.graphics.draw(my_background)
  if shouldDrawSpeechBox then
    drawSpeechBox()
  end
  if shouldDrawWorld then
  	love.graphics.setColor(100,100,100,255)
  	love.graphics.draw(Final_Computer_Room_Backgroud)
    if showBorders == true then
      drawPlayerLoc()
    end
  end
  drawBlocks()
  drawPlayer()
end

-- Non-player keypresses
function love.keypressed(k)
  if k=="escape" then love.event.quit() end
  if k=="delete" then collectgarbage("collect") end
  if k=="e" then
    current_letter = 0
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
end

