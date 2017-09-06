kamera = require('kamera')
quadtree = require('quadtree')

function love.load()
	XX, YY = love.window.getMode()
	k = {x=0,y=0,speed=100}

	quadtree:init(10,1000)

end

function love.update(dt)
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		k.x = k.x + (k.speed*dt)
	end
	if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		k.x = k.x - (k.speed*dt)
	end

	if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
		k.y = k.y + (k.speed*dt)
	end
	if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		k.y = k.y - (k.speed*dt)
	end

	if love.keyboard.isDown("q") then
		quadtree:insert(k.x, k.y, 32, 32, 1)
	end

	if love.keyboard.isDown("e") then
		quadtree:insert(k.x, k.y, 32, 32, 2)
	end

	if love.keyboard.isDown("delete") then
		quadtree:insert(k.x, k.y, 32, 32, 0)
	end


	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end

function love.keypressed(key)
end

function love.draw()
	kamera:aPos(k.x,k.y)
	kamera:set()
		quadtree:debugdraw()
		love.graphics.setColor(255,255,255,255) 
		love.graphics.circle("fill",0,0,10)
	kamera:unset()
		love.graphics.circle("fill",XX/2,YY/2,5)
end