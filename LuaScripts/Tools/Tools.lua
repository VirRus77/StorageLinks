--- Get UIDs by array types on map
---@param buildingTypes string[]
---@return integer[]
function GetUidsByTypesOnMap(buildingTypes)
    local uids = { }
    for _, buildingType in ipairs(buildingTypes) do
        local tempUids = ModBuilding.GetBuildingUIDsOfType(buildingType, 0, 0, WORLD_LIMITS.Width, WORLD_LIMITS.Height)
        for _, uid in ipairs(tempUids) do
            table.insert(uids, uid)
            --uids[#uids + 1] = uid
        end
    end
    return uids
end

--- Get Storage on Tile.
---@param x integer
---@param y integer
---@return integer|nil
function GetStorageOnTile(x, y)
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

--- Serialize table.
---@param val table
---@param name? any
---@param skipnewlines? any
---@param depth? any
function serializeTable (val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then
        tmp = tmp .. name .. " = "
    end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable (v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    tmp = tmp .. " :" .. type(val)

    return tmp
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
    Logging.Log("Replace: OldType:", oldName, " NewType: ", newName)
    local oldB = ModTiles.GetObjectUIDsOfType(oldName, 0, 0, WORLD_LIMITS.Width, WORLD_LIMITS.Height)
    --local oldB = ModBuilding.GetBuildingUIDsOfType(oldName, 0, 0, WORLD_LIMITS[1] - 1, WORLD_LIMITS[2] - 1)
    Logging.Log("Found OldType:", GetTableLength(oldB))
    if oldB == nil or oldB == -1 or oldB[1] == nil or oldB[1] == -1 then
        return false
    end
    Logging.Log("Replace OldType...")
    local props, newUID, rot
    for _, uid in ipairs(oldB) do
        props = UnpackObjectProperties( ModObject.GetObjectProperties(uid) ) -- Properties [1]=Type, [2]=TileX, [3]=TileY, [4]=Rotation, [5]=Name,
        if (props.Successfully) then
            rot = ModBuilding.GetRotation(uid)
            if (ModObject.DestroyObject(uid)) then
                newUID = ModBase.SpawnItem(newName, props.TileX, props.TileY, false, true, false)
                if (newUID == -1 or newUID == nil) then
                    Logging.Log('Could not re-create ', serializeTable({
                        props = props
                    }))
                else
                    ModBuilding.SetRotation(newUID, rot)
                    ModBuilding.SetBuildingName(newUID, props.Name)
                    Logging.Log("Replace item: ", serializeTable({
                        props = props,
                        newUID = newUID
                    }))
                end

            end -- of if object destroyed
        end
    end -- of oldB loop
end