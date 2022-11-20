--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


--- storage by Timer
---@class TimersStack :Object
---@field _index integer
---@field _timers table<string, Timer>
TimersStack = { }

---@type TimersStack
TimersStack = Object:extend(TimersStack)

---@return TimersStack
function TimersStack.new()
    ---@type TimersStack
    local instance = TimersStack:make()
    return instance
end

function TimersStack:initialize()
    self._index = 1
    self._timers = { }
end

 --- Append delta time.
 ---@param deltaTime number
function TimersStack:AppendDelta(deltaTime)
    for _, value in pairs(self._timers) do
        value:AppendDelta(deltaTime)
    end
end

function TimersStack:Immediately()
    for _, value in pairs(self._timers) do
        value:Immediately()
    end
end

--- Add timer in list.
---@param timer Timer
---@return string # TimerId
function TimersStack:AddTimer(timer)
    local key = tostring(self._index)
    self._timers[key] = timer
    self._index = self._index + 1
    return key
end

--- Add timers in list.
---@param timers Timer[]
---@return string[] # Array TimerId
function TimersStack:AddTimers(timers)
    local keys = { }
    for _, timer in pairs(timers) do
        keys[#keys + 1] = self:AddTimer(timer)
    end
    return keys
end

---@param key string # TimerId
function TimersStack:RemoveTimer(key)
    self._timers[key] = nil
end

--- Remove all timers in list.
function TimersStack:Clear()
    self._index = 1
    self._timers = { }
end