--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Timer :Object #
---@field _ticker number # Current ticks.
---@field Period number # Period of callback.
---@field Callback fun() # Callback function.
Timer = { }
---@type Timer
Timer = Object:extend(Timer)

-- Constructor
---@param period number # In seconds.
---@param callback fun() # Callback function.
---@param delay? number|nil # Start delay In seconds.
---@return Timer # New instance of Timer
function Timer.new(period, callback, delay)
    if (period < 0) then
        error("Timer.new period < 0.", 666)
    end
    ---@type Timer
    local newInstance = Timer:make(period, callback, delay or 0.0)
    return newInstance
end

---@param period number # In seconds.
---@param callback fun() # Callback function.
---@param delay? number # Start delay In seconds.
function Timer:initialize(period, callback, delay)
    self._ticker = delay or 0.0
    self.Period = period
    self.Callback = callback
end

--- func desc
---@param periodDelta number
---@return boolean # Callback invoke
function Timer:AppendDelta (periodDelta)
    self._ticker = self._ticker + periodDelta
    if (self._ticker > self.Period) then
        self._ticker = 0
        self.Callback()
        return true
    end
    return false
end

--- Call callback immediately.
function Timer:Immediately ()
    self.Callback()
end

--- func desc
---@return Timer
function Timer:RandomizeStart()
    self._ticker = math.random() * self.Period
    return self
end

--- Conver millisecondsToSeconds.
---@param milliseconds number
---@return number
function Timer.MillisecondsToSeconds(milliseconds)
    if (milliseconds == 0) then
        error ("Timer.MilisecondsToSeconds. milliseconds eq 0.", 100)
    end
    return 1 / milliseconds;
end