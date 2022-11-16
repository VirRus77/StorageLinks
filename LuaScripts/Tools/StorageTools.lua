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
    local isDurability = Tools.IsDurability(HASH_TABLES.Durability, storesType)
    -- Logging.LogDebug("StorageTools.TransferItems %d ==%d==> %d", storageSourceId, count, storageDestId)
    if (not isDurability) then
        local outputCount = storageSourceInfo.AmountStored - count
        ModStorage.SetStorageQuantityStored(storageSourceId, outputCount)
        storageSourceInfo.AmountStored = outputCount
        local inputCount = storageDestInfo.AmountStored + count
        ModStorage.SetStorageQuantityStored(storageDestId, inputCount)
        storageSourceInfo.AmountStored = inputCount
        return
    end

    local itemIds = ModStorage.RemoveFromStorage(storageSourceId, count, 0, 0)
    for _, itemId in ipairs(itemIds) do
        ModStorage.AddToStorage(storageDestId, itemId)
        if (ModObject.IsValidObjectUID(itemId)) then
            Logging.LogError("StorageTools.TransferItems Destory object: %d", itemId)
            ModObject.DestroyObject(itemId)
        end
    end
end

--- 
---@param storageId integer
---@param storageInfo UnpackStorageInfo
---@param objectInFlight? FlightObjectsList
---@return integer
function StorageTools.GetAmount(storageId, storageInfo, objectInFlight)
    if (storageInfo.Capacity == nil or storageInfo.AmountStored == nil) then
        Logging.LogWarning("StorageTools.GetAmount storageInfo.Capacity == nil or storageInfo.AmountStored == nil\n%s", storageInfo)
    end
    local amount = storageInfo.AmountStored;
    if (objectInFlight ~= nil) then
        amount = amount + #OBJECTS_IN_FLIGHT:FlightObjectByTarget(storageId)
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
        Logging.LogWarning("StorageTools.GetAmount GetFreeSpace ~storageInfo.Successfully")
        return 0
    end
    if (storageInfo.Capacity == nil or storageInfo.AmountStored == nil) then
        Logging.LogWarning("StorageTools.GetAmount storageInfo.Capacity == nil or storageInfo.AmountStored == nil\n%s", storageInfo)
    end
    local freeSpace = storageInfo.Capacity - storageInfo.AmountStored
    if (objectInFlight ~= nil) then
        freeSpace = freeSpace - #OBJECTS_IN_FLIGHT:FlightObjectByTarget(storageId)
    end

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
        ModObject.DestroyObject(itemId)
    end -- make sure!
end

function StorageTools.ExtractItemFromStorage(storageId, itemType, location)
    --Logging.LogDebug("ExtractItemFromStorage storageId:%d itemType:%s location:%s", storageId, itemType, location)
    local itemId = -1
    local freshUIDs = ModStorage.RemoveFromStorage(storageId, 1, location.X, location.Y)
    if(freshUIDs == nil or #freshUIDs == 0) then
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