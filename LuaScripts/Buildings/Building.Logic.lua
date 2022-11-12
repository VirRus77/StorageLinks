---@type DependecyItem[] #
Buildings.Dependencies = {
    ---@type DependecyItem
    {
        Buildings = Buildings.GoodTypes,
        DependencyOn = {
            'MortarMixerCrude',
            'MortarMixerGood'
        }
    },
    ---@type DependecyItem
    {
        Buildings = Buildings.SuperTypes,
        DependencyOn = {
            'MetalWorkbench'
        }
    }
}

function Buildings.AddDependencies()
    for _, value in ipairs(Buildings.Dependencies) do
        BuildingsDependencyTree.AddDependency (value)
    end
end

---@alias MagnetSettingsItem{ CountOneTime :integer, Speed :integer}
---@type MagnetSettingsItem[] #
Buildings.MagnetSettings = {
    Crude = {
        CountOneTime = 1,
        Speed = 10,
    },
    Good = {
        CountOneTime = 5,
        Speed = 15,
    },
    Super = {
        CountOneTime = 25,
        Speed = 20,
    }
}

---@param buildingLevel BuildingLevels
function Buildings.GetMagnetSettings(buildingLevel)
    if (buildingLevel == BuildingLevels.Crude) then
        return Buildings.MagnetSettings.Crude
    end
    if (buildingLevel == BuildingLevels.Good) then
        return Buildings.MagnetSettings.Good
    end
    if (buildingLevel == BuildingLevels.Super) then
        return Buildings.MagnetSettings.Super
    end

    Logging.LogError("GetMagnetSettings(buildingLevel = %s). Unknown buildingLevel.", buildingLevel)
    return Buildings.MagnetSettings.Crude
end