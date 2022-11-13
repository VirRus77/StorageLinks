--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Magnet #
---@field Id integer # Building UID
---@field Location Point #
---@type BuildingBase|Object
Magnet = {
    Types = {
        Buildings.MagnetCrude,
        Buildings.MagnetGood,
        Buildings.MagnetSuper,
    },
    OutputPoint = 0,
    InputPoint  = 2
}
Magnet = BuildingBase:extend(Magnet)

function Magnet.new(objectId, callbackRemove)
    Logging.LogInformation("Magnet.new %d, %s", objectId, callbackRemove)
    local instance = Magnet:make(objectId, callbackRemove, nil, nil, 1)
    return instance
end

--- func desc
---@param editType BuildingEditType # nesw = 0123
---@protected
function Magnet:UpdateLogic(editType)
    Logging.LogInformation("Magnet:UpdateLogic %s", editType)
    if (editType == BuildingEditType.Rename) then
        return
    end
end

function Magnet:OnTimerCallback()
    Logging.LogInformation("Magnet:OnTimerCallback")
    local location = self.Location
    local rotation = self.Rotation
    local outputDelta = DirectionDeltaPoint[(Magnet.OutputPoint + rotation) % 4]
    local inputDelta  = DirectionDeltaPoint[(Magnet.InputPoint + rotation) % 4]
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
