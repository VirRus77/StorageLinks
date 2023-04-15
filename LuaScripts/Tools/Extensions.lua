--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


Extensions = { }

---@class UnpackStorageInfo
---@field TypeStores string #
---@field AmountStored integer #
---@field Capacity integer #
---@field StorageType string #
---@field Successfully boolean #
Extensions.UnpackStorageInfo = { }

---@class UnpackBuildingRequirementsItem
---@field Type string #
---@field Capacity number #
---@field Amount number #
Extensions.UnpackBuildingRequirementsItem = { }

---@class UnpackBuildingRequirementsList
---@field Successfully boolean #
---@field Ingredient UnpackBuildingRequirementsItem[]|nil #
---@field Fuel UnpackBuildingRequirementsItem[]|nil #
---@field Water UnpackBuildingRequirementsItem[]|nil #
---@field Heart UnpackBuildingRequirementsItem[]|nil #
---@field Hay UnpackBuildingRequirementsItem[]|nil #
Extensions.UnpackBuildingRequirementsList = { }


-- Unpack @{ObjectProperties}
---@alias UnpackObjectProperties { Type :string, TileX :integer, TileY:integer, Rotation :number, Name :string, Successfully :boolean, [1] :string, [2] :number, [3] :number, [4] :number, [5] :string } #
---@param properties ObjectProperties|nil #
---@param normalizeRotation? boolean # Dafault true
---@return UnpackObjectProperties #
function Extensions.UnpackObjectProperties(properties, normalizeRotation)
    local successfully = properties ~= nil and properties[1] ~= nil
    if (not successfully) then
        return { Successfully = false }
    end

    -- hack
    ---@type ObjectProperties
    properties = properties or { }

    local result = {
        Successfully = true,
        Type     = properties[1],
        TileX    = properties[2],
        TileY    = properties[3],
        Rotation = properties[4],
        Name     = properties[5],

    }

    if (normalizeRotation == nil or normalizeRotation) then
        -- round the rotation to a whole number
        result.Rotation = math.floor(result.Rotation + 0.5)
    end

    return result
end

-- Unpack @{StorageInfo}
---@alias UnpackStorageInfoOld { TypeStores :string, AmountStored :integer, Capacity :integer, StorageType :string, Successfully :boolean, [1] :string, [2] :integer, [3] :integer, [4] :string } #
---@param properties StorageInfo|nil #
---@return UnpackStorageInfoOld #
function Extensions.UnpackStorageInfo (properties)
    ---{[1] :string, [2] :integer, [3] :integer, [4] :string} # Properties [1]=Object It Stores, [2]=Amount Stored, [3]=Capacity, [4]=Type Of Storage
    local successfully = properties ~= nil and properties[1] ~= nil
    if (not successfully) then
        return { Successfully = false }
    end

    -- hack
    ---@type StorageInfo
    properties = properties or { }

    ---@type UnpackStorageInfo
    local result = {
        Successfully = true,
        TypeStores   = properties[1],
        AmountStored = properties[2],
        Capacity     = properties[3],
        StorageType  = properties[4],
    }

    return result
end

--- Unpack @{ConverterProperties}
---@alias UnpackConverterProperties { State : "Idle"|"Converting"|"Creating"|"Cancelling", TileX :integer, TileY :integer, Rotation :number, Name :string, RequirementsMet :boolean, OutputX :integer, OutputY :integer, InputX :integer, InputY :integer, LastObjectAddedType :string|integer, CurrentFuel :integer, FuelCapacity :integer, Successfully :string }
---@param properties ConverterProperties|nil
---@return UnpackConverterProperties #
function Extensions.UnpackConverterProperties (properties)
    local successfully = properties ~= nil and properties[1] ~= nil
    if (not successfully) then
        return { Successfully = false }
    end

    -- hack
    ---@type ConverterProperties
    properties = properties or { }

    local result = {
        Successfully        = true,
        State               = properties[1],
        TileX               = properties[2],
        TileY               = properties[3],
        Rotation            = properties[4],
        Name                = properties[5],
        RequirementsMet     = properties[6],
        OutputX             = properties[7],
        OutputY             = properties[8],
        InputX              = properties[9],
        InputY              = properties[10],
        LastObjectAddedType = properties[11],
        CurrentFuel         = properties[12],
        FuelCapacity        = properties[13],
    }

    return result
end

--- func desc
---@param properties BuildingRequirements
---@return UnpackBuildingRequirementsList
function Extensions.UnpackBuildingRequirements (properties)
    local result = { Successfully = properties ~= nil }
    if (not result.Successfully) then
        return result
    end

    for _, value in pairs(properties) do
        local group = Tools.Dictionary.GetOrAddValue(result, value[4], { })
        group[#group + 1] = { Type = value[1], Capacity = value[2], Amount = value[3] }
    end

    return result
end

--- func desc
---@param id integer
---@return string
function Extensions.GetFullInformation(id)
    local category = ModObject.GetObjectCategory(id)
    local subCategory = ModObject.GetObjectSubcategory(id)
    local objectProperties = Extensions.UnpackObjectProperties(ModObject.GetObjectProperties(id))
    local buildingRequirements = Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(id))
    local converterProperties = Extensions.UnpackConverterProperties(ModConverter.GetConverterProperties(id))
    local storageInfo = Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(id))
    local durability = ModObject.GetObjectDurability(id)
    local message, isError StringFormat.UnpackStringFormat(
        "Id: %d\nCategory: %s\nSubcategory: %s\nDurability: %d\nObjectProperties:\n%s\nBuildingRequirements:\n%s\nConverterProperties:\n%s\nStorageInfo:\n%s",
        id,
        category,
        subCategory,
        durability,
        objectProperties,
        buildingRequirements,
        converterProperties,
        storageInfo
    )
    return message
end