--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class PumpBase :BuildingBase #
---@field WorkArea Area #
---@field InputPoint Point # Direction default rotation
---@field OutputPoint Point # Direction default rotation
---@field Settings PumpSettingsItem # Settings
PumpBase = {
    SupportTypes = {
        Buildings.PumpCrude,
        Buildings.PumpGood,
        Buildings.PumpSuper,
        Buildings.PumpSuperLong,

        Buildings.OverflowPumpCrude,
        Buildings.OverflowPumpGood,
        Buildings.OverflowPumpSuper,

        Buildings.BalancerCrude,
        Buildings.BalancerGood,
        Buildings.BalancerSuper,
        Buildings.BalancerSuperLong,
    },
    InputPoint  = Point.new(0, -1),
    OutputPoint = Point.new(0,  1),
}
PumpBase = BuildingBase:extend(PumpBase)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@return PumpBase
function PumpBase.new(id, type, callbackRemove)
    Logging.LogInformation("PumpBase.new %d, %s", id, callbackRemove)
    ---@type PumpSettingsItem
    local settings = BuildingSettings.GetSettingsByType(type) or error("PumpBase Settings not found", 666) or { }
    local instance = PumpBase:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod)
    instance.Settings = settings
    instance.InputPoint = settings.InputPoint or instance.InputPoint
    instance.OutputPoint = settings.OutputPoint or instance.OutputPoint
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
---@param oldValue Point|nil
---@protected
function PumpBase:UpdateLogic(editType, oldValue)
    Logging.LogInformation("PumpBase:UpdateLogic %s", editType)
    if (editType == nil) then
        --self:UpdateName()
    elseif (editType == BuildingBase.BuildingEditType.Rename) then
        return
    end
end

function PumpBase:OnTimerCallback()
    -- Logging.LogInformation("PumpBase:OnTimerCallback \"%s\" (%s) R:%s", self.Name, self.Location, self.Rotation)
    local location = self.Location
    local inputRotate = Point.Rotate(self.InputPoint, self.Rotation)
    local inputPoint = Point.new(location.X + inputRotate.X, location.Y + inputRotate.Y)
    local outputRotate = Point.Rotate(self.OutputPoint, self.Rotation)
    local outputPoint =  Point.new(location.X + outputRotate.X, location.Y + outputRotate.Y)

    local storageInputId = GetStorageIdOnTile(inputPoint.X, inputPoint.Y)
    local storageOutputId = GetStorageIdOnTile(outputPoint.X, outputPoint.Y)

    if (storageInputId == nil or storageOutputId == nil) then
        return
    end

    local storageInputInfo = Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(storageInputId))
    local storageOutputInfo = Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(storageOutputId))
    -- Logging.LogDebug("%d %s -> %d %s", storageInputId, inputPoint, storageOutputId, outputPoint)

    if(not storageInputInfo.Successfully) then
        Logging.LogWarning("Not read storageInputInfo Id:%d", storageInputId)
        return
    end
    if(not storageOutputInfo.Successfully) then
        Logging.LogWarning("Not read storageInputInfo Id:%d", storageOutputId)
        return
    end

    if (storageInputInfo.TypeStores ~= storageOutputInfo.TypeStores) then
        return
    end

    if (self.Settings.LogicType == "Transfer") then
        self:TransferLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    elseif (self.Settings.LogicType == "Overflow") then
        self:OwerflowLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    elseif (self.Settings.LogicType == "Balancer") then
        self:BalancerLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    end
end

--- func desc
---@param storageInputId integer
---@param storageInputInfo UnpackStorageInfo
---@param storageOutputId integer
---@param storageOutputInfo UnpackStorageInfo
function PumpBase:TransferLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    local canQuatityTransfer = math.min(
        -- Free space destination
        StorageTools.GetFreeSpace(storageOutputId, storageOutputInfo, OBJECTS_IN_FLIGHT),
        -- Amount source
        storageInputInfo.AmountStored
    )
    if (canQuatityTransfer <= 0) then
        return
    end
    local transferLimit = math.ceil( math.min(storageInputInfo.Capacity, storageOutputInfo.Capacity) * (self.Settings.MaxTransferPercentOneTime / 100) )
    canQuatityTransfer = math.min(canQuatityTransfer, transferLimit)
    canQuatityTransfer = math.max(1, canQuatityTransfer)

    StorageTools.TransferItems(storageInputInfo.TypeStores, storageInputId, storageInputInfo, storageOutputId, storageOutputInfo, canQuatityTransfer)
