

local path = (...):gsub('%.[^%.]+$', '')


local plater = {}

plater.Layer = require(path .. ".Layer")


local customLayers = require(path .. ".customLayers")
for k,v in pairs(customLayers) do
    plater[k] = v
end


return plater
