-- https://github.com/Ulydev/push
	push = require 'push'

	screen_width = 1280 --1280
	screen_height = 720 --720

	vWindow_width = 1280
	vWindow_height = 720

	player_speed = 200


function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')


	math.randomseed(os.time())

	-- smallFont = love.graphics.newFont('font.ttf', 8)

	-- scoreForce = love.graphics.newFont('font.tff', 32)

	-- love.graphics.setFont(smallFont)

	push:setupScreen(vWindow_width, vWindow_height, vWindow_width, vWindow_height, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

	playerXPos = 100
	playerYPos = 100

    my_background = love.graphics.newImage('img_hero_header_background.jpg')

	love.window.setTitle("School Game!")
	love.window.setMode(screen_width, screen_height)
end

function love.update(dt)
	if love.keyboard.isDown('w') then
		playerYPos = math.max(0, playerYPos + -player_speed * dt)
	elseif love.keyboard.isDown('s') then
		playerYPos = math.min(vWindow_height - 15, playerYPos + player_speed * dt)
	end

	if love.keyboard.isDown('a') then
		playerXPos = math.max(0, playerXPos + -player_speed * dt)
	elseif love.keyboard.isDown('d') then
		playerXPos = math.min(vWindow_width - 5, playerXPos + player_speed * dt)
	end
end


function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.draw()

	love.graphics.setColor(1,1,1,1)

	love.graphics.draw(my_background)


	push:apply('start')

	-- love.graphics.clear(40/255,45/255,52/255,255/255)

	if gameState == 'start' then
		love.graphics.printf('Start State', 0, 20, vWindow_width, 'center')
	else
		love.graphics.printf('Play State', 0, 20, vWindow_width, 'center')
	end

	love.graphics.rectangle('fill', playerXPos, playerYPos, 5, 15)

	push:apply('end')
end
