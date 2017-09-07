# Quadtree
A quadtree libary written in Lua

## Screenshot
![PICTURE](https://github.com/varpeti/Quadtree/blob/master/quadtree.png)

## Installation

drag and drop quadtree.lua

## Usage

Include:
```lua
quadtree = require('quadtree')
```

Initialize:
```lua
quadtree:init(SmallestCellSize, LargestCellSize, LargestCellXCoordinate, LargestCellYCoordinate)
```

Add new objects:
```lua
quadtree:insert(Xcoord, Ycoord, Width, Height, Type)
```

Delete objects:
```lua
quadtree:insert(Xcoord, Ycoord, Width, Height, 0)
```

Delete objects:
```lua
quadtree:insert(Xcoord, Ycoord, Width, Height, 0)
```

Draw:
```lua
quadtree:draw(foo)

---

function foo(obj)
{
	if obj.type==1 then 
		yourdrawfunction.color(255,0,0) 
	elseif obj.type==1 then 
		yourdrawfunction.color(255,0,0) 
	else
		yourdrawfunction.color(0,0,0)
	end

	yourdrawfunction.rectangle(obj.x,obj.y,obj.width,obj.height)
}
```

## Example
[LÖVE](http://www.love2d.org)
main.lua

controll: w a s d
draw: q e
delelet: del
exit: esc 

## Licens
MIT
