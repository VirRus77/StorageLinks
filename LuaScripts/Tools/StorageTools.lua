--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class StorageTools
StorageTools = {}

--- func desc
---@param storesType string # Type store items.
---@param storageSourceId integer # Source storage Id.
---@param storageSourceInfo UnpackStorageInfo
---@param storageDestId integer # Destination storage.
---@param storageDestInfo UnpackStorageInfo
---@param count integer # Count transfer.
function StorageTools.TransferItems(storesType, storageSourceId, storageSourceInfo, storageDestId, storageDestInfo, count)
    Logging.LogDebug("StorageTools.TransferItems")
    if (count <= 0) then
        Logging.LogWarning("StorageTools.TransferItems count: %d exit.", count)
    end
    local isDurability = Tools.IsDurability(HASH_TABLES.Durability, storesType)
    Logging.LogDebug("StorageTools.TransferItems %d == %d x %s ==> %d", storageSourceId, count, storesType, storageDestId)
    Logging.LogDebug(
        "StorageTools.TransferItems storageSourceInfo \"%s\" (%s)\n%s",
        Extensions.UnpackObjectProperties(ModObject.GetObjectProperties(storageSourceId)).Name,
        Point.new(table.unpack(ModObject.GetObjectTileCoord(storageSourceId))),
        storageSourceInfo
    )
    Logging.LogDebug(
        "StorageTools.TransferItems storageDestInfo \"%s\" (%s)\n%s",
        Extensions.UnpackObjectProperties(ModObject.GetObjectProperties(storageDestId)).Name,
        Point.new(table.unpack(ModObject.GetObjectTileCoord(storageDestId))),
        storageDestInfo
    )
    if (not isDurability) then
        local sourceAmount = storageSourceInfo.AmountStored - count
        Logging.LogTrace("StorageTools.TransferItems Source %d => %d", storageSourceInfo.AmountStored, sourceAmount)
        if (not ModStorage.SetStorageQuantityStored(storageSourceId, sourceAmount)) then
            Logging.LogError(
                "StorageTools.TransferItems not change Sourve storage amount [%d] %s => %s\nstorageSourceInfo = %s",
                storageSourceId,
                Logging.ValueType(storageSourceInfo.AmountStored),
                Logging.ValueType(sourceAmount),
                storageSourceInfo
            )
        end
        storageSourceInfo.AmountStored = sourceAmount

        local destinationAmount = storageDestInfo.AmountStored + count
        Logging.LogTrace("StorageTools.TransferItems Destination %d => %d", storageDestInfo.AmountStored, destinationAmount)
        if (not ModStorage.SetStorageQuantityStored(storageDestId, destinationAmount)) then
            Logging.LogError(
                "StorageTools.TransferItems not change Destination storage amount [%d] %d => %d\nstorageSourceInfo = %s",
                storageDestId,
                storageDestInfo.AmountStored,
                destinationAmount,
                storageDestInfo
            )
        end
        storageDestInfo.AmountStored = destinationAmount
        return
    end

    local itemIds = ModStorage.RemoveFromStorage(storageSourceId, count, 0, 0)
    for _, itemId in pairs(itemIds) do
        if (ModStorage.AddToStorage(storageDestId, itemId)) then
            Logging.LogError("StorageTools.TransferItems cant add item: %d", itemId)
        end
        if (ModObject.IsValidObjectUID(itemId)) then
            Logging.LogError("StorageTools.TransferItems Destory object: %d", itemId)
            ModObject.DestroyObject(itemId)
        end
    end
end

--- func desc
---@param storesType string # Type store items.
---@param storageSourceId integer # Source storage Id.
---@param storageSourceInfo UnpackStorageInfo
---@param destinationId integer # Destination storage.
---@param count integer # Count transfer.
function StorageTools.TransferFuel(storesType, storageSourceId, storageSourceInfo, destinationId, count)
    local fuelAmount = Tools.FuelAmount(HASH_TABLES.Fuel, storesType)
    -- Logging.LogWarning("StorageTools.TransferFuel %d x %s: %s", count, storesType, tostring(fuelAmount))
    -- local buildingInfo = Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(destinationId))
    -- Logging.LogWarning("StorageTools.TransferFuel destInfo\n%s:", buildingInfo)

    if (fuelAmount <= 0) then
        Logging.LogWarning("StorageTools.TransferFuel There fuel? %s: %d", storesType, fuelAmount)
        return
    end

    if (not ModBuilding.AddFuel(destinationId, fuelAmount * count)) then
        Logging.LogDebug("StorageTools.TransferFuel. Fuel not added. [%d] ==(%d x %s)==> [%d]", storageSourceId, count, storesType, destinationId)
        if (not ModConverter.AddFuelToSpecifiedConverter(destinationId, fuelAmount * count)) then
            Logging.LogWarning("StorageTools.AddFuelToSpecifiedConverter. Fuel not added. [%d] ==(%d x %s)==> [%d]", storageSourceId, count, storesType, destinationId)
            return
        end
        Logging.LogDebug("StorageTools.TransferFuel. Fuel added (AddFuelToSpecifiedConverter). [%d] ==(%d x %s)==> [%d]", storageSourceId, count, storesType, destinationId)
    end

    local sourceAmount = storageSourceInfo.AmountStored - count
    if (not ModStorage.SetStorageQuantityStored(storageSourceId, sourceAmount)) then
        Logging.LogError("StorageTools.TransferItems not change Source storage amount [%d] %d => %d\nstorageSourceInfo = %s", storageSourceId, storageSourceInfo.AmountStored, sourceAmount, storageSourceInfo)
    end
