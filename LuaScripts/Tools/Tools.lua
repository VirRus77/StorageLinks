

--- Get all UIDs by array types on map
---@param buildingTypes string[]
---@return integer[]
function GetUidsByTypesOnMap(buildingTypes)
    -- Logging.LogDebug("GetUidsByTypesOnMap %s", buildingTypes)
    local uids = { }
    for _, buildingType in ipairs(buildingTypes) do
        -- Logging.LogDebug("GetUidsByTypesOnMap k:%s v:%s", _, buildingType)
        local tempUids = ModBuilding.GetBuildingUIDsOfType(buildingType, 0, 0, WORLD_LIMITS.Width, WORLD_LIMITS.Height)
        for _, uid in ipairs(tempUids) do
            uids[#uids + 1] = uid
        end
    end
    return uids
end

--- Get all UIDs by array types on map
---@param buildingTypes string[]
---@return table<string, integer[]> #
function GetTypedUidsByTypesOnMap(buildingTypes)
    local uids = { }
    for _, buildingType in ipairs(buildingTypes) do
        --local uidsByType = ModTiles.GetObjectUIDsOfType
        local uidsByType = ModBuilding.GetBuildingUIDsOfType(buildingType, 0, 0, WORLD_LIMITS.Width, WORLD_LIMITS.Height)
        uids[buildingType] = uidsByType
        --for _, uid in ipairs(tempUids) do
        --    uids[#uids + 1] = uid
        --end
    end
    return uids
end

--- func desc
---@param itemType string
---@param location Point
function GetHoldablesItemsOnLocation(itemType, location)
    return GetHoldablesItemsOnArea(itemType, location.X, location.Y, location.X, location.Y)
end

--- func desc
---@param itemType string
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function GetHoldablesItemsOnArea(itemType, left, top, right, bottom)
    local holdables = ModTiles.GetObjectUIDsOfType(
        itemType,
        left,
        top,
        right,
        bottom
    )
    if (holdables ~= nil and holdables[1] ~= nil) then
        return holdables
    end
    return { }
end

--- Get Storage on Tile.
---@param x integer
---@param y integer
---@return integer|nil # Storage Id
function GetStorageIdOnTile(x, y)
    ---@type integer
    local buildingId = ModBuilding.GetBuildingCoveringTile(x, y) -- excludes floor, walls, and entrence, exits.
    local validBuilding = (buildingId ~= -1) and
        ModObject.IsValidObjectUID(buildingId) and
        (ModObject.GetObjectSubcategory(buildingId) == SubCategory.BuildingsStorage)

    if (validBuilding) then
        return buildingId
    else
        -- uids = ModTiles.GetObjectUIDsOnTile(x,y)
        -- for _, uid in ipairs(uids) do
        -- 	if ModObject.GetObjectSubcategory(uid) == 'BuildingsStorage' then return uid end
        -- end
    end


    -- if ModTiles.IsSubcategoryOnTile(x,y,'Vehicles') then
        -- -- Check if it is a train carriage?
        -- types = ModTiles.GetObjectTypeOnTile(x, y)
        -- for _, typ in ipairs(types)
        -- do
            -- if string.sub(typ, 1, 8) == 'Carriage' then
                -- uids = ModTiles.GetObjectsOfTypeInAreaUIDs(typ, x, y, x, y)
                -- if uids ~= nil and uids[1] ~= nil and uids[1] ~= -1 then return uids[1] end
            -- end
        -- end
    -- end

    return nil
end

--- Get count elements.
---@param tableValue table|any[]
function GetTableLength(tableValue)
    local count = 0
    if (tableValue == nil) then
        return count
    end
    for _ in pairs(tableValue) do
        count = count + 1
    end
    return count
end

--- func desc
---@alias ReplaceItem { OldType :string, NewType :string } #
---@param replaceList ReplaceItem[] #
function ReplaceOldTypesToNewTypes(replaceList)
    for _, value in ipairs(replaceList) do
        ReplaceOldTypeToNewType(value.OldType, value.NewType)
    end
end

--- Switch type exist object.
---@param oldName string # Old type.
---@param newName string # New type.
function ReplaceOldTypeToNewType(oldName, newName)
    Logging.LogDebug("Replace: OldType:", oldName, " NewType: ", newName)
    local oldB = ModTiles.GetObjectUIDsOfType(oldName, 0, 0, WORLD_LIMITS.Width, WORLD_LIMITS.Height)
    --local oldB = ModBuilding.GetBuildingUIDsOfType(oldName, 0, 0, WORLD_LIMITS[1] - 1, WORLD_LIMITS[2] - 1)
    Logging.LogDebug("Found OldType:", GetTableLength(oldB))
    if oldB == nil or oldB == -1 or oldB[1] == nil or oldB[1] == -1 then
        return false
    end
    Logging.LogDebug("Replace OldType...")
    local props, newUID, rot
    for _, uid in ipairs(oldB) do
        props = UnpackObjectProperties( ModObject.GetObjectProperties(uid) ) -- Properties [1]=Type, [2]=TileX, [3]=TileY, [4]=Rotation, [5]=Name,
        if (props.Successfully) then
            rot = ModBuilding.GetRotation(uid)
            if (ModObject.DestroyObject(uid)) then
                newUID = ModBase.SpawnItem(newName, props.TileX, props.TileY, false, true, false)
                if (newUID == -1 or newUID == nil) then
                    Logging.LogDebug('Could not re-create ', serializeTable({
                        props = props
                    }))
                else
                    ModBuilding.SetRotation(newUID, rot)
                    ModBuilding.SetBuildingName(newUID, props.Name)
                    Logging.LogDebug("Replace item: ", serializeTable({
                        props = props,
                        newUID = newUID
                    }))
                end

            end -- of if object destroyed
        end
    end -- of oldB loop
end

function ToTypedString(value)
    local typeValue = type(value)
    local localValue = value
    if (typeValue == "boolean") then
        localValue = tostring(value)
    elseif (typeValue =="table" and type(value.__tostring) == "function") then
        localValue = tostring(value)
    end

    return string.format("%s :%s", localValue, typeValue)
end

-- --- func desc
-- ---@param classTable table
-- ---@param baseClassTable? table
-- function MakeClass(classTable, baseClassTable)
--     baseClassTable = baseClassTable or {}               --use passed-in object (if any)
--     classTable = classTable or {}
--     --assert(type(old_obj) == 'table','Object/Class is not a table')
--     --assert(type(new_obj) == 'table','Object/Class is not a table')
--     baseClassTable.__index = baseClassTable             --store __index in parent object (optimization)
--     return setmetatable(classTable, baseClassTable)  --create 'new_obj' inheriting 'old_obj'
-- end