

local falloff = plater.Falloff(0.45)
    :multiply(2)
    :offset(0.5,0.5)

local simplex = plater.SimplexLayer(13)
    :add(0.1)

local simplex2 = plater.SimplexLayer(3)
    :add(-0.15)
    :multiply(2)


local ROUGHNESS = 0.1
local roughEdges = plater.SimplexLayer(63)
    :multiply(2*ROUGHNESS)
    :add(-ROUGHNESS)

return simplex
    :add(roughEdges)
    :multiply(falloff)
    :multiply(simplex2)
    :apply(function(x)
        if x > 0.1 then
            return x * 2
        end
        return x
    end)


