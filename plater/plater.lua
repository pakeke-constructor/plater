

local path = (...):gsub('%.[^%.]+$', '')


local plater = {}


local Layer = require(path .. ".Layer")

if false then
    ---@param eval Layer.Eval
    ---@param seed Layer.Seed?
    ---@param ox number?
    ---@param oy number?
    ---@return Layer
    function Layer(eval, seed, ox, oy) return Layer() end
end

plater.Layer = Layer





local function assertNumber(x)
    if type(x) ~= "number" then
        error("expected number, got: " .. tostring(x))
    end
end


function plater.SimplexLayer(period, amplitude)
    assert(love, "This layer requires love2d!")
    amplitude = amplitude or 1
    assertNumber(period)
    local noise = love.math.simplexNoise
    return Layer(function(x,y)
        return amplitude * noise(period*x, period*y)
    end)
end


function plater.FlatLayer(value)
    value = value or 0
    return Layer(function()
        return value
    end)
end


local max = math.max

function plater.Falloff(radius)
    radius = radius or 0.5
    local radiusSquared = radius * radius
    return Layer(function(x,y)
        return max(radiusSquared - (x*x + y*y), 0)
    end)
end


function plater.Cutoff(radius)
    radius = radius or 0.5
    local radiusSquared = radius * radius
    return Layer(function(x,y)
        if radiusSquared > (x*x + y*y) then
            return 1
        end
        return 0
    end)
end




return plater