end

--- func desc
---@param storesType string # Type store items.
---@param storageSourceId integer # Source storage Id.
---@param storageSourceInfo UnpackStorageInfo
---@param destinationId integer # Destination storage.
---@param count integer # Count transfer.
function StorageTools.TransferWater(storesType, storageSourceId, storageSourceInfo, destinationId, count)
    if (not ModBuilding.AddWater(destinationId, count)) then
        Logging.LogError("StorageTools.TransferWater. Water not added. [%d] ==(%d x %s)==> [%d]", storageSourceId, count, storesType, destinationId)
        return
    end

    local sourceAmount = storageSourceInfo.AmountStored - count
    if (not ModStorage.SetStorageQuantityStored(storageSourceId, sourceAmount)) then
        Logging.LogError("StorageTools.TransferWater not change Source storage amount [%d] %d => %d\nstorageSourceInfo = %s", storageSourceId, storageSourceInfo.AmountStored, sourceAmount, storageSourceInfo)
    end
end

--- func desc
---@param storesType string # Type store items.
---@param storageSourceId integer # Source storage Id.
---@param storageSourceInfo UnpackStorageInfo
---@param destinationId integer # Destination storage.
---@param count integer # Count transfer.
function StorageTools.TransferIngredient(storesType, storageSourceId, storageSourceInfo, destinationId, count)
    -- Logging.LogWarning("StorageTools.TransferFuel %d x %s: %s", count, storesType, tostring(fuelAmount))
    -- local buildingInfo = Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(destinationId))
    -- Logging.LogWarning("StorageTools.TransferFuel destInfo\n%s:", buildingInfo)

    local countAdded = 0
    for i = 1, count, 1 do
        if (not ModConverter.AddIngredientToSpecifiedConverter(destinationId, storesType)) then
            Logging.LogWarning("StorageTools.TransferIngredient not added: [%d] %d x %s", destinationId, count - countAdded, storesType)
            break
        end
        countAdded = countAdded + 1
    end
    if (countAdded == 0) then
        return
    end

    local sourceAmount = storageSourceInfo.AmountStored - countAdded
    if (not ModStorage.SetStorageQuantityStored(storageSourceId, sourceAmount)) then
        Logging.LogError("StorageTools.TransferIngredient not change Source storage amount [%d] %d => %d\nstorageSourceInfo = %s", storageSourceId, storageSourceInfo.AmountStored, sourceAmount, storageSourceInfo)
    end
end

--- func desc
---@param storesType string # Type store items.
---@param storageSourceId integer # Source storage Id.
---@param storageSourceInfo UnpackStorageInfo
---@param destinationId integer # Destination storage.
---@param count integer # Count transfer.
function StorageTools.TransferHeart(storesType, storageSourceId, storageSourceInfo, destinationId, count)
    -- Not supported current API.

    -- local itemIds = ModStorage.RemoveFromStorage(storageSourceId, count, 0, 0)
    -- for _, itemId in pairs(itemIds) do
    --     local requiredBefore = Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(destinationId))
    --     local heartAmountsBefore = Tools.GroupBy(requiredBefore.Heart, function (v) return v.Type end)

    --     local x = Extensions.GetFullInformation(destinationId);

    --     local added = ModObject.AddObjectToResearchStation(destinationId, itemId)
    --     if (added) then
    --         --Logging.LogDebug("StorageTools.TransferHeart State: %s", Extensions.UnpackConverterProperties(ModConverter.GetConverterProperties(destinationId)))
    --         Logging.LogDebug("StorageTools.TransferHeart add item: %d", itemId)
    --     else
    --         Logging.LogError("StorageTools.TransferHeart not add item: %d", itemId)
    --         ModStorage.AddToStorage(storageSourceId, itemId)
    --     end

    --     if (added) then
    --         Logging.LogDebug("StorageTools.TransferHeart FullInfo %s\n%s",x, Extensions.GetFullInformation(destinationId))
    --         local requiredAfter = Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(destinationId))
    --         --Logging.LogDebug("StorageTools.TransferHeart Amounts\nBefore: %s\nAfter: %s", requiredBefore, requiredAfter)
    --         local heartAmountsAfter = Tools.GroupBy(requiredAfter.Heart, function (v) return v.Type end)
    --         local changed = false
    --         for key, value in pairs(heartAmountsBefore) do
    --             changed = changed or (heartAmountsAfter[key] == nil)
    --             if (not changed) then
    --                 changed = heartAmountsAfter[key].AmountStored ~= value.AmountStored
    --             end
    --         end
    --         if (not changed) then
    --             --Logging.LogDebug("StorageTools.TransferHeart Amount not changed.\nBefore: %s\nAfter: %s", requiredBefore, requiredAfter)
    --             Logging.LogDebug("StorageTools.TransferHeart Amount not changed.", requiredBefore, requiredAfter)
    --             ModStorage.AddToStorage(storageSourceId, itemId)
    --         end
    --     end
    --     if (ModObject.IsValidObjectUID(itemId)) then
    --         if (ModObject.IsValidObjectUID(itemId)) then
    --             Logging.LogError("StorageTools.TransferHeart Destory object: %d", itemId)
    --             ModObject.DestroyObject(itemId)
    --         end
    --     end
    -- end
