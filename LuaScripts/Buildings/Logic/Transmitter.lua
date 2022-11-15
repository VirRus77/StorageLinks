--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Transmitter :BuildingBase #
---@field WorkArea Area #
---@field InputPoint Point|nil # Direction base rotation
---@field OutputPoint Point|nil # Direction base rotation
---@field LinkedBuildingId integer|nil #
---@field AccessPointId string|nil #
---@field Settings TransmitterSettingsItem #
Transmitter = {
    SupportTypes = {
        Buildings.TransmitterCrude,
        Buildings.TransmitterGood,
        Buildings.TransmitterSuper,

        Buildings.ReceiverCrude,
        Buildings.ReceiverGood,
        Buildings.ReceiverSuper,
    },
}
---@type Transmitter
Transmitter = BuildingBase:extend(Transmitter)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@return Transmitter
function Transmitter.new(id, type, callbackRemove)
    Logging.LogInformation("Transmitter.new %d, %s", id, callbackRemove)
    ---@type TransmitterSettingsItem
    local settings = BuildingSettings.GetSettingsByType(type) or error("Transmitter Settings not found", 666) or { }
    local instance = Transmitter:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod)
    instance.Settings = settings
    instance.InputPoint = settings.InputPoint
    instance.OutputPoint = settings.OutputPoint
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingEditType # nesw = 0123
---@protected
function Transmitter:UpdateLogic(editType)
    Logging.LogInformation("Transmitter:UpdateLogic %s", editType)
    if (editType == nil) then
        self:UpdateName()
    elseif (editType == BuildingEditType.Rename) then
        self:UpdateName()
        return
    end
end

function Transmitter:OnTimerCallback()
    -- Logging.LogInformation("Transmitter:OnTimerCallback \"%s\" [%s] R:%s", self.Name, self.WorkArea, self.Rotation)
    local location = self.Location
    ---@type "Transmitter"|"Receiver" #
    local buildingType = "Transmitter"
    ---@type Point
    local accessPoint = self.InputPoint
    if (accessPoint == nil) then
        buildingType = "Receiver"
        accessPoint = self.OutputPoint
    end

    if (accessPoint == nil) then
        Logging.LogError("Transmitter:OnTimerCallback all Access Points nil")
        return
    end

    local accessRotate = Point.Rotate(accessPoint, self.Rotation)
    accessPoint = Point.new(location.X + accessRotate.X, location.Y + accessRotate.Y)

    local building = Tools.GetBuilding(accessPoint)
    if (building == self.LinkedBuildingId) then
        return
    end
    self:RemoveLink(buildingType)
    self.LinkedBuildingId = building
    self:AddLink(buildingType)
end

---@param buildingType "Transmitter"|"Receiver" #
function Transmitter:RemoveLink(buildingType)
    if (self.AccessPointId == nil) then
        return
    end

    if(buildingType == "Transmitter")then
        VIRTUAL_NETWORK:RemoveProvider(self.AccessPointId)
    else
        VIRTUAL_NETWORK:RemoveConsumer(self.AccessPointId)
    end
    self.AccessPointId = nil
end

---@param buildingType "Transmitter"|"Receiver" #
function Transmitter:AddLink(buildingType)
    if (self.LinkedBuildingId == nil) then
        return
    end
    if (not Tools.IsStorage(self.LinkedBuildingId)) then
        return
    end

    if (buildingType == "Transmitter") then
        self.AccessPointId = VIRTUAL_NETWORK:AddProvider(StorageProvider.new(self.LinkedBuildingId, nil, self.Settings.MaxTransferPercentOneTime, VIRTUAL_NETWORK.HashTables))
    else
        self.AccessPointId = VIRTUAL_NETWORK:AddConsumer(StorageConsumer.new(self.LinkedBuildingId, nil, self.Settings.MaxTransferPercentOneTime, VIRTUAL_NETWORK.HashTables))
    end
end

function Transmitter:UpdateName()
    Logging.LogInformation("Transmitter:UpdateName %s", self.Name)
end