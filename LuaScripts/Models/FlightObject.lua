--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class FlightObject :Object
---@field Id integer
---@field TagerId integer|nil
---@field InitiatorId integer|nil
---@field From Point
---@field To Point
----@field _flightParameters { Arch :boolean, Wobble :boolean} #
---@alias CallbackFlightComplete fun(sender :FlightObject, successfully :boolean)
FlightObject = {
    ---@alias FlightParameters { Arch :boolean, Wobble :boolean }
    ---@type FlightParameters
    ---@protected
    _flightParameters = { Arch = true, Wobble = false },
    ---@protected
    ---@type CallbackFlightComplete[]
    _callbacksComplete = { }
}
FlightObject = Object:extend(FlightObject)

--- func desc
---@param id integer # Id flight object
---@param targetId integer|nil #
---@param initiatorId? integer|nil
---@param from Point #
---@param to Point #
---@param callbackComplete CallbackFlightComplete #
---@param flightParameters? FlightParameters|nil # Default { Arch = true, Wobble = false }
function FlightObject.new(id, targetId, initiatorId, from, to, callbackComplete, flightParameters)
    ---@type FlightObject
    local newInstance = FlightObject:make(id, targetId, initiatorId, from, to, callbackComplete, flightParameters)
    return newInstance
end

function FlightObject:initialize(id, targetId, initiatorId, from, to, callbackComplete, flightParameters)
    self._flightParameters = flightParameters or FlightObject._flightParameters
    self._callbacksComplete = { }
    self.Id = id
    self.TagerId = targetId
    self.InitiatorId = initiatorId
    self.From = from
    self.To = to

    self._callbacksComplete[#self._callbacksComplete + 1] = callbackComplete
end

--- func desc
---@param callback CallbackFlightComplete
function FlightObject:AddCallback(callback)
    self._callbacksComplete[#self._callbacksComplete + 1] = callback
    -- Logging.LogDebug("FlightObject:AddCallback %d", #self._callbacksComplete)
end

--- func desc
---@param speed? integer
---@param height? integer
---@public
function FlightObject:Start(speed, height)
    -- Logging.LogDebug("FlightObject.Start(speed = %d, height = %d) %s", speed, height, serializeTable(self))
    ModObject.StartMoveTo(self.Id, self.To.X, self.To.Y, speed, height)
end

function FlightObject:Check()
    -- Logging.LogDebug("FlightObject:Check")
    if (not ModObject.IsValidObjectUID(self.Id)) then
        self:OnFlightComplete(false)
        return
    end

    local complete = ModObject.UpdateMoveTo(self.Id, self._flightParameters.Arch, self._flightParameters.Wobble)
    if (complete) then
        self:OnFlightComplete()
    end
end

---@protected
---@param successfully? boolean
function FlightObject:OnFlightComplete(successfully)
    -- Logging.LogDebug("FlightObject.OnFlightComplete %s", serializeTable(self))
    for _, callback in ipairs(self._callbacksComplete) do
        callback(self, successfully == nil or successfully)
    end
end
