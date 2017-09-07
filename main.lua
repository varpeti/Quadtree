kamera = require('kamera')
quadtree = require('quadtree')

DEBUG = true

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
		counter = 0
		quadtree:draw(quadraw)
		love.graphics.setColor(255,255,255,255) 
		love.graphics.print(counter,0,0)
	kamera:unset()
		love.graphics.circle("fill",XX/2,YY/2,5)
end

function quadraw(obj)
	counter=counter+1
	if obj.type==0 then if DEBUG then love.graphics.setColor(0,0,0,255) else return end
	elseif obj.type==1 then love.graphics.setColor(0,255,0,255)
	elseif obj.type==2 then love.graphics.setColor(255,0,0,255)
	end
	love.graphics.rectangle("fill",obj.x,obj.y,obj.width,obj.heigth)
	if DEBUG then
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("line",obj.x,obj.y,obj.width,obj.heigth)
	end
end