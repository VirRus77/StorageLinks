--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class PumpBase :BuildingFireWallBase #
---@field WorkArea Area #
---@field InputPoint Point # Direction default rotation
---@field OutputPoint Point # Direction default rotation
---@field _settings PumpSettingsItem # Settings
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
}
---@type PumpBase
PumpBase = BuildingFireWallBase:extend(PumpBase)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return PumpBase
function PumpBase.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("PumpBase.new %d, %s", id, callbackRemove)
    ---@type PumpBase
    local instance = PumpBase:make(id, type, callbackRemove, fireWall)
    return instance
end

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
function PumpBase:initialize(id, type, callbackRemove, fireWall)
    BuildingFireWallBase.initialize(self, id, type, callbackRemove, fireWall)
    self.InputPoint = self._settings.InputPoint
    self.OutputPoint = self._settings.OutputPoint
    self:UpdateGroup()
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
---@param oldValue Point|nil
---@protected
function PumpBase:UpdateLogic(editType, oldValue)
    Logging.LogInformation("PumpBase:UpdateLogic %s", editType)
    if (editType == nil) then
        self:UpdateGroup()
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
        self:UpdateGroup()
        return
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Destroy) then
        self:RemoveFromFireWall()
        return
    end
end

function PumpBase:OnTimerCallback()
    if (self._fireWall:Skip(self.Id)) then
        return
    end
    -- Logging.LogInformation("PumpBase:OnTimerCallback \"%s\" (%s) R:%s", self.Name, self.Location, self.Rotation)
    local location = self.Location
    local inputRotate = Point.Rotate(self.InputPoint, self.Rotation)
    ---@type Point
    local inputPoint = location + inputRotate
    local outputRotate = Point.Rotate(self.OutputPoint, self.Rotation)
    ---@type Point
    local outputPoint =  location + outputRotate

    local storageInputId = Utils.GetStorage(inputPoint)
    local storageOutputId = Utils.GetStorage(outputPoint)

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

    if (self._settings.LogicType == "Transfer") then
        self:TransferLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    elseif (self._settings.LogicType == "Overflow") then
        self:OwerflowLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    elseif (self._settings.LogicType == "Balancer") then
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
    local transferLimit = math.ceil( math.min(storageInputInfo.Capacity, storageOutputInfo.Capacity) * (self._settings.MaxTransferPercentOneTime / 100) )
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
    local limitFreeSpace = math.ceil(storageInputInfo.Capacity * 0.05) + 1
    Logging.LogDebug("PumpBase:OwerflowLogic freeSpace: %d", freeSpace)
    if(StorageTools.GetFreeSpace(storageInputId, storageInputInfo, OBJECTS_IN_FLIGHT) > limitFreeSpace) then
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
    local transferLimit =  math.ceil(math.min(storageInputInfo.Capacity, storageOutputInfo.Capacity) * (self._settings.MaxTransferPercentOneTime / 100))
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
    local transferLimit = math.ceil( math.min(storageInputInfo.Capacity, storageOutputInfo.Capacity) * (self._settings.MaxTransferPercentOneTime / 100) )
    canQuatityTransfer = math.min(canQuatityTransfer, transferLimit)
    canQuatityTransfer = math.max(1, canQuatityTransfer)

    StorageTools.TransferItems(storageInputInfo.TypeStores, storageInputId, storageInputInfo, storageOutputId, storageOutputInfo, canQuatityTransfer)
end