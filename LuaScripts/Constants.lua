Constants = {
    UniqueId = "4e4c1116edfc4608be374cb5d27ac1ac",
    Models = {
        MagnetCrude = "MagnetCrude",
        MagnetGood = "MagnetGood",
        MagnetSuper = "MagnetSuper",
    },
}

--- Add unique ID to name.
---@param name string # Name.
function Constants.UniqueName(name)
    return name.."_"..Constants.UniqueId
end