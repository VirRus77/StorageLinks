--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Pumps :BuildingFireWallBase #
---@field WorkArea Area #
---@field InputPoint Point # Direction default rotation
---@field OutputPoint Point # Direction default rotation
---@field _settings PumpSettingsItem # Settings
Pumps = {
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
---@type Pumps
Pumps = BuildingFireWallBase:extend(Pumps)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return Pumps
function Pumps.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("Pumps.new %d, %s", id, callbackRemove)
    ---@type Pumps
    local instance = Pumps:make(id, type, callbackRemove, fireWall)
    return instance
end

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
function Pumps:initialize(id, type, callbackRemove, fireWall)
    BuildingFireWallBase.initialize(self, id, type, callbackRemove, fireWall)
    self.InputPoint = self._settings.InputPoint
    self.OutputPoint = self._settings.OutputPoint
    self:UpdateGroup()
end

-- --- func desc
-- ---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
-- ---@param oldValue Point|nil
-- ---@protected
-- function Pumps:UpdateLogic(editType, oldValue)
--     Logging.LogInformation("Pumps:UpdateLogic %s", editType)
--     if (editType == nil) then
--         self:UpdateGroup()
--     elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
--         self:UpdateGroup()
--         return
--     elseif (editType == BuildingStorageLinksBase.BuildingEditType.Destroy) then
--         self:RemoveFromFireWall()
--         return
--     end
-- end

function Pumps:OnTimerCallback()
    local sw = Stopwatch.Start()
    if (self._fireWall:Skip(self.Id)) then
        Logging.LogDebug("Pumps:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
        return
    else
        Logging.LogTrace("Pumps:OnTimerCallback \"%s\" (%s)\n%s", self.Name, self.Location, self._fireWall)
    end
    -- Logging.LogInformation("Pumps:OnTimerCallback \"%s\" (%s) R:%s", self.Name, self.Location, self.Rotation)
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
        Logging.LogDebug("Pumps:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
        return
    end

    local storageInputInfo = Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(storageInputId))
    local storageOutputInfo = Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(storageOutputId))
    -- Logging.LogDebug("%d %s -> %d %s", storageInputId, inputPoint, storageOutputId, outputPoint)

    if (not storageInputInfo.Successfully) then
        Logging.LogWarning("Not read storageInputInfo Id:%d", storageInputId)
        Logging.LogDebug("Pumps:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
        return
    end
    if (not storageOutputInfo.Successfully) then
        Logging.LogWarning("Not read storageInputInfo Id:%d", storageOutputId)
        Logging.LogDebug("Pumps:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
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
    Logging.LogDebug("Pumps:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
end

--- func desc
---@param storageInputId integer
---@param storageInputInfo UnpackStorageInfo
---@param storageOutputId integer
---@param storageOutputInfo UnpackStorageInfo
function Pumps:TransferLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
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
function Pumps:OwerflowLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    Logging.LogDebug("Pumps:OwerflowLogic")
    local freeSpace = StorageTools.GetFreeSpace(storageInputId, storageInputInfo, OBJECTS_IN_FLIGHT)
    -- Full = (5% of MaxCapacity)
    local limitFreeSpace = math.ceil(storageInputInfo.Capacity * 0.05) + 1
    Logging.LogDebug("Pumps:OwerflowLogic freeSpace: %d", freeSpace)
    if (StorageTools.GetFreeSpace(storageInputId, storageInputInfo, OBJECTS_IN_FLIGHT) > limitFreeSpace) then
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
function Pumps:BalancerLogic(storageInputId, storageInputInfo, storageOutputId, storageOutputInfo)
    -- Logging.LogDebug("Pumps:BalancerLogic")
    local inputAmount = StorageTools.GetAmount(storageInputId, storageInputInfo, OBJECTS_IN_FLIGHT)
    local outputAmount = StorageTools.GetAmount(storageOutputId, storageOutputInfo, OBJECTS_IN_FLIGHT)
    local averageAmount = math.floor((inputAmount + outputAmount) / 2)

    -- Logging.LogDebug("Pumps:BalancerLogic inputAmount: %d outputAmount: %d averageAmount: %d", inputAmount, outputAmount, averageAmount)

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
    -- Logging.LogDebug("Pumps:BalancerLogic needTransfer: %d canQuatityTransfer: %d", needTransfer, canQuatityTransfer)

    if (canQuatityTransfer <= 0) then
        return
    end
    local transferLimit = math.ceil( math.min(storageInputInfo.Capacity, storageOutputInfo.Capacity) * (self._settings.MaxTransferPercentOneTime / 100) )
    canQuatityTransfer = math.min(canQuatityTransfer, transferLimit)
    canQuatityTransfer = math.max(1, canQuatityTransfer)

    StorageTools.TransferItems(storageInputInfo.TypeStores, storageInputId, storageInputInfo, storageOutputId, storageOutputInfo, canQuatityTransfer)
end