end

--- func desc
---@param storageInputId integer
---@param storageInputInfo UnpackStorageInfo
---@param storageOutputId integer
---@param storageOutputInfo UnpackStorageInfo
function PumpBase:OwerflowLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    Logging.LogDebug("PumpBase:OwerflowLogic")
    local freeSpace = StorageTools.GetFreeSpace(storageInputId, storageInputInfo, OBJECTS_IN_FLIGHT)
    Logging.LogDebug("PumpBase:OwerflowLogic freeSpace:%d", freeSpace)
    if(StorageTools.GetFreeSpace(storageInputId, storageInputInfo, OBJECTS_IN_FLIGHT) > 0) then
        return
    end

    local canQuatityTransfer = math.min(
        -- Free space destination
        StorageTools.GetFreeSpace(storageOutputId, storageOutputInfo, OBJECTS_IN_FLIGHT),
        -- Amount source
        storageInputInfo.AmountStored
    )
    if (canQuatityTransfer <= 0) then
        return
    end
    local transferLimit = math.ceil( math.min(storageInputInfo.Capacity, storageOutputInfo.Capacity) * (self.Settings.MaxTransferPercentOneTime / 100) )
    canQuatityTransfer = math.min(canQuatityTransfer, transferLimit)
    canQuatityTransfer = math.max(1, canQuatityTransfer)

    StorageTools.TransferItems(storageInputInfo.TypeStores, storageInputId, storageInputInfo, storageOutputId, storageOutputInfo, canQuatityTransfer)
end

--- func desc
---@param storageInputId integer
---@param storageInputInfo UnpackStorageInfo
---@param storageOutputId integer
---@param storageOutputInfo UnpackStorageInfo
function PumpBase:BalancerLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    -- Logging.LogDebug("PumpBase:BalancerLogic")
    local inputAmount = StorageTools.GetAmount(storageInputId, storageInputInfo, OBJECTS_IN_FLIGHT)
    local outputAmount = StorageTools.GetAmount(storageOutputId, storageOutputInfo, OBJECTS_IN_FLIGHT)
    local averageAmount = math.floor((inputAmount + outputAmount) / 2)

    -- Logging.LogDebug("PumpBase:BalancerLogic inputAmount: %d outputAmount: %d averageAmount: %d", inputAmount, outputAmount, averageAmount)

    if (inputAmount == averageAmount or outputAmount == averageAmount) then
        return
    end

    --- Switch
    if (outputAmount > inputAmount) then
        storageInputId, storageInputInfo, inputAmount, storageOutputId, storageOutputInfo, outputAmount =
        storageOutputId, storageOutputInfo, outputAmount, storageInputId, storageInputInfo, inputAmount
        --   table.unpack(table.pack(storageOutputId, storageOutputInfo, outputAmount, storageInputId, storageInputInfo, inputAmount))
        -- local tempId = storageInputId
        -- local tempInfo = storageInputInfo
        -- local tempAmount = inputAmount
        -- storageInputId = storageOutputId
        -- storageInputInfo = storageOutputInfo
        -- inputAmount = outputAmount
        -- storageOutputId = tempId
        -- storageOutputInfo = tempInfo
        -- outputAmount = tempAmount
    end

    local needTransfer = inputAmount - averageAmount
    local canQuatityTransfer = math.min(
        -- Free space destination
        StorageTools.GetFreeSpace(storageOutputId, storageOutputInfo, OBJECTS_IN_FLIGHT),
        -- Amount source
        storageInputInfo.AmountStored,
        -- Request transfer
        needTransfer
    )
    -- Logging.LogDebug("PumpBase:BalancerLogic needTransfer: %d canQuatityTransfer: %d", needTransfer, canQuatityTransfer)

    if (canQuatityTransfer <= 0) then
        return
    end
    local transferLimit = math.ceil( math.min(storageInputInfo.Capacity, storageOutputInfo.Capacity) * (self.Settings.MaxTransferPercentOneTime / 100) )
    canQuatityTransfer = math.min(canQuatityTransfer, transferLimit)
    canQuatityTransfer = math.max(1, canQuatityTransfer)

    StorageTools.TransferItems(storageInputInfo.TypeStores, storageInputId, storageInputInfo, storageOutputId, storageOutputInfo, canQuatityTransfer)
end