--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Tools
---@function  GroupBy
Tools = { }

Tools.ColonistHouses = {
    ['Hut'] = true,
    ['LogCabin'] = true,
    ['StoneCottage'] = true,
    ['BrickHut'] = true,
    ['Mansion'] = true,
    ['Castle'] = true,
}

--- func desc
---@param hashTable table<string, integer> # HashTable Durability
---@param itemType string # Type of item
---@return boolean
function Tools.IsDurability(hashTable, itemType)
    return Tools.Durability(hashTable, itemType) > 0
end

--- func desc
---@param hashTable table<string, integer> # HashTable Durability
---@param itemType string # Type of item
---@return integer
function Tools.Durability(hashTable, itemType)
    local amount = Tools.Dictionary.GetOrAddValueLazy(
        hashTable,
        itemType,
        function ()
            return ModVariable.GetVariableForObjectAsInt(itemType, 'MaxUsage') or -1
        end
    )
    Logging.LogDebug("Tools.Durability %s: %d", itemType, amount)
    return amount
end

--- func desc
---@param hashTable table<string, integer> # HashTable Fuel
---@param itemType string # Type of item
---@return number|nil
function Tools.FuelAmount(hashTable, itemType)
    local amount = Tools.Dictionary.GetOrAddValueLazy(
        hashTable,
        itemType,
        function ()
            return ModVariable.GetVariableForObjectAsFloat(itemType, "Fuel") or -1
        end
    )
    return amount
end

--- func desc
---@param hashTable table<string, integer> # HashTable Durability
---@param itemType string # Type of item
---@return integer|nil
function Tools.WaterCapacity(hashTable, itemType)
    local amount = Tools.Dictionary.GetOrAddValueLazy(
        hashTable,
        itemType,
        function ()
            return ModVariable.GetVariableForObjectAsInt(itemType, "WaterCapacity") or -1
        end
    )
    return amount
end

--- Get building by location. Excludes floor, walls, and entrence, exits.
---@param location Point
---@return integer|nil
function Tools.GetBuilding(location)
    local id = ModBuilding.GetBuildingCoveringTile(location.X, location.Y)
    if (id == -1) then
        return nil
    end
    return id
end

--- Is storage.
---@param id integer
---@return boolean
function Tools.IsStorage(id)
    return ModObject.GetObjectSubcategory(id) == SubCategory.BuildingsStorage
end

--- Get count elements.
---@param tableValue table|any[]
function Tools.GetTableLength(tableValue)
    local count = 0
    if (tableValue == nil) then
        return count
    end
    for _ in pairs(tableValue) do
        count = count + 1
    end
    return count
end

--- By sort small to big
---@param a any
---@param b any
---@param invert boolean|nil
function Tools.Compare(a, b, invert)
    local result = (a < b)
    if(invert) then
        return not result
    end
    return result
end

