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

-- unit a legkisebb cella mérete
-- chunk a legnagyobb cella mérete
quadtree.unit = 10^2
quadtree.chunk = 1000
function quadtree:init(unit,chunk,x,y)
    self.unit = (unit or 10)^2
    self.chunk = chunk or 1000
    self.root = node.new(x or -chunk/2, y or -chunk/2, chunk, chunk, 0, nil)
end

-- x,y koordináták közepére helyezi a megadott naygságó téglalapot.
function quadtree:insert(x, y, width, height, type)
    self.root:modifyNode(x-width/2, y-height/2, width, height, type or 0)
end

---------------------NODE----------------------

-- Class node
node = {}
node.mt = {}
node.mt.__index = function(table, key)
    return node.prototype[key]
end

-- constructor 
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

-- prototype függvények 
node.prototype = {}

-- módosítja egy tartomány típúsát a fában
function node.prototype:modifyNode(x, y, width, height, type)
    if (self:isFullyContained(x, y, width, height)) then -- ha teljesen kitölti a cellát (és/vagy túl is nyúl rajta)
        self.type = type
        self.isLeaf = true
        return
    elseif (self:isFullyOutside(x, y, width, height)) then -- ha teljesen kívül van
        return
    else -- Ha benne van egy cellában de nem tölti ki teljesen
        if (self.area <= quadtree.unit) then return end -- ha túl kicsi a test, nem rajzolja be
        if (self.isLeaf) then -- Ha levél a cella akkor felosztja 4 részre (Child)
            self:split()
        end
        self:modifyChildNodes(x, y, width, height, type) -- Megváltoztatja a 4 (Child) cella típusát
    end
end

-- true ha a test teljesen kitölti (és/vagy túl is nyúl rajta)
function node.prototype:isFullyContained(x, y, width, height) 
    return (x <= self.x and 
            x + width >= self.x + self.width and
            y <= self.y and
            y + height >= self.y + self.height)
end

-- true ha a testnek és a cellának nincsen egy közös pontja se
function node.prototype:isFullyOutside(x, y, width, height)
    return (self.x + self.width <= x or
            self.y + self.height <= y or
            x + width <= self.x or
            y + height <= self.y)
end

-- Felosztja 4 részre a cellát
function node.prototype:split()
    self.isLeaf = false
    local childWidth = self.width/2
    local childHeight = self.height/2
    self.quadrant[1] = node.new(self.x,                 self.y,                 childWidth, childHeight, self.type, self)
    self.quadrant[2] = node.new(self.x + childWidth,    self.y,                 childWidth, childHeight, self.type, self)
    self.quadrant[3] = node.new(self.x,                 self.y + childHeight,   childWidth, childHeight, self.type, self)
    self.quadrant[4] = node.new(self.x + childWidth,    self.y + childHeight,   childWidth, childHeight, self.type, self)
end

-- Megváltoztatja a 4 (Child) cella típusát
function node.prototype:modifyChildNodes(x, y, width, height, type)
    for i = 1,4 do
        self.quadrant[i]:modifyNode(x, y, width, height, type) -- Meghívja mind a 4-re a típusmódosítást
    end
    local sameType = true
    for i = 2,4 do -- Megvizsgálja hogy mind a 4-nek ugyan olyan-e a típusa
        if (not self.quadrant[i].isLeaf 
            or not self.quadrant[i-1].isLeaf
            or self.quadrant[i].type ~= self.quadrant[i-1].type) 
        then
            sameType = false
            break
        end
    end
    if sameType then -- Ha igen, összevonja őket.
        self:mergeQuadrants()
    end
end

-- Öszzevon egy szülőhöz tartozó 4 cellát, és levél lesz
function node.prototype:mergeQuadrants()
    self.type = self.quadrant[1].type
    self.quadrant = {}
    self.isLeaf = true
end

-----------------draw------------------

-- Kiküldi egy függvénynek a kirajzolandó téglalapokat
function quadtree:draw(fv)
    self.root:draw(fv)
end

function node.prototype:draw(fv) 
    if self.isLeaf then
        self:drawSelf(fv) -- Ha levél kirajzolja
    else
        for i = 1,4 do
            self.quadrant[i]:draw(fv) -- Ha nem akkor megnézi a Child celláit
        end
    end
end

function node.prototype:drawSelf(fv) --Meghívja a függvényt a téglalap adataival
    fv({x=self.x,y=self.y,width=self.width,heigth=self.height,type=self.type})
end

return quadtree