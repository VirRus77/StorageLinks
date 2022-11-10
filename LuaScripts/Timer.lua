---@class Timer #
---@field Period number
---@field Callback fun()
Timer = { }

--- func desc
---@param periodDelta number
function Timer:AppendDelta (periodDelta)
end

--- Constructor
---@param period number #In seconds.
---@param callback fun() #Callback function.
---@return Timer #
function Timer.new (period, callback)
    ---@type Timer
    local newInstance = { }

    newInstance._ticker = 0.0
    newInstance.Period = period
    newInstance.Callback = callback

    --- func desc
    ---@param periodDelta number
    function newInstance:AppendDelta (periodDelta)
        self._ticker = self._ticker + periodDelta
        if (self._ticker > self.Period) then
            self._ticker = 0
            self.Callback()
        end
    end

    setmetatable(newInstance, Timer)
    newInstance.__index = Timer
    return newInstance
end