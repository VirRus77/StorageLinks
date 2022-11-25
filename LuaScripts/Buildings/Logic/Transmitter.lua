--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@alias AcccessPointType "Transmitter"|"Receiver"|"Both"

---@class Transmitter :BuildingFireWallBase #
---@field _acccessType AcccessPointType
---@field InputPoint Point|nil # Direction base rotation
---@field OutputPoint Point|nil # Direction base rotation
---@field AccessPoint Point #
---@field Settings TransmitterSettingsItem #
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
    self.base:initialize(id, type, callbackRemove, fireWall)
    self.InputPoint = self._settings.Settings.InputPoint
    self.OutputPoint = self._settings.Settings.OutputPoint
    self._acccessType = self:GetAccessType()
end

-- --- func desc
-- ---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
-- ---@param oldValue Point|nil
-- ---@protected
-- function Transmitter:UpdateLogic(editType, oldValue)
--     Logging.LogInformation("Transmitter:UpdateLogic %s", editType)
--     if (editType == nil) then
--         self:CheckAccessPoint()
--         self:UpdateGroup()
--     elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
--         self:UpdateGroup()
--         return
--     elseif (editType == BuildingStorageLinksBase.BuildingEditType.Move) then
--         self:CheckAccessPoint(oldValue)
--         return
--     elseif (editType == BuildingStorageLinksBase.BuildingEditType.Destroy) then
--         self:RemoveLink(self.LinkedBuildingIds)
--         self:RemoveFromFireWall()
--         return
--     end
-- end

-- function Transmitter:OnTimerCallback()
--     -- Logging.LogInformation("Transmitter:OnTimerCallback \"%s\" [%s] R:%s", self.Name, self.WorkArea, self.Rotation)
--     self:CheckAccessPoint()
-- end

-- --- func desc
-- ---@param oldLocation Point|nil
-- function Transmitter:MoveAccessPoint(oldLocation)
--     if (oldLocation ~= nil) then

--     end

-- end

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
        error("Transmitter:CheckAccessPoint all Access Points nil", 666)
        --Logging.LogError("Transmitter:CheckAccessPoint all Access Points nil")
        return
    end

    local accessPointRotate = Point.Rotate(accessPoint, self.Rotation)
    accessPoint = Point.new(location.X + accessPointRotate.X, location.Y + accessPointRotate.Y)
    return accessPoint
end

-- function Transmitter:CheckAccessPoint()
--     local location = self.Location
--     ---@type Point
--     local accessPoint = self.InputPoint
--     if (self._acccessType == "Receiver") then
--         accessPoint = self.OutputPoint
--     end

--     if (accessPoint == nil) then
--         error("Transmitter:CheckAccessPoint all Access Points nil", 666)
--         --Logging.LogError("Transmitter:CheckAccessPoint all Access Points nil")
--         return
--     end

--     local accessRotate = Point.Rotate(accessPoint, self.Rotation)
--     accessPoint = Point.new(location.X + accessRotate.X, location.Y + accessRotate.Y)


--     -- local buildingIds = Tools.GetAllBuilding(accessPoint)
--     -- -- Logging.LogDebug("Transmitter:CheckAccessPoint buildingIds:\n%s", buildingIds)
--     -- if (self._acccessType == "Transmitter") then
--     --     buildingIds = Tools.Where(
--     --         buildingIds,
--     --         function (id)
--     --             return Tools.IsStorage(id)
--     --         end
--     --     )
--     -- end

--     -- ---@type integer[]
--     -- local notExistIds = Tools.Where(
--     --     buildingIds,
--     --     function (value)
--     --         return self.LinkedBuildingIds[value] == nil
--     --     end
--     -- )

--     -- ---@type table<integer, string>
--     -- local removeIds = Tools.WhereTable(
--     --     self.LinkedBuildingIds,
--     --     function (key, value)
--     --         return not Tools.Contains(buildingIds, key)
--     --     end
--     -- )
--     -- if (#notExistIds == 0 and #removeIds == 0) then
--     --     return
--     -- end
--     -- Logging.LogDebug("Transmitter:CheckAccessPoint %d (%s) notExistIds:\n%s\nremoveIds:\n%s", self.Id, self.Location, notExistIds, removeIds)

--     -- if (#removeIds > 0) then
--     --     self:RemoveLink(removeIds)
--     -- end

--     -- if (#notExistIds > 0) then
--     --     self:AddLink(notExistIds)
--     -- end
-- end

-- --- func desc
-- ---@param removedItems table<integer, string>
-- function Transmitter:RemoveLink(removedItems)
--     -- if (self.AccessPointId == nil) then
--     --     return
--     -- end

--     for key, value in pairs(removedItems) do
--         if(self._acccessType == "Transmitter")then
--             VIRTUAL_NETWORK:RemoveProvider(value)
--         else
--             VIRTUAL_NETWORK:RemoveConsumer(value)
--         end
--         self.LinkedBuildingIds[key] = nil
--     end
-- end

-- --- func desc
-- ---@param addIds integer[]
-- function Transmitter:AddLink(addIds)
--     -- if (self.LinkedBuildingIds == nil) then
--     --     return
--     -- end
--     -- if ((self._acccessType == "Transmitter") and (not Tools.IsStorage(self.LinkedBuildingId))) then
--     --     return
--     -- end

--     for _, value in pairs(addIds) do
--         if (self._acccessType == "Transmitter") then
--             self.LinkedBuildingIds[value] = VIRTUAL_NETWORK:AddProvider(StorageProvider.new(self.Id, value, nil, self.Settings.MaxTransferOneTime, VIRTUAL_NETWORK.HashTables))
--         else
--             self.LinkedBuildingIds[value] = VIRTUAL_NETWORK:AddConsumer(BuildingConsumer.new(self.Id, value, self.Settings.MaxTransferOneTime, VIRTUAL_NETWORK.HashTables))
--         end
--     end
-- end

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