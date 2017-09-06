--[[
The MIT License (MIT)

Copyright (c) 2017 Varaljai Peter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local kamera = {}
kamera.kx = 0
kamera.ky = 0
kamera.sx = 1
kamera.sy = 1
kamera.r = 0


-- set,unset
function kamera:set()
    love.graphics.push()
    love.graphics.scale(1/self.sx,1/self.sy)
    love.graphics.translate(love.graphics.getWidth()/(2/self.sx), love.graphics.getHeight()/(2/self.sy))
    love.graphics.rotate(-self.r)
    love.graphics.translate(-self.kx, -self.ky)
end

function kamera:unset()
    love.graphics.pop()
end
 
-- Position

function kamera:rPos(x,y) --relat
    self.kx = self.kx+x
    self.ky = self.ky+y 
end

function kamera:aPos(x, y) --abs
    self.kx = x 
    self.ky = y 
end

function kamera:gPos() --get
    return self.x, self.y
end

-- Zoom

function kamera:rScale(sx,sy) --relat
	self.sx = self.sx+self.sx*sx
	self.sy = self.sy+self.sy*(sy or sx)
end

function kamera:aScale(sx,sy) --abs -- original: 1,1
    self.sx = sx
    self.sy = (sy or sx)
end

function kamera:gScale() --get
    return self.sx,self.sy
end

-- Rotation 

function kamera:rRot(r) --relat
	self.r = self.r+self.r*r
end

function kamera:aRot(r) --abs -- original: 0
    self.r = r
end

function kamera:gRot() --get
    return self.r
end

-- coordsystems

function kamera:camCoords(x,y)
  local c,s = math.cos(-self.r), math.sin(-self.r)
  local x,y = x - self.kx, y - self.ky
  x,y = c*x - s*y, s*x + c*y
  return x*self.sx, y*self.sy
end

function kamera:worldCoords(x,y)
  local c,s = math.cos(self.r), math.sin(self.r)
  local x,y = x*self.sx, y*self.sy
  x,y = c*x - s*y, s*x + c*y
  return x+self.kx, y+self.ky
end

return kamera