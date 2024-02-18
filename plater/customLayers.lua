

local path = (...):gsub('%.[^%.]+$', '')
local Layer = require(path .. ".Layer")


local customLayers = {}


local function assertNumber(x)
    if type(x) ~= "number" then
        error("expected number, got: " .. tostring(x))
    end
end


function customLayers.SimplexLayer(period, amplitude)
    assert(love, "This layer requires love2d!")
    amplitude = amplitude or 1
    assertNumber(period)
    local noise = love.math.simplexNoise
    return Layer(function(x,y)
        return amplitude * noise(period*x, period*y)
    end)
end


function customLayers.FlatLayer(value)
    value = value or 0
    return Layer(function()
        return value
    end)
end


local max = math.max

function customLayers.Falloff(radius)
    radius = radius or 0.5
    local radiusSquared = radius * radius
    return Layer(function(x,y)
        x = x - 0.5
        y = y - 0.5
        return max(radiusSquared - (x*x + y*y), 0)
    end)
end


function customLayers.Cutoff(radius)
    radius = radius or 0.5
    local radiusSquared = radius * radius
    return Layer(function(x,y)
        x = x - 0.5
        y = y - 0.5
        if radiusSquared > (x*x + y*y) then
            return 0
        end
        return 1
    end)
end



return customLayers