end

--- 
---@param storageId integer
---@param storageInfo UnpackStorageInfo
---@param objectInFlight? FlightObjectsList
---@return integer
function StorageTools.GetAmount(storageId, storageInfo, objectInFlight)
    if (storageInfo.AmountStored == nil) then
        Logging.LogWarning("StorageTools.GetAmount storageInfo.AmountStored == nil\n%s", storageInfo)
    end
    local amount = storageInfo.AmountStored or 0;
    if (objectInFlight ~= nil) then
        amount = amount + #objectInFlight:FlightObjectByTarget(storageId)
    end

    return amount
end

--- 
---@param storageId integer
---@param storageInfo UnpackStorageInfo
---@param objectInFlight? FlightObjectsList
---@return integer
function StorageTools.GetFreeSpace(storageId, storageInfo, objectInFlight)
    if (not storageInfo.Successfully) then
        Logging.LogWarning("StorageTools.GetFreeSpace GetFreeSpace ~storageInfo.Successfully")
        return 0
    end
    if (storageInfo.Capacity == nil) then
        Logging.LogWarning("StorageTools.GetFreeSpace storageInfo.Capacity == nil\n%s", storageInfo)
        return 0
    end
    local freeSpace = storageInfo.Capacity - StorageTools.GetAmount(storageId, storageInfo, objectInFlight)

    return freeSpace
end

function StorageTools.AddItemToStorage(storageId, itemId)
    -- ob has arrived!
    if (ModObject.IsValidObjectUID(storageId)) then -- both UID and storageUID are valid
        -- Use 'AddToStorage' only if it has durability.
        local maxUsage = ModVariable.GetVariableForObjectAsInt(ModObject.GetObjectType(itemId), 'MaxUsage')
        if (maxUsage == nil or maxUsage == 0) then -- No durability, just up storage qty
            local storageInfo = Extensions.UnpackStorageInfo ( ModStorage.GetStorageInfo(storageId) ) -- [2] = current amount, [3] = max
            if (storageInfo.Successfully) then
                if storageInfo.AmountStored < 0 then
                    storageInfo.AmountStored = 0
                    ModStorage.SetStorageQuantityStored(storageId, 0)
                end
                ModStorage.SetStorageQuantityStored(storageId, storageInfo.AmountStored + 1)
            end
        else-- Durability present, use their method.
            ModStorage.AddToStorage(storageId, itemId)
        end
    end

    -- still valid?
    if ModObject.IsValidObjectUID(itemId) then
        Logging.LogWarning("StorageTools.AddItemToStorage Remove Item [%d] %d", storageId, itemId)
        ModObject.DestroyObject(itemId)
    end -- make sure!
end

function StorageTools.ExtractItemFromStorage(storageId, itemType, location)
    --Logging.LogDebug("ExtractItemFromStorage storageId:%d itemType:%s location:%s", storageId, itemType, location)
    local itemId = -1
    local freshUIDs = ModStorage.RemoveFromStorage(storageId, 1, location.X, location.Y)
    if (freshUIDs == nil or #freshUIDs == 0) then
        return itemId
    end
    itemId = freshUIDs[1]
    return itemId
    -- local maxUsage = ModVariable.GetVariableForObjectAsInt(itemId, "MaxUsage")
    
    -- -- ob has arrived!
    -- if (ModObject.IsValidObjectUID(storageId)) then -- both UID and storageUID are valid
    --     -- Use 'AddToStorage' only if it has durability.
    --     local maxUsage = ModVariable.GetVariableForObjectAsInt(ModObject.GetObjectType(itemId), 'MaxUsage')
    --     if (maxUsage == nil or maxUsage == 0) then -- No durability, just up storage qty
    --         local storageInfo = UnpackStorageInfo ( ModStorage.GetStorageInfo(storageId) ) -- [2] = current amount, [3] = max
    --         if (storageInfo.Successfully) then
    --             if storageInfo.AmountStored < 0 then
    --                 storageInfo.AmountStored = 0
    --                 ModStorage.SetStorageQuantityStored(storageId, 0)
    --             end
    --             ModStorage.SetStorageQuantityStored(storageId, storageInfo.AmountStored + 1)
    --         end
    --     else-- Durability present, use their method.
    --         ModStorage.AddToStorage(storageId, itemId)
    --     end
    -- end

    -- -- still valid?
    -- if ModObject.IsValidObjectUID(itemId) then
    --     ModObject.DestroyObject(itemId)
    -- end -- make sure!
end