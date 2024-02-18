

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


local function mult(a,b)
    return a*b
end
local function add(a,b)
    return a+b
end

local function min(a,b)
    -- we can't do `local min=math.min` here,
    --  because math.min takes more than 2 arguments;
    -- and (x,y) are passed to `:evaluate`.  
    -- womp womp!
    return math.min(a,b)
end

local function max(a,b)
    return math.max(a,b)
end



local function isNumber(x)
    return type(x) == "number"
end


function Layer:multiply(other)
    if isNumber(other) then
        return self:apply(function(val)
            return val * other
        end)
    else
        return self:combine(other, mult)
    end
end

function Layer:add(other)
    if isNumber(other) then
        return self:apply(function(val)
            return val + other
        end)
    else
        return self:combine(other, mult)
    end
end

function Layer:min(other)
    if isNumber(other) then
        return self:apply(function(val)
            return math.min(val, other)
        end)
    else
        return self:combine(other, min)
    end
end

function Layer:max(other)
    if isNumber(other) then
        return self:apply(function(val)
            return math.max(val, other)
        end)
    else
        return self:combine(other, max)
    end
end




return newLayer

