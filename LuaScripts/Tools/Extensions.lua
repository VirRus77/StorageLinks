-- Unpack @{ObjectProperties}
---@alias UnpackObjectProperties { Type :string, TileX :integer, TileY:integer, Rotation :number, Name :string, Successfully :boolean, [1] :string, [2] :number, [3] :number, [4] :number, [5] :string } #
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
        -- Accept by index (Old style)
        [1]      = properties[1],
        [2]      = properties[2],
        [3]      = properties[3],
        [4]      = properties[4],
        [5]      = properties[5],
        
    }

    if (normalizeRotation == nil or normalizeRotation) then
        -- round the rotation to a whole number
        result.Rotation = math.floor(result.Rotation + 0.5)
    end

    return result
end

-- Unpack @{StorageInfo}
---@alias UnpackStorageInfo { TypeStores :string, AmountStored :integer, Capacity :integer, StorageType :string, Successfully :boolean, [1] :string, [2] :integer, [3] :integer, [4] :string } #
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

    ---@type UnpackStorageInfo
    local result = {
        Successfully = true,
        TypeStores   = properties[1],
        AmountStored = properties[2],
        Capacity     = properties[3],
        StorageType  = properties[4],
        -- Accept by index (Old style)
        [1] = properties[1],
        [2] = properties[2],
        [3] = properties[3],
        [4] = properties[4],
    }

    return result
end

--- Unpack @{ConverterProperties}
---@alias UnpackConverterProperties { State : "Idle"|"Converting"|"Creating"|"Cancelling", TileX :integer, TileY :integer, Rotation :number, Name :string, RequirementsMet :boolean, OutputX :integer, OutputY :integer, InputX :integer, InputY :integer, LastObjectAddedType :string|integer, CurrentFuel :integer, FuelCapacity :integer, Successfully :string,  [1] : "Idle"|"Converting"|"Creating"|"Cancelling", [2] :integer, [3] :integer, [4] :number, [5] :string, [6] :boolean, [7] :integer, [8] :integer, [9] :integer, [10] :integer, [11] :string|integer, [12] :integer, [13] :integer }
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
        -- Accept by index (Old style)
        [1]                 = properties[1],
        [2]                 = properties[2],
        [3]                 = properties[3],
        [4]                 = properties[4],
        [5]                 = properties[5],
        [6]                 = properties[6],
        [7]                 = properties[7],
        [8]                 = properties[8],
        [9]                 = properties[9],
        [10]                = properties[10],
        [11]                = properties[11],
        [12]                = properties[12],
        [13]                = properties[13],
    }

    return result
end