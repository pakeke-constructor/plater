
---@class Layer.Seed
---@field x number
---@field y number
local Layer_Seed = {}


---@class Layer
---@field seed Layer.Seed
local Layer = {}

local Layer_mt = {__index = Layer}



local function ret0(_x, _y)
    return 0
end


---@param evaluationFunction fun(x:number,y:number):number
---@param seed? {x:number, y:number}
---@return Layer
local function newLayer(evaluationFunction, seed)
    local self = setmetatable({}, Layer_mt)

    self.seed = seed or {
        -- seed = x/y offsets for generation.
        -- If not specified, randomly generate.
        x = math.random(-4000, 4000) + math.random(),
        y = math.random(-4000, 4000) + math.random()
    } --[[
        TODO: Do some thinking about how seeding in this should work.
        We should ideally be able to change the seed for any layer,
        and have it just "work".

        Also, the noise should ideally be completely continuous,
        regardless of how the layers were layed out.

        Will almost definitely require refactor to customLayers.SimplexLayer
    ]]

    self.view = {x=0,y=0, w=1,h=1}
    self.evaluationFunction = evaluationFunction or ret0

    return self
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

    local ret = newLayer(eval, self.seed)
    ret.view = self.view
    return ret
end


function Layer:apply(func)
    local function eval(x,y)
        local val1 = self:evaluate(x,y)
        return func(val1, x,y)
    end
    return newLayer(eval, self.seed)
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
        return self:combine(other, add)
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

