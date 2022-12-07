--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BasicExtractor :BuildingStorageLinksBase #
BasicExtractor = {
    SupportTypes = { Buildings.Extractor },
    OutputPoint = 0,
    InputPoint  = 2,
    StackLimit = 1,
    MinStackLimit = 1,
    MaxStackLimit = 5
}
---@type BasicExtractor #
BasicExtractor = BuildingStorageLinksBase:extend(BasicExtractor)

--- func desc
---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@return BasicExtractor
function BasicExtractor.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("BasicExtractor.new %d, %s, %s", id, callbackRemove, fireWall)
    ---@type BasicExtractor
    local instance = BasicExtractor:make(id, type, callbackRemove, nil, nil, 1)
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
---@param oldValue Point|nil
---@protected
function BasicExtractor:UpdateLogic(editType, oldValue)
    Logging.LogInformation("BasicExtractor:UpdateLogic %s", editType)
    if (editType == nil) then
        self:UpdateName()
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
        self:UpdateName()
        return
    end
end

function BasicExtractor:OnTimerCallback()
    -- Logging.LogDebug("BasicExtractor:OnTimerCallback (%s) R:%d \"%s\" Limit:%d", tostring(self.Location), self.Rotation, self.Name, self.StackLimit)
    local location = self.Location
    local rotation = self.Rotation
    local outputDelta = DirectionDeltaPoint[(BasicExtractor.OutputPoint + rotation) % 4]
    local inputDelta  = DirectionDeltaPoint[(BasicExtractor.InputPoint + rotation) % 4]
    local outputPoint = Point.new(location.X + outputDelta.X, location.Y + outputDelta.Y)
    local inputPoint  = Point.new(location.X + inputDelta.X, location.Y + inputDelta.Y)

    ---@type integer|nil
    local storageId = GetStorageIdOnTile(inputPoint.X, inputPoint.Y)
    if (storageId == nil)then
        return
    end

    local storageInfo = Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(storageId))
    -- Unreadable if the stored type is not set.
    if (not storageInfo.Successfully) then
        return
    end

    local amount = storageInfo.AmountStored
    if (amount <= 0) then
        return
    end

    --local holdables = GetHoldablesItemsOnArea(storageInfo.TypeStores, outputPoint.X - 5, outputPoint.Y - 5, outputPoint.X + 5, outputPoint.Y + 5)
    local holdables = GetHoldablesItemsOnLocation(storageInfo.TypeStores, outputPoint)
    -- Logging.LogDebug("GetHoldablesItemsOnLocation holdables: %d", #holdables)
    if (#holdables < self.StackLimit) then
        StorageTools.ExtractItemFromStorage(storageId, storageInfo.TypeStores, outputPoint)
        --ModStorage.RemoveFromStorage(storageId, 1, outputPoint.X, outputPoint.Y)
        --local spawnObject = ModBase.SpawnItem(storageId.TypeStores, outputPoint.X, outputPoint.Y, false, true, false)
    end
end

function BasicExtractor:UpdateName()
    Logging.LogInformation("BasicExtractor:UpdateName %s", self.Name)
    ---@type integer
    local limit = 1
    local startString, endString = string.find(self.Name, 'x%d+')
    if (startString ~= nil) then
        limit = tonumber(string.sub(self.Name, startString + 1, endString)) or self.MinStackLimit
    end
    limit = math.max(self.MinStackLimit, limit)
    limit = math.min(self.MaxStackLimit, limit)
    Logging.LogInformation("BasicExtractor:UpdateName limit %d", limit)
    self.StackLimit = limit
end