--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BasicExtractor #
---@inherits BuildingBase
---@field Id integer # Building UID
---@type BuildingBase|Object
BasicExtractor = {
    SupportTypes = { Converters.Extractor },
    OutputPoint = 0,
    InputPoint  = 2,
    StackLimit = 1,
    MinStackLimit = 1,
    MaxStackLimit = 5
}
BasicExtractor = BuildingBase:extend(BasicExtractor)

--- func desc
---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@return BasicExtractor|BuildingBase
function BasicExtractor.new(id, type, callbackRemove)
    Logging.LogInformation("BasicExtractor.new %d, %s", id, callbackRemove)
    ---@type BasicExtractor|BuildingBase
    local instance = BasicExtractor:make(id, type, callbackRemove, nil, nil, 1)
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingEditType|nil # nesw = 0123
---@protected
function BasicExtractor:UpdateLogic(editType)
    Logging.LogInformation("BasicExtractor:UpdateLogic %s", editType)
    if (editType == nil) then
        self:UpdateName()
    elseif (editType == BuildingEditType.Rename) then
        self:UpdateName()
        return
    end
end

function BasicExtractor:OnTimerCallback()
    Logging.LogInformation("BasicExtractor:OnTimerCallback (%s) R:%d \"%s\" Limit:%d", tostring(self.Location), self.Rotation, self.Name, self.StackLimit)
    local location = self.Location
    local rotation = self.Rotation
    local outputDelta = DirectionDeltaPoint[(BasicExtractor.OutputPoint + rotation) % 4]
    local inputDelta  = DirectionDeltaPoint[(BasicExtractor.InputPoint + rotation) % 4]
    local outputPoint = Point.new(location.X + outputDelta.X, location.Y + outputDelta.Y)
    local inputPoint  = Point.new(location.X + inputDelta.X, location.Y + inputDelta.Y)

    ---@type integer|nil
    local storageId = GetStorageOnTile(inputPoint.X, inputPoint.Y)
    if (storageId == nil)then
        return
    end
    local storageInfo = UnpackStorageInfo(ModStorage.GetStorageInfo(storageId))
    local amount = storageInfo.AmountStored
    if(amount <= 0) then
        return
    end

    --local holdables = GetHoldablesItemsOnArea(storageInfo.TypeStores, outputPoint.X - 5, outputPoint.Y - 5, outputPoint.X + 5, outputPoint.Y + 5)
    local holdables = GetHoldablesItemsOnLocation(storageInfo.TypeStores, outputPoint)
    Logging.LogDebug("GetHoldablesItemsOnLocation holdables: %d", #holdables)
    if (#holdables < self.StackLimit) then
        ModStorage.RemoveFromStorage(storageId, 1, outputPoint.X, outputPoint.Y)
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