---- LUA Annotations: https://github.com/sumneko/lua-language-server/wiki/Annotations

Constants = {
    ---@type string # Unique id.
    UniqueId = "4e4c1116edfc4608be374cb5d27ac1ac",
    ---@type table # List using models.
    Models = {
        MagnetCrude = "MagnetCrude",
        MagnetGood = "MagnetGood",
        MagnetSuper = "MagnetSuper",
    }
}

--- Add unique ID to name.
---@param name string # Name.
function Constants.UniqueName(name)
    -- Logging.LogDebug("Constants.UniqueName", serializeTable({
    --         name = name,
    --         ConstantsUniqueId = Constants.UniqueId
    --     })
    -- )
    return name.."_"..Constants.UniqueId
end

---@enum BuildingLevels #
BuildingLevels = {
    Crude = "Crude",
    Good = "Good",
    Super = "Super"
}

---@type table<RequirementType|"Storage", integer>
OrderRequireType = {
    ["Fuel"] = 0,
    ["Water"] = 1,
    ["Ingredient"] = 2,
    ["Heart"] = 3,
    ["Hay"] = 4,
    ["Storage"] = 5
}

OrderFuel = {
    ["Charcoal"] = 0,
    ["Coal"] = 1,
    ["Log"] = 2,
    ["Plank"] = 3,
    ["Pole"] = 4,
    ["Stick"] = 5
}