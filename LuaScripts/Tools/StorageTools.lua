StorageTools = {}

function StorageTools.AddItemToStorage(storageId, itemId)
    -- ob has arrived!
    if (ModObject.IsValidObjectUID(storageId)) then -- both UID and storageUID are valid
        -- Use 'AddToStorage' only if it has durability.
        local maxUsage = ModVariable.GetVariableForObjectAsInt(ModObject.GetObjectType(itemId), 'MaxUsage')
        if (maxUsage == nil or maxUsage == 0) then -- No durability, just up storage qty
            local storageInfo = UnpackStorageInfo ( ModStorage.GetStorageInfo(storageId) ) -- [2] = current amount, [3] = max
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