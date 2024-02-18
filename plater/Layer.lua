

local Layer = {}
local Layer_mt = {__index = Layer}



local function ret0(_x, _y)
    return 0
end


function newLayer(evaluationFunction)
    local self = setmetatable({}, Layer_mt)

    self.view = {x=0,y=0, w=1,h=1}
    self.evaluationFunction = evaluationFunction or ret0

    return self
end



function Layer:apply(func)
    return newLayer(func)
end



function Layer:evaluate(x,y)
    local v = self.view
    -- normalize (x,y) to [0,1] range
    local passX = (x-v.x)/v.w
    local passY = (y-v.y)/v.h
    return self.evaluationFunction(passX, passY)
end


function Layer:combine(otherLayer, func)
    local function eval(x,y)
        local val1 = self:evaluate(x,y)
        local val2 = otherLayer:evaluate(x,y)
        return func(val1,val2, x,y)
    end

    local ret = newLayer(eval)
    ret.view = self.view
    return ret
end


function Layer:apply(func)
    local function eval(x,y)
        local val1 = self:evaluate(x,y)
        return func(val1, x,y)
    end
    return newLayer(eval)
end




return newLayer

