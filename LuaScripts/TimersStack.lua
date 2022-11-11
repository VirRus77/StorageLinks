--- storage by Timer
TimersStack = {
    ---@type Timer[] # array of Timer
    Timers = { }
 }

 --- Append delta time.
 ---@param deltaTime number
function TimersStack:AppendDelta(deltaTime)
    for _, value in ipairs(self.Timers) do
        value:AppendDelta(deltaTime)
    end
end

function TimersStack.Immediately()
    TimersStack:ImmediatelySelf()
end

function TimersStack:ImmediatelySelf()
    for _, value in ipairs(self.Timers) do
        value:Immediately()
    end
end

--- Add timer in list.
---@param timer Timer
function TimersStack.AddTimer(timer)
    table.insert(TimersStack.Timers, timer)
end

--- Add timers in list.
---@param timers Timer[]
function TimersStack.AddTimers(timers)
    for _, timer in ipairs(timers) do
        table.insert(TimersStack.Timers, timer)
    end
end

--- Remove all timers in list.
function TimersStack.Clear()
    for index, _ in ipairs(TimersStack.Timers) do
        TimersStack.Timers[index] = nil
    end
end