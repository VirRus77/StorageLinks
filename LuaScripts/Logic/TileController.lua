--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@alias Subscriber { Id :integer, InspectorType :string, Callback :function }
---@class TileController :Object #  provider поставщик
---@field _tileSubscriber table<PointString, TileSubscriber[]> #
---@field _timers table<PointString, string> #
---@field _inspectingTypes table<string, { GetValues :function, GetChanges :function}> #
---@field _inspectingsLastResult table<PointString, callbackArgs[]> #
---@field _subscribers table<integer, PointString[]>
---@field _timerStack TimersStack
TileController = {
}
---@type TileController
TileController = Object:extend(TileController)

--- func desc
---@param timerStack TimersStack
---@return TileController
function TileController.new(timerStack)
    local instance = TileController:make(timerStack)
    return instance
end

function TileController:initialize(timerStack)
    self._tileSubscriber = { }
    self._timers = { }
    self._inspectingTypes = { }
    self._inspectingsLastResult = { }
    self._timerStack = timerStack
end

--- func desc
---@param name string
---@param func fun(point :Point) :any
function TileController:AddInspector(name, funcGetValues, funcGetDelta)
    if(self._inspectingTypes[name] ~= nil) then
        Logging.LogError("TileController:AddInspector %s exist.", name)
        return
    end
    self._inspectingTypes[name].GetValues = funcGetValues
    self._inspectingTypes[name].GetChanges = funcGetDelta
end

--- func desc
---@param name string
function TileController:RemoveInspector(name)
    if(self._inspectingTypes[name] ~= nil) then
        Logging.LogError("TileController:AddInspector %s not exist.", name)
        return
    end
    self._inspectingTypes[name] = nil
end

--- func desc
---@param id integer # Author Id
---@param point Point
---@param inspectingTypes string[]
---@param period number # Period check in seconds
---@param action fun(values :callbackArgs)
function TileController:AddSubscriber(id, point, inspectingTypes, period, action)
    ---@type PointString
    local pointString = point:ToString()
    ---@type PointString[]
    local subscriberPoints = Tools.Dictionary.GetOrAddValue(self._subscribers, id, { })
    subscriberPoints[#subscriberPoints + 1] = pointString
    ---@type TileSubscriber[]
    local subscribers = Tools.Dictionary.GetOrAddValue(self._tileSubscriber, pointString, { })
    subscribers[#subscribers + 1] = TileSubscriber.new(id, point, inspectingTypes, action)
    ---@type string | nil
    local timerId = self._timers[pointString]
    if (timerId ~= nil) then
        return
    end
    local timer = Timer.new(period, function () self:CheckPoint(point) end)
    timer:RandomizeStart()
    self._timers[pointString] = self._timerStack:AddTimer(timer)
end

function TileController:CheckPoint(point)
    ---@type PointString
    local pointString = point:ToString()
    local lastInspectings = self._inspectingsLastResult[pointString]
    local subscribers = self._tileSubscriber[pointString]
    local inspectionNames = TileController:GetInspections(point, subscribers)
    ---@type callbackArgs[]
    local result = { }
    ---@type callbackArgs[]
    local changes = { }
    for _, inspectionName in pairs(inspectionNames) do
        local lastValues = nil
        if (lastInspectings ~= nil and lastInspectings[inspectionName]~= nil) then
            lastValues = lastInspectings[inspectionName].Values
        end

        local indpectFunctions = self._inspectingTypes[inspectionName]

        ---@type callbackArgs
        local newValues = indpectFunctions.GetValues(point)
        local resultValue = { InspectingType = inspectionName, Values = newValues }

        result[inspectionName] = result
        changes[inspectionName] = indpectFunctions.GetChanges(resultValue, lastValues)
    end
    self._inspectingsLastResult[pointString] = result

    for _, subscriber in pairs(subscribers) do
        subscriber.Callback(result)
    end
end

--- func desc
---@param point Point
---@param subscribers TileSubscriber[]|nil
---@return string[]
function TileController:GetInspections(point, subscribers)
    if (subscribers == nil) then
        error(string.format("TileController:GetInspections %s subscribers == nil", point), 666)
    end
    local allInspectings = { }
    for key, value in pairs(subscribers) do
        allInspectings = Linq.Concat(allInspectings, value:GetInspectings())
    end
    allInspectings = Linq.DistinctValue(allInspectings, function (key, value) return value end)
    if (#allInspectings == 0) then
        error(string.format("TileController:GetInspections %s #allInspectings == 0", point), 666)
    end

    return allInspectings
end