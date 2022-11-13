--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@alias BuildingSettingItem { Type : { Type :string }, Settings :table }
---@type table<string, BuildingSettingItem[]>
BuildingSettings = {
    ---@type BuildingSettingItem[]
    Magnets = {
        {
            Type = Buildings.MagnetCrude,
            ---@alias MagnetSettingsItem2 { CountOneTime :integer, Speed :integer, Height :integer, Area :Area, StackLimit :integer, UpdatePeriod :number }
            Settings = {
                UpdatePeriod = 5,
                CountOneTime = 1,
                Speed = 10,
                Height = 10,
                Area = Area.new(0, 0, 10, 10),
                StackLimit = 5,
            },
        },
        {
            Type = Buildings.MagnetGood,
            Settings = {
                UpdatePeriod = 1,
                CountOneTime = 5,
                Speed = 15,
                Height = 10,
                Area = Area.new(0, 0, 14, 14),
                StackLimit = 10
            },
        },
        {
            Type = Buildings.MagnetSuper,
            Settings = {
                UpdatePeriod = 1 / 4,
                CountOneTime = 25,
                Speed = 20,
                Height = 10,
                Area = Area.new(0, 0, 20, 20),
                StackLimit = 15
            },
        }
    },
}

--- GetSettings by building type.
---@param buildingType string # Builfing type.
---@return table|nil
function BuildingSettings.GetSettingsByType(buildingType)
    for _, settings in pairs(BuildingSettings) do
        if(type(settings) ~= "function") then
            --Logging.LogDebug("BuildingSettings.GetSettingsByType %s K:%s S:%s", buildingType, _, settings)
            for _, settingByType in ipairs(settings) do
                if (settingByType.Type.Type == buildingType)then
                    return settingByType.Settings
                end
            end
        end
    end

    Logging.LogWarning("BuildingSettings.GetSettingsByType %s not found settings", buildingType)
    return nil
end
