--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@alias AcccessPointType "Transmitter"|"Receiver"|"Both"

---@class Transmitter :BuildingFireWallBase #
---@field _acccessType AcccessPointType
---@field _linksVirtualNetwork table<integer, string>
---@field _settings TransmitterSettingsItem #
---@field InputPoint Point|nil # Direction base rotation
---@field OutputPoint Point|nil # Direction base rotation
---@field AccessPoint Point #
---@field base BuildingFireWallBase
Transmitter = {
    SupportTypes = {
        Buildings.TransmitterCrude.Type,
        Buildings.TransmitterGood.Type,
        Buildings.TransmitterSuper.Type,

        Buildings.ReceiverCrude.Type,
        Buildings.ReceiverGood.Type,
        Buildings.ReceiverSuper.Type,
    },
}
---@type Transmitter
Transmitter = BuildingFireWallBase:extend(Transmitter)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return Transmitter
function Transmitter.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("Transmitter.new %d, %s", id, callbackRemove)
    ---@type Transmitter
    local instance = Transmitter:make(id, type, callbackRemove, fireWall)
    return instance
end

---@param self Transmitter
function Transmitter:initialize(id, type, callbackRemove, fireWall)
    BuildingFireWallBase.initialize(self, id, type, callbackRemove, fireWall)
    self._linksVirtualNetwork = { }
    self.InputPoint = self._settings.InputPoint
    self.OutputPoint = self._settings.OutputPoint
    self._acccessType = self:GetAccessType()
    self:AddSubsriber()
    self:UpdateGroup()
end

--- func desc
---@param newValue integer
function Transmitter:OnRotate(newValue)
    self:RemoveSubsriber()
    self:RemoveLink(self._linksVirtualNetwork)
    BuildingFireWallBase.OnRotate(self, newValue)
    self:AddSubsriber()
end

--- func desc
---@param newValue Point
function Transmitter:OnMove(newValue)
    self:RemoveSubsriber()
    self:RemoveLink(self._linksVirtualNetwork)
    BuildingFireWallBase.OnMove(self, newValue)
    self:AddSubsriber()
end

function Transmitter:OnDestroy(newValue)
    self:RemoveSubsriber()
    self:RemoveLink(self._linksVirtualNetwork)
    BuildingFireWallBase.OnDestroy(self, newValue)
end

--- func desc
---@return Timer|nil
function Transmitter:MakeTimer()
    return nil
end

--- func desc
---@param changes TileController_CallbackArgs
function Transmitter:AccessChanged(changes)
    -- Logging.LogDebug("Transmitter:AccessChanged %d changes:\n%s", self.Id, changes)
    if (changes.Storage == nil and changes.Buildings == nil) then
        return
    end

    local added = { }
    local removed = { }
    if (changes.Storage ~= nil) then
        added = Linq.Concat(added, changes.Storage.Add or { })
        removed = Linq.Concat(removed, changes.Storage.Remove or { })
    end
    if (changes.Buildings ~= nil) then
        added = Linq.Concat(added, changes.Buildings.Add or { })
        removed = Linq.Concat(removed, changes.Buildings.Remove or { })
    end
    -- Logging.LogDebug("Transmitter:AccessChanged %d Add: %s\nRemove: %s", self.Id, added, removed)
    self:AddLink(added)
    local removeRecords = { }
    Linq.ForEach(
        removed,
        function (key, value)
            if (self._linksVirtualNetwork[value] ~= nil) then
                removeRecords[value] = self._linksVirtualNetwork[value]
            end
        end
    )
    self:RemoveLink(removeRecords)
end

--- func desc
---@return string[]
function Transmitter:InspectorTypes()
    local types = { };
    if (self._acccessType == "Transmitter" or self._acccessType == "Both") then
        types[#types + 1] = "Storage"
    end
    if (self._acccessType == "Receiver" or self._acccessType == "Both") then
        types[#types + 1] = "Buildings"
    end
    return types
end

function Transmitter:AddSubsriber()
    local sw = Stopwatch.Start()
    local accessPoint = self:GetAccessPoint(self.Location)
    ---@type TileInspectorTypes[]
    local types = self:InspectorTypes();

    TILE_CONTROLLER:AddSubscriber(self.Id, accessPoint, types, self._settings.UpdatePeriod, function (values) self:AccessChanged(values) end)
    Logging.LogDebug("Transmitter:AddSubsriber sw: %s", Stopwatch.ToTimeSpanString(sw:Elapsed()))
end

function Transmitter:RemoveSubsriber()
    local sw = Stopwatch.Start()
    local accessPoint = self:GetAccessPoint(self.Location)

    TILE_CONTROLLER:RemoveSubscriber(self.Id, accessPoint)
    Logging.LogDebug("Transmitter:RemoveSubsriber sw: %s", Stopwatch.ToTimeSpanString(sw:Elapsed()))
end

--- func desc
---@param location Point
---@return Point
function Transmitter:GetAccessPoint(location)
    ---@type Point
    local accessPoint = self.InputPoint
    if (self._acccessType == "Receiver") then
        accessPoint = self.OutputPoint
    end

    if (accessPoint == nil) then
        Logging.LogError("Transmitter:CheckAccessPoint all Access Points nil")
        error("Transmitter:CheckAccessPoint all Access Points nil", 666)
        -- Logging.LogError("Transmitter:CheckAccessPoint all Access Points nil")
        -- return
    end

    local accessPointRotate = Point.Rotate(accessPoint, self.Rotation)
    accessPoint = Point.new(location.X + accessPointRotate.X, location.Y + accessPointRotate.Y)
    return accessPoint
end

--- func desc
---@param removedItems table<integer, string>
function Transmitter:RemoveLink(removedItems)
    for key, value in pairs(removedItems) do
        if (self._acccessType == "Transmitter")then
            VIRTUAL_NETWORK:RemoveProvider(value)
        else
            VIRTUAL_NETWORK:RemoveConsumer(value)
        end
        self._linksVirtualNetwork[key] = nil
    end
end

--- func desc
---@param addIds integer[]
function Transmitter:AddLink(addIds)
    if (#addIds == 0) then
        return
    end

    for _, buildingId in pairs(addIds) do
        if (self._acccessType == "Transmitter") then
            self._linksVirtualNetwork[buildingId] = VIRTUAL_NETWORK:AddProvider(StorageProvider.new(self.Id, buildingId, nil, self._settings.MaxTransferOneTime, VIRTUAL_NETWORK.HashTables))
        else
            self._linksVirtualNetwork[buildingId] = VIRTUAL_NETWORK:AddConsumer(BuildingConsumer.new(self.Id, buildingId, self._settings.MaxTransferOneTime, VIRTUAL_NETWORK.HashTables))
        end
    end
end

--- func desc
---@return AcccessPointType
function Transmitter:GetAccessType()
    ---@type AcccessPointType
    local acccessType = "Both"
    if (self.InputPoint == nil) then
        acccessType = "Receiver"
    elseif (self.OutputPoint == nil) then
        acccessType = "Transmitter"
    end
    return acccessType
end