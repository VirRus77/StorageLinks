-- Unpack @{ObjectProperties}
---@alias UnpackObjectProperties { Successfully :boolean, Type :string, TileX :integer, TileY:integer, Rotation:number, Name :string } #
---@param properties ObjectProperties|nil #
---@param normalizeRotation? boolean # Dafault true
---@return UnpackObjectProperties #
function UnpackObjectProperties(properties, normalizeRotation)
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
---@alias UnpackStorageInfo { Successfully :boolean, TypeStores :string, AmountStored :integer, Capacity :integer, TypeStorage :string } #
---@param properties StorageInfo|nil #
---@return UnpackStorageInfo #
function UnpackStorageInfo (properties)
    ---{[1] :string, [2] :integer, [3] :integer, [4] :string} # Properties [1]=Object It Stores, [2]=Amount Stored, [3]=Capacity, [4]=Type Of Storage
    local successfully = properties ~= nil and properties[1] ~= nil
    if (not successfully) then
        return { Successfully = false }
    end

    -- hack
    ---@type StorageInfo
    properties = properties or { }

    local result = {
        Successfully = true,
        TypeStores   = properties[1],
        AmountStored = properties[2],
        Capacity     = properties[3],
        TypeStorage  = properties[4]
    }

    return result
end

--- Unpack @{ConverterProperties}
---@alias UnpackConverterProperties { State : "Idle"|"Converting"|"Creating"|"Cancelling", TileX :integer, TileY :integer, Rotation :number, Name :string, RequirementsMet :boolean, OutputX :integer, OutputY :integer, InputX :integer, InputY :integer, LastObjectAddedType :string|integer, CurrentFuel :integer, FuelCapacity :integer }
---@param properties ConverterProperties|nil
---@return UnpackConverterProperties #
function UnpackConverterProperties (properties)
    local successfully = properties ~= nil and properties[1] ~= nil
    if (not successfully) then
        return { Successfully = false }
    end

    -- hack
    ---@type ConverterProperties
    properties = properties or { }

    local result = {
        Successfully = true,
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