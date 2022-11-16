--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Stopwatch :Object
---@field _start number
---@field _stop number|nil
Stopwatch = { }
---@type Stopwatch
Stopwatch = Object:extend(Stopwatch)

function Stopwatch.new()
    ---@type Stopwatch
    local instance = Stopwatch:make()
    instance._stop = nil
    return instance
end

function Stopwatch:initialize()
    self._start = os.clock()
end

---@param self Stopwatch|nil
---@return Stopwatch
function Stopwatch.Start(self)
    if (self ~= nil) then
        self._start = os.clock()
        self._stop = nil
        return self
    else
        return Stopwatch.new()
    end
end

---@param self Stopwatch
---@return Stopwatch
function Stopwatch.Stop(self)
    self._stop = os.clock()
    return self
end

---@param self Stopwatch
---@return number
function Stopwatch.Elapsed(self)
    local delta = (self._stop or os.clock()) - self._start
    return delta
end