--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class FlightObjectsList
---@field _callbackComplete fun(sender :FlightObject, successfully :boolean)
FlightObjectsList = {
    ---@type FlightObject[]
    ---@protected
    _items = nil
}

FlightObjectsList.__index = FlightObjectsList

function FlightObjectsList.new()
    local newInstance = {
        _items = { }
    }

    setmetatable(newInstance, FlightObjectsList)
    newInstance.__index = FlightObjectsList
    return newInstance
end

---@param flightObject FlightObject
function FlightObjectsList:Remove(flightObject)
    self._items[flightObject.Id] = nil
end

---@param flightObject FlightObject
function FlightObjectsList:Add(flightObject)
    -- Logging.LogDebug("FlightObjectsList:Add:\n%s", serializeTable(flightObject))
    if( self._items[flightObject.Id] ~= nil) then
        Logging.LogError("FlightObjectsList:Add:\n%s", serializeTable(self._items[flightObject.Id]))
        error("Object In Flight")
    end

    flightObject:AddCallback(
        function (sender, successfully)
            -- Logging.LogDebug("Remove Object In Flight:\n%s", serializeTable(sender))
            self:Remove(sender)
        end
    )
    self._items[flightObject.Id] = flightObject
    -- Logging.LogDebug("FlightObjectsList:Add: End\n%s", serializeTable(self._items[flightObject.Id]))
end

function FlightObjectsList:Check()
    -- Logging.LogDebug("FlightObjectsList:Check")
    local count = 0
    for _, value in pairs(self._items) do
        count = count + 1
        value:Check()
    end
    -- Logging.LogDebug("FlightObjectsList:Check: %d", count)
end

--- func desc
---@param targetId integer
---@return FlightObject[]
function FlightObjectsList:FlightObjectByTarget(targetId)
    local found = { }
    for _, value in pairs(self._items) do
        if (value.TagerId == targetId) then
            found[#found + 1] = value 
        end
    end
    return found
end

function FlightObjectsList:Contains(objectId)
    return self._items[objectId] ~= nil
end