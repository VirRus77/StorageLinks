--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


--- storage by Timer
TimersStack = {
    _index = 1,
    ---@type Timer[] # array of Timer
    Timers = { }
 }

 --- Append delta time.
 ---@param deltaTime number
function TimersStack:AppendDelta(deltaTime)
    for _, value in pairs(self.Timers) do
        value:AppendDelta(deltaTime)
    end
end

function TimersStack.Immediately()
    TimersStack:ImmediatelySelf()
end

function TimersStack:ImmediatelySelf()
    for _, value in pairs(self.Timers) do
        value:Immediately()
    end
end

--- Add timer in list.
---@param timer Timer
---@return string # TimerId
function TimersStack.AddTimer(timer)
    local key = tostring(TimersStack._index)
    TimersStack.Timers[key] = timer
    TimersStack._index = TimersStack._index + 1
    return key
end

--- Add timers in list.
---@param timers Timer[]
---@return string[] # Array TimerId
function TimersStack.AddTimers(timers)
    local keys = { }
    for _, timer in pairs(timers) do
        keys[#keys + 1] = TimersStack.AddTimer(timer)
    end
    return keys
end

---@param key string # TimerId
function TimersStack.RemoveTimer(key)
    TimersStack.Timers[key] = nil
end

--- Remove all timers in list.
function TimersStack.Clear()
    TimersStack.Timers = { }
    -- for index, _ in ipairs(TimersStack.Timers) do
    --     TimersStack.Timers[index] = nil
    -- end
end