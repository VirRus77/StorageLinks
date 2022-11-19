--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Transmitter :BuildingStorageLinksBase #
---@field _acccessType "Transmitter"|"Receiver"|"Both"
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
Transmitter = BuildingStorageLinksBase:extend(Transmitter)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return Transmitter
function Transmitter.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("Transmitter.new %d, %s", id, callbackRemove)
    ---@type TransmitterSettingsItem
    local settings = BuildingSettings.GetSettingsByType(type) or error("Transmitter Settings not found", 666) or { }

    ---@type Transmitter
    local instance = Transmitter:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod, fireWall)

    instance.Settings = settings
    instance.InputPoint = settings.InputPoint
    instance.OutputPoint = settings.OutputPoint
    instance:SetAccessType()
    instance:UpdateLogic()

    return instance
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
---@param oldValue Point|nil
---@protected
function Transmitter:UpdateLogic(editType, oldValue)
    Logging.LogInformation("Transmitter:UpdateLogic %s", editType)
    if (editType == nil) then
        self:CheckAccessPoint()
        self:UpdateGroup()
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
        self:UpdateGroup()
        return
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Move) then
        self:CheckAccessPoint()
        return
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Destroy) then
        self:RemoveLink()
        self:RemoveFromFireWall()
        return
    end
end

function Transmitter:OnTimerCallback()
    -- Logging.LogInformation("Transmitter:OnTimerCallback \"%s\" [%s] R:%s", self.Name, self.WorkArea, self.Rotation)
    self:CheckAccessPoint()
end

function Transmitter:CheckAccessPoint()
    local location = self.Location
    ---@type Point
    local accessPoint = self.InputPoint
    if (self._acccessType == "Receiver") then
        accessPoint = self.OutputPoint
    end

    if (accessPoint == nil) then
        Logging.LogError("Transmitter:CheckAccessPoint all Access Points nil")
        return
    end

    local accessRotate = Point.Rotate(accessPoint, self.Rotation)
    accessPoint = Point.new(location.X + accessRotate.X, location.Y + accessRotate.Y)

    local buildingId = Tools.GetBuilding(accessPoint)
    if (buildingId == self.LinkedBuildingId) then
        return
    else
        if (buildingId ~= nil) then
            Logging.LogDebug("Transmitter:CheckAccessPoint Required: %s", Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(buildingId)))
        end
    end

    self:RemoveLink()
    self.LinkedBuildingId = buildingId
    self:AddLink()
end

function Transmitter:RemoveLink()
    if (self.AccessPointId == nil) then
        return
    end

    if(self._acccessType == "Transmitter")then
        VIRTUAL_NETWORK:RemoveProvider(self.AccessPointId)
    else
        VIRTUAL_NETWORK:RemoveConsumer(self.AccessPointId)
    end
    self.AccessPointId = nil
end

function Transmitter:AddLink()
    if (self.LinkedBuildingId == nil) then
        return
    end
    if ((self._acccessType == "Transmitter") and (not Tools.IsStorage(self.LinkedBuildingId))) then
        return
    end

    if (self._acccessType == "Transmitter") then
        self.AccessPointId = VIRTUAL_NETWORK:AddProvider(StorageProvider.new(self.Id, self.LinkedBuildingId, nil, self.Settings.MaxTransferOneTime, VIRTUAL_NETWORK.HashTables))
    else
        self.AccessPointId = VIRTUAL_NETWORK:AddConsumer(BuildingConsumer.new(self.Id, self.LinkedBuildingId, self.Settings.MaxTransferOneTime, VIRTUAL_NETWORK.HashTables))
    end
end

function Transmitter:SetAccessType()
    self._acccessType = "Both"
    if (self.InputPoint == nil) then
        self._acccessType = "Receiver"
    elseif (self.OutputPoint == nil) then
        self._acccessType = "Transmitter"
    end
end