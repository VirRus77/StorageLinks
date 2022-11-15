--   func desc
--  @param storageId integer
--  @return OBJECTS_IN_FLIGHT_Item[] #
--  ction GetFlightObjectByStorageId(storageId)
--   local objectsInFlight = { }
--   if (storageId == nil) then
--       return objectsInFlight
--   end
--  
--   for id, objectInFlight in pairs(OBJECTS_IN_FLIGHT) do
--       if (objectInFlight.storageUID == storageId) then
--           table.insert(objectsInFlight, objectInFlight)
--       end
--   end
--  
--   return objectsInFlight;
--  

--- func desc
---@param flyingObject FlightObject
---@param successfully boolean
function OnFlightComplete(flyingObject, successfully)
    --Logging.LogDebug(' OnFlightComplete(successfully = %s)\n%s', successfully, serializeTable(flyingObject))
    local flyingId = flyingObject.Id
    if (not ModObject.IsValidObjectUID(flyingId)) then
        return
    end

    local storageId = flyingObject.TagerId or -1
    if (storageId == -1) then
        return
    end
    -- ob has arrived!
    if (ModObject.IsValidObjectUID(storageId)) then -- both UID and storageUID are valid
        -- Use 'AddToStorage' only if it has durability.
        local maxUsage = ModVariable.GetVariableForObjectAsInt(ModObject.GetObjectType(flyingId), 'MaxUsage')
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
            ModStorage.AddToStorage(storageId, flyingId)
        end
    end

    -- still valid?
    if ModObject.IsValidObjectUID(flyingId) then
        ModObject.DestroyObject(flyingId)
    end -- make sure!
end

-- --- func desc
-- ---@param flyingUID integer
-- ---@param objectInFlight OBJECTS_IN_FLIGHT_Item
-- function onFlightCompleteForMagnets(flyingUID, objectInFlight)
--     if (not ModObject.IsValidObjectUID(flyingUID)) then
--         return
--     end
-- 
--     local storageId = objectInFlight.storageUID
--     -- ob has arrived!
--     if (ModObject.IsValidObjectUID(storageId)) then -- both UID and storageUID are valid
--         -- Use 'AddToStorage' only if it has durability.
--         local maxUsage = ModVariable.GetVariableForObjectAsInt(ModObject.GetObjectType(flyingUID), 'MaxUsage')
--         if (maxUsage == nil or maxUsage == 0) then -- No durability, just up storage qty
--             local storageInfo = UnpackStorageInfo ( ModStorage.GetStorageInfo(storageId) ) -- [2] = current amount, [3] = max
--             if (storageInfo.Successfully) then
--                 if storageInfo.AmountStored < 0 then
--                     storageInfo.AmountStored = 0
--                     ModStorage.SetStorageQuantityStored(storageId, 0)
--                 end
--                 ModStorage.SetStorageQuantityStored(storageId, storageInfo.AmountStored + 1)
--             end
--         else-- Durability present, use their method.
--             ModStorage.AddToStorage(storageId, flyingUID)
--         end
--     end
-- 
--     -- still valid?
--     if ModObject.IsValidObjectUID(flyingUID) then
--         ModObject.DestroyObject(flyingUID)
--     end -- make sure!
-- end

-- -- Moving OBJECTS_IN_FLIGHT
-- function updateFlightPositions()
--     -- If move not completed and valid, update
--     for id, objectInFlight in pairs(OBJECTS_IN_FLIGHT)
--     do
--         updatePositionOfUIDInFlight(id, objectInFlight)
--     end
-- end

-- --- func desc
-- ---@param id integer
-- ---@param objectInFlight OBJECTS_IN_FLIGHT_Item
-- function updatePositionOfUIDInFlight(id, objectInFlight)
--     if id ~= -1 and ModObject.IsValidObjectUID(id) then
--         local moveComplete = ModObject.UpdateMoveTo(id, objectInFlight.arch, objectInFlight.wobble)
--         if moveComplete then
--             objectInFlight.onFlightComplete(id, objectInFlight)
--             OBJECTS_IN_FLIGHT[id] = nil
--         end
--     end
-- end