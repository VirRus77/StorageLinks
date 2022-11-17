--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Transmitter :BuildingBase #
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
Transmitter = BuildingBase:extend(Transmitter)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@return Transmitter
function Transmitter.new(id, type, callbackRemove)
    Logging.LogInformation("Transmitter.new %d, %s", id, callbackRemove)
    ---@type TransmitterSettingsItem
    local settings = BuildingSettings.GetSettingsByType(type) or error("Transmitter Settings not found", 666) or { }
    ---@type Transmitter
    local instance = Transmitter:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod)

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
        self:UpdateName()
    elseif (editType == BuildingBase.BuildingEditType.Rename) then
        self:UpdateName()
        return
    elseif (editType == BuildingBase.BuildingEditType.Destroy) then
        self:RemoveLink()
        return
    end
end

function Transmitter:OnTimerCallback()
    -- Logging.LogInformation("Transmitter:OnTimerCallback \"%s\" [%s] R:%s", self.Name, self.WorkArea, self.Rotation)
    local location = self.Location
    local accessPoint = self.InputPoint
    ---@type Point
    if(self._acccessType == "Receiver")then
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

    --  if(building ~= nil)then
         -- Logging.LogDebug("Transmitter:OnTimerCallback BuildingRequirements:\n%s", ModBuilding.GetBuildingRequirements(building))
    --  end

    self:RemoveLink()
    self.LinkedBuildingId = building
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
        self.AccessPointId = VIRTUAL_NETWORK:AddProvider(StorageProvider.new(self.LinkedBuildingId, nil, self.Settings.MaxTransferPercentOneTime, VIRTUAL_NETWORK.HashTables))
    else
        self.AccessPointId = VIRTUAL_NETWORK:AddConsumer(BuildingConsumer.new(self.LinkedBuildingId, self.Settings.MaxTransferPercentOneTime, VIRTUAL_NETWORK.HashTables))
    end
end

function Transmitter:UpdateName()
    Logging.LogInformation("Transmitter:UpdateName %s", self.Name)
end

function Transmitter:SetAccessType()
    self._acccessType = "Both"
    if (self.InputPoint == nil) then
        self._acccessType = "Receiver"
    elseif (self.OutputPoint == nil) then
        self._acccessType = "Transmitter"
    end
end