

local warp = plater.Cutoff(0.5)

local simplex = plater.SimplexLayer(10)

local simplex2 = plater.SimplexLayer(5)
    :multiply(2)

return simplex:min(warp):multiply(simplex2)


