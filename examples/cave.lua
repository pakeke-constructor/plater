

local warp = plater.Falloff(0.45)
    :multiply(2)

local simplex = plater.SimplexLayer(13)
    :add(0.1)

local simplex2 = plater.SimplexLayer(3)
    :add(-0.15)
    :multiply(2)

return simplex:multiply(warp):multiply(simplex2)
    :apply(function(x)
        if x > 0.1 then
            return x * 2
        end
        return x
    end)


