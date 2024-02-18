
local warp = plater.Layer(function(x,y)
    return 0.1 - math.abs(0.5-y)
end):multiply(3)


local simplex = plater.SimplexLayer(23)
    :add(0.25)

local simplex2 = plater.SimplexLayer(7)
    :add(0.21)
    :multiply(2)

return simplex
    :multiply(warp)
    :multiply(simplex2)
    :apply(function(x)
        if x > 0.1 then
            return x * 2
        end
        return x
    end)



