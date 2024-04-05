local bump       = require 'bump'
local bump_debug = require 'bump_debug'

local my_background = love.graphics.newImage('img_hero_header_background.jpg')


if love.getVersion == nil or love.getVersion() < 11 then
  local origSetColor = love.graphics.setColor
  love.graphics.setColor = function (r, g, b, a)
    return origSetColor(
      math.floor(r * 256),
      math.floor(g * 256),
      math.floor(b * 256),
      a ~= nil and math.floor(a * 256) or nil
    )
  end
end

local instructions = [[
    bump.lua simple demo

    arrows: move
    tab: toggle debug info
    delete: run garbage collector
]]

local cols_len = 0 -- how many collisions are happening

-- World creation
local world = bump.newWorld()


-- Message/debug functions
local function drawMessage()
  local msg = instructions:format(tostring(shouldDrawDebug))
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(msg, 550, 10)
end

local function drawDebug()
  bump_debug.draw(world)

  local statistics = ("fps: %d, mem: %dKB, collisions: %d, items: %d"):format(love.timer.getFPS(), collectgarbage("count"), cols_len, world:countItems())
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(statistics, 0, 580, 790, 'right')
end

local consoleBuffer = {}
local consoleBufferSize = 15
for i=1,consoleBufferSize do consoleBuffer[i] = "" end
local function consolePrint(msg)
  table.remove(consoleBuffer,1)
  consoleBuffer[consoleBufferSize] = msg
end

local function drawConsole()
  local str = table.concat(consoleBuffer, "\n")
  for i=1,consoleBufferSize do
    love.graphics.setColor(1,1,1, i/consoleBufferSize)
    love.graphics.printf(consoleBuffer[i], 10, 580-(consoleBufferSize - i)*12, 790, "left")
  end
end

-- helper function
local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,0.25)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end



-- Player functions
local player = { x=50,y=50,w=20,h=20, speed = 200 }

local function updatePlayer(dt)
  local speed = player.speed

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
    local cols
    player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
    for i=1, cols_len do
      local col = cols[i]
      consolePrint(("col.other = %s, col.type = %s, col.normal = %d,%d"):format(col.other, col.type, col.normal.x, col.normal.y))
    end
  end
end

local function drawPlayer()
  drawBox(player, 0, 1, 0)
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

--TODO: figure out which two are colliding so you can add a key to interact
local function checkCharacterCollsion()
	if cols_len == 1 then
		consolePrint(("char clossion"))
	end
end




-- Main LÖVE functions

function love.load()

math.randomseed(os.time())

  world:add(player, player.x, player.y, player.w, player.h)

  --world barriers
  addBlock(0,       0,     800, 32)
  addBlock(0,      32,      32, 600-32*2)
  addBlock(800-32, 32,      32, 600-32*2)
  addBlock(0,      600-32, 800, 32)

  addBlock(100, 100, 50, 50)

end

local function charInteract()
	if 0 < player.x and player.x < 100 and 0 < player.y and player.y < 100 then
		love.event.quit()
	end
end

function love.update(dt)
  checkCharacterCollsion()
  cols_len = 0
  updatePlayer(dt)
end

function love.draw()
  love.graphics.draw(my_background)
  drawBlocks()
  drawPlayer()
  if shouldDrawDebug then
    drawDebug()
    drawConsole()
  end
  drawMessage()
end

-- Non-player keypresses
function love.keypressed(k)
  if k=="escape" then love.event.quit() end
  if k=="tab"    then shouldDrawDebug = not shouldDrawDebug end
  if k=="delete" then collectgarbage("collect") end
  if k=="return" then charInteract() end
end
