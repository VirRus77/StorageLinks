--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@alias Subscriber { Id :integer, InspectorType :string, Callback :function }
---@class TileController :Object #  provider поставщик
---@field _tileSubscriber table<PointString, TileSubscriber[]> #
---@field _timers table<PointString, string> #
---@field _inspectingTypes table<string, { GetValues :function, GetChanges :function}> #
---@field _inspectingsLastResult table<PointString, table<string, any>> #
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
    Logging.LogDebug("TileController:AddInspector \"%s\" \"%s\" \"%s\"", name, funcGetValues, funcGetDelta)

    if(self._inspectingTypes[name] ~= nil) then
        Logging.LogError("TileController:AddInspector %s exist.", name)
        return
    end
    self._inspectingTypes[name] = { }
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
---@param action fun(values :TileController_CallbackArgs)
function TileController:AddSubscriber(id, point, inspectingTypes, period, action)
    Logging.LogDebug("TileController:AddSubscriber %d (%s) %s", id, point, inspectingTypes)
    ---@type PointString
    local pointString = point:ToString()

    -- Add to _subscribers
    ---@type PointString[]
    local subscriberPoints = Tools.Dictionary.GetOrAddValue(self._subscribers, id, { })
    subscriberPoints[#subscriberPoints + 1] = pointString

    -- Add to _tileSubscriber
    ---@type TileSubscriber[]
    local subscribers = Tools.Dictionary.GetOrAddValue(self._tileSubscriber, pointString, { })
    subscribers[#subscribers + 1] = TileSubscriber.new(id, point, inspectingTypes, action)

    -- Add to _timers
    ---@type string | nil
    local timerId = self._timers[pointString]
    if (timerId == nil) then
        local timer = Timer.new(
            period,
            function ()
                -- Logging.LogDebug("TileController:AddSubscriber self:CheckPoint")
                -- local sw = Stopwatch.Start()
                self:CheckPoint(point)
                -- Logging.LogDebug("TileController:AddSubscriber self:CheckPoint sw: %s", Stopwatch.ToTimeSpanString(sw:Elapsed()))
            end
        )
        timer:RandomizeStart()
        self._timers[pointString] = self._timerStack:AddTimer(timer)
    end

    -- Update subscriber
    self:AppendLastChanges(id, point, inspectingTypes, action)
end

function TileController:AppendLastChanges(id, point, inspectingTypes, action)
    Logging.LogDebug("TileController:AppendLastChanges %d (%s)", id, point)
    -- Update subscriber
    local lastValues = self._inspectingsLastResult[point:ToString()]
    if (lastValues == nil) then
        return
    end
    ---@type TileController_CallbackArgs
    local argsCallback = {
        Point = point
    }
    Linq.ForEach(
        inspectingTypes,
        function (key, value)
            if (lastValues[value] ~= nil) then
                argsCallback[value] = {
                    Add = lastValues[value]
                }
                --argsCallback[value].Add = lastValues[value]
            end
        end
    )
    action(argsCallback)
end

--- func desc
---@param id integer # Author Id
---@param point Point
function TileController:RemoveSubscriber(id, point)
    Logging.LogDebug("TileController:RemoveSubscriber %d (%s)", id, point)
    ---@type PointString
    local pointString = point:ToString()

    -- Remove from _subscribers
    if (self._subscribers[id] == nil) then
        Logging.LogError("TileController:RemoveSubscriber _subscribers %d (%s) not exist.", id, point)
        return
    end
    ---@type PointString[] | nil
    local subscriberPoints = Linq.Where(self._subscribers[id], function (key, value) return value ~= pointString end)
    if (#subscriberPoints == 0) then
        subscriberPoints = nil
    end
    self._subscribers[id] = subscriberPoints

    -- Remove from _tileSubscriber
    if (self._tileSubscriber[pointString] == nil) then
        Logging.LogError("TileController:RemoveSubscriber _tileSubscriber %d (%s) not exist.", id, point)
        return
    end
    ---@type TileSubscriber[]|nil
    local tileSubscribers = Linq.Where(self._tileSubscriber[pointString], function (key, value) return value.Id ~= id end)
    if (#tileSubscribers == 0) then
        tileSubscribers = nil
    end
    self._tileSubscriber[pointString] = tileSubscribers

    -- Remove from _timers
    if (tileSubscribers ~= nil) then
        return
    end
    if (self._timers[pointString] == nil) then
        Logging.LogError("TileController:RemoveSubscriber _timers %d (%s) not exist.", id, point)
        return
    end
    self._timerStack:RemoveTimer(self._timers[pointString])
    self._timers[pointString] = nil
end

--- func desc
---@param point Point
function TileController:CheckPoint(point)
    local sw = Stopwatch.Start()
    Logging.LogDebug("TileController:CheckPoint (%s)", point)
    ---@type PointString
    local pointString = point:ToString()
    local lastInspectingsResult = self._inspectingsLastResult[pointString]
    local subscribers = self._tileSubscriber[pointString]
    local inspectionNames = TileController:GetInspections(point, subscribers)
    -- Logging.LogDebug("TileController:CheckPoint inspectionNames: %s\nlastInspectingsResult: %s", inspectionNames, lastInspectingsResult)
    ---@type TileController_CallbackArgs[]
    local result = { }
    ---@type TileController_CallbackArgs[]
    local changes = {
        Point = point
    }
    for _, inspectionName in pairs(inspectionNames) do
        -- Logging.LogDebug("TileController:CheckPoint a  inspectionName: (%s)", inspectionName)
        local lastValues = nil
        if (lastInspectingsResult ~= nil and lastInspectingsResult[inspectionName] ~= nil) then
            -- Logging.LogDebug("TileController:CheckPoint lastInspectingsResult %s", lastInspectingsResult)
            lastValues = lastInspectingsResult[inspectionName]
        end

        local indpectFunctions = self._inspectingTypes[inspectionName]
        
        ---@type TileController_CallbackArgs
        local newValues = indpectFunctions.GetValues(point)

        result[inspectionName] = newValues
        -- Logging.LogDebug("TileController:CheckPoint d  newValues: (%s), lastValues: (%s)", SerializeTable(newValues), SerializeTable(lastValues))
        changes[inspectionName] = indpectFunctions.GetChanges(newValues, lastValues)
        -- Logging.LogDebug("TileController:CheckPoint d.2 change: (%s)", changes[inspectionName])
        -- Logging.LogDebug("TileController:CheckPoint \"%s\" result: %s\nchanges: %s", inspectionName, result, changes)
    end
    self._inspectingsLastResult[pointString] = result

    -- Logging.LogDebug("TileController:CheckPoint subscribers: %s\nchanges: %s", subscribers, changes)
    for _, subscriber in pairs(subscribers) do
        subscriber.Callback(changes)
    end
    -- Logging.LogDebug("TileController:CheckPoint sw: %s", Stopwatch.ToTimeSpanString(sw:Elapsed()))
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

function TileController:Clear()
    self._tileSubscriber = { }
    self. _timers = { }
    self._inspectingTypes = { }
    self._inspectingsLastResult = { }
    self._subscribers = { }
end