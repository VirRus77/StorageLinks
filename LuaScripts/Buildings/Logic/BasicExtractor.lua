--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BasicExtractor #
---@field Id integer # Building UID
---@field Location Point #
---@type BuildingBase|Object
BasicExtractor = {
    ---@type ConverterItem
    Type = nil
}
BasicExtractor = BuildingBase:extend()
BasicExtractor.Type = Converters.Extractor
BasicExtractor.OutputPoint = 0
BasicExtractor.InputPoint  = 2

function BasicExtractor.new(objectId, callbackRemove)
    Logging.LogInformation("BasicExtractor.new %d, %s", objectId, callbackRemove)
    local instance = BasicExtractor:make(objectId, callbackRemove, nil, nil, 1)
    return instance
end

--- func desc
---@param editType BuildingEditType # nesw = 0123
---@protected
function BasicExtractor:UpdateLogic(editType)
    Logging.LogInformation("BasicExtractor:UpdateLogic %s", editType)
    if (editType == BuildingEditType.Rename) then
        return
    end
end

function BasicExtractor:OnTimerCallback()
    Logging.LogInformation("BasicExtractor:OnTimerCallback")
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
    if (#holdables < 5) then
        ModStorage.RemoveFromStorage(storageId, 1, outputPoint.X, outputPoint.Y)
        --local spawnObject = ModBase.SpawnItem(storageId.TypeStores, outputPoint.X, outputPoint.Y, false, true, false)
    end


end
