

local simplex = plater.SimplexLayer(17)
    :add(0.1)

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
    :apply(function(x)
        return math.floor(x * NUM_TERRACES) / NUM_TERRACES
    end)




