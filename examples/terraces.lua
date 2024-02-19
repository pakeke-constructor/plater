

local simplex = plater.SimplexLayer(17)
    :add(0.1)
    :multiply(0.8)


local bigBoi = plater.SimplexLayer(2.9)
    :multiply(0.2)



local simplex1 = plater.SimplexLayer(1.3)
    :add(-0.4)
    :multiply(4)

local simplex2 = plater.SimplexLayer(4)
    :multiply(plater.SimplexLayer(7):add(0.7))
    :add(-0.3)
    :multiply(2)


local ROUGHNESS = 0.1
local roughEdges = plater.SimplexLayer(63)
    :add(0.5)
    :multiply(2*ROUGHNESS)
    :add(-ROUGHNESS)


local NUM_TERRACES = 4

return simplex
    :add(roughEdges)
    :multiply(simplex2)
    :add(simplex1)
    :add(bigBoi)
    :apply(function(x)
        return math.floor(x * NUM_TERRACES) / NUM_TERRACES
    end)




