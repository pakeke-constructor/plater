

local warp = plater.Cutoff(0.5)

local layer = plater.SimplexLayer(10)
    :combine(warp, math.max)

return layer


