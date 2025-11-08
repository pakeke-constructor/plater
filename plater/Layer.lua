
---@class Layer.Seed
---@field x number
---@field y number
local Layer_Seed = {}

---@alias Layer.Eval fun(x:number,y:number):number

---@class Layer
---@field seed Layer.Seed
---@field eval Layer.Eval
---@field ox number offset X
---@field oy number offset Y
local Layer = {}

local Layer_mt = {__index = Layer}



local function ret0(_x, _y)
    return 0
end


---@param evaluationFunction Layer.Eval
---@param seed? {x:number, y:number}
---@param ox? number
---@param oy? number
---@return Layer
local function newLayer(evaluationFunction, seed, ox,oy)
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
    self.ox = ox or 0
    self.oy = oy or 0

    self.eval = evaluationFunction or ret0

    return self
end



function Layer:evaluate(x,y)
    local passX = x-self.ox
    local passY = y-self.oy
    return self.eval(passX, passY)
end


function Layer:combine(otherLayer, func)
    local function eval(x,y)
        local val1 = self:evaluate(x,y)
        local val2 = otherLayer:evaluate(x,y)
        return func(val1,val2, x,y)
    end

    local ret = newLayer(eval, self.seed)
    return ret
end


function Layer:apply(func)
    local function eval(x,y)
        local val1 = self:evaluate(x,y)
        return func(val1, x,y)
    end
    return newLayer(eval, self.seed)
end



---@param ox number
---@param oy number
function Layer:offset(ox,oy)
    assert(ox and oy)
    return newLayer(self.eval, self.seed, ox,oy)
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