--- Sort table if key integer
---@param tableValue table
---@param valueComparer fun(a :any, b :any) :boolean
---@return { Key :any, Value:any }[]
function Tools.TableSort(tableValue, valueComparer)
    valueComparer = valueComparer or function(a, b) return a < b end
    ---@type { Key :any, Value:any }[]
    local tempTable = { }
    for key, value in pairs(tableValue) do
        tempTable[#tempTable + 1] = { Key = key, Value = value }
    end
    table.sort(tempTable, function(a, b) return valueComparer(a.Value, b.Value) end)
    local newTable = { }
    for _, value in ipairs(tempTable) do
        newTable[#newTable + 1] = value
    end
    return newTable
end

Tools.Dictionary = {}

--- func desc
---@generic T :integer|string|table
---@param hashTable table<T, any>
---@param key T
---@param value any
---@return any|nil
function Tools.Dictionary.GetOrAddValue(hashTable, key, value)
    local hasValue = hashTable[key]
    if (hasValue == nil)then
        hasValue = value
        hashTable[key] = hasValue
    end
    return hasValue
end

--- func desc
---@generic T :integer|string
---@param hashTable table<T, any>
---@param key T
---@param getValue fun() :any
---@return any|nil
function Tools.Dictionary.GetOrAddValueLazy(hashTable, key, getValue)
    local hasValue = hashTable[key]
    if (hasValue == nil) then
        hasValue = getValue()
        hashTable[key] = hasValue
    end
    return hasValue
end

--- func desc
---@generic T :integer|string
---@param hashTable table<T, any>
---@param key T
---@param getValue fun(key :T) :any
---@return any|nil
function Tools.Dictionary.GetOrAddValueLazyVariable(hashTable, key, getValue)
    local hasValue = hashTable[key]
    if (hasValue == nil) then
        hasValue = getValue(key)
        hashTable[key] = hasValue
    end
    return hasValue
end


--- func desc
---@param hashTables table
---@param hashtableName string
---@param key any
---@param getValue fun() :any|nil
---@return any|nil
function Tools.Dictionary.GetOrAddValueByHashTables(hashTables, hashtableName, key, getValue)
    local hashTable = Tools.Dictionary.GetOrAddValue(hashTables, hashtableName, { })
    local value = hashTable[key]
    if (value == nil) then
        if (getValue == nil) then
            Logging.LogError("Tools.Dictionary.GetOrAddValueByHashTable getValue nil")
            return nil
        end
        value = getValue()
        hashTable[key] = value
    end

    return value
end

--- func desc
---@param hashTables table
---@param hashtableName string
---@param key any
---@param getValue fun(key :any) :any|nil
---@return any|nil
function Tools.Dictionary.GetOrAddValueByHashTablesVariable(hashTables, hashtableName, key, getValue)
    local hashTable = Tools.Dictionary.GetOrAddValue(hashTables, hashtableName, { })
    local value = hashTable[key]
    if (value == nil) then
        if (getValue == nil) then
            Logging.LogError("Tools.Dictionary.GetOrAddValueByHashTable getValue nil")
            return nil
        end
        value = getValue(key)
        hashTable[key] = value
    end

    return value
end

--- func desc
---@generic TKey :string|table
---@generic TValue :any|table
---@param table TValue[]
---@param keySelector fun(v :TValue) :TKey
---@return table<TKey, TValue[]>
function Tools.GroupBy(table, keySelector)
    local list = { }
    for _, value in pairs(table) do
        local key = keySelector(value)
        if (key == nil) then
            Logging.LogFatal("Tools.GroupBy Key is nil\n%s", table)
            error("Tools.GroupBy Key is nil\n%s", 666)
        end
        local group = Tools.Dictionary.GetOrAddValue(list, key, { })
        group[#group + 1] = value
    end
    return list
end

--- func desc
---@generic TKey :string|table
---@generic TValue :any|table
---@param table table<any, TValue>|table<integer, TValue>
---@param keySelector fun(v :TValue) :TKey
---@return table<TKey, TKey>
function Tools.SelectDistinctValues(table, keySelector)
    local list = { }
    for _, value in pairs(table) do
        local key = keySelector(value)
        list[key] = key
    end
    return list
end

--- func desc
---@generic TValue :any
---@param table table<integer,TValue>
---@param table2 table<integer,TValue>
---@return table<integer,TValue>
function Tools.TableConcat(table, table2)
    for index, value in ipairs(table2) do
        table[#table + 1] = value
    end
    return table
end

--- func desc
---@param buildingType string
function Tools.IsColonistHouse(buildingType)
    return Tools.ColonistHouses[buildingType] or false
end

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
    ---@type integer|nil
    local buildingId = Tools.GetBuilding(Point.new(x, y))
    local validBuilding =
        (buildingId ~= nil) and
        (buildingId ~= -1) and
        Tools.IsStorage(buildingId)

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
    Logging.LogDebug("Found OldType:", Tools.GetTableLength(oldB))
    if oldB == nil or oldB == -1 or oldB[1] == nil or oldB[1] == -1 then
        return false
    end
    Logging.LogDebug("Replace OldType...")
    local props, newUID, rot
    for _, uid in ipairs(oldB) do
        props = Extensions.UnpackObjectProperties( ModObject.GetObjectProperties(uid) ) -- Properties [1]=Type, [2]=TileX, [3]=TileY, [4]=Rotation, [5]=Name,
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
    local localValue = tostring(value)
    if (typeValue == "boolean") then
        localValue = tostring(value)
    elseif (typeValue == "table" and type(value.__tostring) == "function") then
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