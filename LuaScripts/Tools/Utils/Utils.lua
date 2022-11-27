--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


Utils = { }

Utils.BuildingsFilter = {
    Buildings = {
        ---@type table<SubCategoryValue, boolean>
        Skip = {
            [SubCategory.BuildingsFloors] = true,
            [SubCategory.BuildingsWalls] = true,
            [SubCategory.BuildingsSpecial] = true,
            -- [SubCategory.BuildingsStorage] = true,
        },
    },
    Hidden = {
    },
}

--- Is storage.
---@param id integer
---@return boolean
function Utils.IsStorage(id)
    local cachInfo = CACHE_ITEM_INFO:GetInfo(id)
    if (cachInfo ~= nil) then
        return cachInfo.Subcategory == SubCategory.BuildingsStorage
    end
    return ModObject.GetObjectSubcategory(id) == SubCategory.BuildingsStorage
end

--- func desc
---@param location Point
---@return integer|nil
function Utils.GetStorage(location)
    local id = ModBuilding.GetBuildingCoveringTile(location:Unpack())
    if (id == -1) then
        return nil
    end
    if (not Utils.IsStorage(id)) then
        return nil
    end

    return id
end

---@param newId integer|nil
---@param lastId integer|nil
---@return ChangesItem|nil
function Utils.ChangesSingleId(newId, lastId)
    Logging.LogDebug("Utils.ChangesSingleId %s, %s", tostring(newId), tostring(lastId))
    if (newId == nil and lastId == nil) then
        Logging.LogDebug("Utils.ChangesSingleId return nil", newId, lastId)
        return nil
    end
    Logging.LogDebug("Utils.ChangesSingleId newId ~= nil and lastId ~= nil")
    if (newId == lastId) then
        return nil
    end
    local newIds = { }
    local removeIds = { }
    if (newId ~= nil) then
        newIds[#newIds + 1] = newId
    end
    if (lastId ~= nil) then
        removeIds[#removeIds + 1] = lastId
    end
    local changes = {
        Add = newIds,
        Remove = removeIds
    }
    return changes
end

--- Get building by location. Excludes floor, walls, and entrence, exits.
---@param location Point
---@return integer[]
function Utils.GetAllSupportBuildings(location)
    Logging.LogDebug("Utils.GetAllSupportBuildings %s", location)
    -- Logging.LogDebug("Utils.GetAllSupportBuildings Utils.BuildingsFilter: %s", Utils.BuildingsFilter)
    ---@type integer[]
    local buildingIds = { }
    ---@type integer[]
    local ids =  ModTiles.GetObjectUIDsOnTile(location.X, location.Y)

    ---@type CacheItemInfoItem[]
    local typeSubType = { }
    for _, id in pairs(ids) do
        typeSubType[#typeSubType + 1] = CACHE_ITEM_INFO:GetInfo(id)
    end

    -- Logging.LogDebug("Utils.GetAllSupportBuildings typeSubType: %s", typeSubType)
    typeSubType = Linq.Where(
        typeSubType,
        function (key, value)
            -- Logging.LogDebug("Utils.GetAllSupportBuildings value.Category: %s", value.Category)
            local skipValues = Utils.BuildingsFilter[value.Category]
            if(skipValues == nil) then
                return false
            end
            if(skipValues.Skip ~= nil and skipValues.Skip[value.Subcategory] == true) then
                return false
            end

            return true
        end
    )
    -- Logging.LogDebug("Tools.GetAllBuilding (%s) Filter: %s", location, typeSubType)

    -- Storages
    local storages = Tools.Where(typeSubType, function (value) return value.Subcategory == SubCategory.BuildingsStorage end)
    if (#storages > 0) then
        local storageId = Tools.GetBuilding(location)
        if(storageId ~= nil) then
            -- Get last storage
            buildingIds[#buildingIds + 1] = storageId
        end
    end
    typeSubType = Tools.Where(typeSubType, function (value) return value.Subcategory ~= SubCategory.BuildingsStorage end)

    -- Hidden
    local hidens = Tools.Where(typeSubType, function (value) return value.Category == "Hidden" end)
    if(#hidens > 0) then
        for _, value in pairs(hidens) do
            buildingIds[#buildingIds + 1] = value["Id"]
        end
    end
    typeSubType = Tools.Where(typeSubType, function (value) return value.Category ~= "Hidden" end)

    for _, value in pairs(typeSubType) do
        buildingIds[#buildingIds + 1] = value["Id"]
    end

    -- Logging.LogDebug("Tools.GetAllBuilding (%s) return %s", location, buildingIds)
    return buildingIds
end

--- func desc
---@alias ChangesItem { Add :integer[], Remove :integer[] }
---@param table integer[]
---@param lastTable integer[]|nil
---@return ChangesItem|nil
function Utils.ChangesIds(table, lastTable)
    lastTable = lastTable or { }
    if (#table == 0 and #lastTable == 0) then
        return nil
    end
    local newIds = Linq.Where(
        table,
        function (_, newId)
            return not Linq.Contains(
                lastTable,
                function (_, value)
                    return value
                end,
                newId
            )
        end
    )
    local removeIds = Linq.Where(
        lastTable,
        function (_, newId)
            return not Linq.Contains(
                table,
                function (_, value)
                    return value
                end,
                newId
            )
        end
    )

    if (#newIds == 0 and #removeIds == 0) then
        return nil
    end

    local changes = { }
    if (#newIds > 0) then
        changes.Add = newIds
    end
    if (#removeIds > 0) then
        changes.Remove = removeIds
    end

    return changes
end

--- func desc
---@alias TileInspectorTypes "Storage"|"Buildings"
---@param tileController TileController
function Utils.AddInspectors(tileController)
    tileController:AddInspector("Storage", function (location) return { [1] = Utils.GetStorage(location) } end, Utils.ChangesIds)
    tileController:AddInspector("Buildings", Utils.GetAllSupportBuildings, Utils.ChangesIds)
end