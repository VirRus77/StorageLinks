--- storage by Timer
TimerBase = {
    ---@type Timer[] # array of Timer
    Timers = { }
 }

 --- Append delta time.
 ---@param deltaTime number
function TimerBase:AppendDelta(deltaTime)
    for _, value in ipairs(self.Timers) do
        value:AppendDelta(deltaTime)
    end
end

--- Add timer in list.
---@param timer Timer
function TimerBase:AddTimer(timer)
    table.insert(self.Timers, timer)
end