

local layer = plater.Layer(function(x,y)
    return love.math.noise(x,y)
end)


return layer
