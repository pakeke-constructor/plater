

math.randomseed(os.clock())

_G.plater = require("plater.plater")


local lg=love.graphics
lg.setDefaultFilter("nearest", "nearest")


local MAP_SIZE = 800
local SCREEN_SIZE = 600

local SCALE = SCREEN_SIZE / MAP_SIZE

love.window.setMode(SCREEN_SIZE, SCREEN_SIZE)






local function evalLayer(layer)
    local layerVals = {}
    for x=0, MAP_SIZE do
        for y=0, MAP_SIZE do
            local passX, passY = x/MAP_SIZE, y/MAP_SIZE
            local val = layer:evaluate(passX, passY)
            local point = {x,y,val,val,val,1}
            table.insert(layerVals, point)
        end
    end
    return layerVals
end






-- local layer = require("examples.cave")
-- local layer = require("examples.tunnel")
-- local layer = require("examples.terraces")


local layerVals = evalLayer(layer)


local screen=lg.newCanvas(MAP_SIZE,MAP_SIZE)

function love.load()
    lg.setCanvas(screen)
    lg.clear()
    lg.points(layerVals)
    lg.setCanvas()
end

function love.draw()
    lg.scale(SCALE)
    lg.draw(screen)
end


function love.keypressed(k)
    if k == "r" then
    love.event.quit("restart")
    end
end
