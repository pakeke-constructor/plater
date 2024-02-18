

local warp = plater.Cutoff(0.5)
local simplex = plater.SimplexLayer(10)

local layer = simplex:combine(warp, function(v1,v2)
    return math.min(v1,v2)
end)


return layer


