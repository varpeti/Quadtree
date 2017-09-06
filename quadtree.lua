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

local quadtree = {}

function quadtree:init(unit,chunk,x,y)
    self.unit = (unit or 10)^2
    self.chunk = chunk or 1000
    self.root = node.new(x or -chunk/2, y or -chunk/2, chunk, chunk, 0, nil)
end

function quadtree:insert(x, y, width, height, type)
    self.root:modifyNode(x-width/2, y-height/2, width, height, type)
end

function quadtree:debugdraw()
    counter = 0
    self.root:debugdraw()
    love.graphics.print(counter,-50,-50)
end

---------------------NODE----------------------
    
node = {}
node.mt = {}
node.mt.__index = function(table, key)
    return node.prototype[key]
end

function node.new(x, y, width, height, type, parent)
    local new_node = {}
    setmetatable(new_node,node.mt)
    new_node.x = x
    new_node.y = y
    new_node.width = width
    new_node.height = height
    new_node.type = type
    new_node.parent = parent
    new_node.area = width * height
    new_node.isLeaf = true
    new_node.quadrant = {}
    return new_node
end

node.prototype = {}

function node.prototype:modifyNode(x, y, width, height, type)
    if (self:isFullyContained(x, y, width, height)) then
        self.type = type
        self.isLeaf = true
        return
    elseif (self:isFullyOutside(x, y, width, height)) then
        return
    else
        if (self.area <= quadtree.unit) then return end
        if (self.isLeaf) then
            self:split()
        end
        self:modifyChildNodes(x, y, width, height, type)
    end
end

function node.prototype:isFullyContained(x, y, width, height) 
    return (x <= self.x and 
            x + width >= self.x + self.width and
            y <= self.y and
            y + height >= self.y + self.height)
end

function node.prototype:isFullyOutside(x, y, width, height)
    return (self.x + self.width <= x or
            self.y + self.height <= y or
            x + width <= self.x or
            y + height <= self.y)
end

function node.prototype:split()
    self.isLeaf = false
    local childWidth = self.width/2
    local childHeight = self.height/2
    self.quadrant[1] = node.new(self.x,                 self.y,                 childWidth, childHeight, self.type, self)
    self.quadrant[2] = node.new(self.x + childWidth,    self.y,                 childWidth, childHeight, self.type, self)
    self.quadrant[3] = node.new(self.x,                 self.y + childHeight,   childWidth, childHeight, self.type, self)
    self.quadrant[4] = node.new(self.x + childWidth,    self.y + childHeight,   childWidth, childHeight, self.type, self)
end

function node.prototype:modifyChildNodes(x, y, width, height, type)
    for i = 1,4 do
        self.quadrant[i]:modifyNode(x, y, width, height, type)
    end
    local sameType = true
    for i = 2,4 do
        if (not self.quadrant[i].isLeaf 
            or not self.quadrant[i-1].isLeaf
            or self.quadrant[i].type ~= self.quadrant[i-1].type) 
        then
            sameType = false
            break
        end
    end
    if sameType then
        self:mergeQuadrants()
    end
end

function node.prototype:mergeQuadrants()
    self.type = self.quadrant[1].type
    self.quadrant = {}
    self.isLeaf = true
end

----debugdraw----

function node.prototype:debugdraw() 
    if self.isLeaf then
        self:drawSelf()
    else
        for i = 1,4 do
            self.quadrant[i]:debugdraw()
        end
    end
end

function node.prototype:drawSelf()
    counter = counter+1
    if self.type==0 then 
        love.graphics.setColor(0,0,0,255) 
    elseif self.type==1 then 
        love.graphics.setColor(0,255,0,255)
    elseif self.type==2 then 
        love.graphics.setColor(255,0,255,255) 
    end 
    love.graphics.rectangle('fill',self.x, self.y, self.width, self.height)
    love.graphics.setColor(255,255,255,255) 
    love.graphics.rectangle('line',self.x, self.y, self.width, self.height) 
    
end

return quadtree