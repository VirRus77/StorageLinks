---- LUA Annotations: https://github.com/sumneko/lua-language-server/wiki/Annotations

Constants = {
    ---@type string # Unique id.
    UniqueId = "4e4c1116edfc4608be374cb5d27ac1ac",
    ---@type table # List using models.
    Models = {
        MagnetCrude = "MagnetCrude",
        MagnetGood = "MagnetGood",
        MagnetSuper = "MagnetSuper",
    },
}

--- Add unique ID to name.
---@param name string # Name.
function Constants.UniqueName(name)
    -- Logging.Log("Constants.UniqueName", serializeTable({
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