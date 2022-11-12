---@class Timer # 
---@field Period number # Period of callback
---@field Delay Timer # Period delay of callback
---@field Callback fun() # Callback function
Timer = { }

--- func desc
---@param periodDelta number
function Timer:AppendDelta (periodDelta)
end

--- func desc
function Timer:Immediately ()
end

--- Constructor
---@param period number # In seconds.
---@param callback fun() # Callback function.
---@param delay? number # In seconds.
---@return Timer # New instance of Timer
function Timer.new (period, callback, delay)
    ---@type Timer
    local newInstance = { }

    newInstance._workDelay = false
    newInstance._ticker = 0.0
    newInstance.Period = period
    newInstance.Callback = callback

    if(delay ~= nil and delay > 0.0) then
        newInstance.Delay = Timer.new(delay, callback)
    end

    --- func desc
    ---@param periodDelta number
    ---@return boolean # Callback invoke
    function newInstance:AppendDelta (periodDelta)
        if (self._workDelay) then
            self._workDelay = not self.Delay:AppendDelta (periodDelta)
        end
        self._ticker = self._ticker + periodDelta
        if (self._ticker > self.Period) then
            self._ticker = 0
            if (self.Delay ~= nil) then
                self._workDelay = true
            else
                self.Callback()
            end
            return true
        end
        return false
    end

    function newInstance:Immediately()
        self.Callback()
    end

    setmetatable(newInstance, Timer)
    newInstance.__index = Timer
    return newInstance
end

function Timer.MillisecondsToSeconds(milliseconds)
    if (milliseconds == 0) then
        error ("Timer.MilisecondsToSeconds. milliseconds eq 0.", 100)
    end
    return 1 / milliseconds;
end