

# plater API plan:

```lua
--[[

There is 1 base object: `Layer`.
Everything in `plater` is a Layer.

All Layers are immutable, and lazy.
(Ie; they do not contain numbers until they are evaluated.)

]]

local layer = Layer(function(x, y)
    return love.math.noise(x, y)
end)


-- `NoiseLayer` just calls `Layer` constructor internally
local lay2 = NoiseLayer({
    frequency = X,
    ...
})



layer:combine(layer2, function(val1,val2, x,y)
    -- val1=layer1 value, val2=layer2 value
    -- (x,y coords are passed too)
    return val1 + val2/2
end)

layer:apply(function(val, x,y)
    -- custom functions;
    -- (`val` is the value at x,y in `layer`.)
    return val + sin(x) + cos(y)
end)


layer:min(lay2) -- min/max of 2 layers.
layer:max(lay2)
-- can also use numbers:
layer:max(0)

layer:add(lay2)
layer:multiply(lay2)
-- can use numbers too:
layer:multiply(2)



--[[
    USAGE:
]]
local val = layer:evaluate(x,y)
-- gets the noise value at (x,y) coords



--[[

PROBLEM:

We want a better, nicer way to interface with positioning.
For example:

combining 4 separate "layers", such that there are 4 quadrants;
one quadrant for each layer.

IDEA:
Layers can have "views".
By default, layer w,h is 1.


]]

-- sets the "view" of a layer:
-- Default is 0,0,1,1
layer:view(x,y,w,h)
layer:getView() --> x,y,w,h


--[[

HMM:
What happens when two layers are overlayed, and they don't 
have overlapping views?

IDEA:
The returned layer's view should ALWAYS match that of the first layer.
For example:
`ret = lay1:combine(...)`
ret's view will be identical to lay1's view.
]]



```





