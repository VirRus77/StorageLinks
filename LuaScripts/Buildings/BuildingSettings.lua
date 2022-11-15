--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@alias BuildingSettingItem { Type : { Type :string }, Settings :table }
---@type table<string, BuildingSettingItem[]>
BuildingSettings = {
    ---@type BuildingSettingItem[] #
    Magnets = {
        {
            Type = Buildings.MagnetCrude,
            ---@alias MagnetSettingsItem2 { UpdatePeriod :number, CountOneTime :integer, Speed :integer, Height :integer, Area :Area, StackLimit :integer }
            Settings = {
                UpdatePeriod = 1 / 4,
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
                UpdatePeriod = 1 / 4,
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

    ---@type PumpSettingsItem[] #
    Pump = {
        {
            Type = Buildings.PumpCrude,
            ---@alias PumpSettingsItem { UpdatePeriod :number, MaxTransferPercentOneTime :integer, LogicType: "Transfer"|"Overflow"|"Balancer", InputPoint? :Point, OutputPoint? :Point }
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 1,
                LogicType = "Transfer",
            },
        },
        {
            Type = Buildings.PumpGood,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 5,
                LogicType = "Transfer",
            },
        },
        {
            Type = Buildings.PumpSuper,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Transfer",
            },
        },
        {
            Type = Buildings.PumpSuperLong,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Transfer",
                InputPoint  = Point.new(0, -2),
                OutputPoint = Point.new(0,  2),
            },
        },
    },

    ---@type PumpSettingsItem[] #
    OverflowPump = {
        {
            Type = Buildings.OverflowPumpCrude,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 1,
                LogicType = "Overflow",
            },
        },
        {
            Type = Buildings.OverflowPumpGood,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 5,
                LogicType = "Overflow",
            },
        },
        {
            Type = Buildings.OverflowPumpSuper,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Overflow",
            },
        },
    },

    ---@type PumpSettingsItem[] #
    BalancerPump = {
        {
            Type = Buildings.BalancerCrude,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 1,
                LogicType = "Balancer",
            },
        },
        {
            Type = Buildings.BalancerGood,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 5,
                LogicType = "Balancer",
            },
        },
        {
            Type = Buildings.BalancerSuper,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Balancer",
            },
        },
        {
            Type = Buildings.BalancerSuperLong,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Balancer",
                InputPoint  = Point.new(0, -2),
                OutputPoint = Point.new(0,  2),
            },
        },
    },

    ---@type TransmitterSettingsItem[] #
    Transmitter = {
        {
            Type = Buildings.TransmitterCrude,
            ---@alias TransmitterSettingsItem { UpdatePeriod :number, MaxTransferPercentOneTime :integer, InputPoint? :Point, OutputPoint? :Point }
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 1,
                InputPoint  = Point.new(0, -1),
                OutputPoint = nil,
            },
        },
        {
            Type = Buildings.TransmitterGood,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 5,
                InputPoint  = Point.new(0, -1),
                OutputPoint = nil,
            },
        },
        {
            Type = Buildings.TransmitterSuper,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                InputPoint  = Point.new(0, -1),
                OutputPoint = nil,
            },
        },
    },

    ---@type TransmitterSettingsItem[] #
    Receiver = {
        {
            Type = Buildings.ReceiverCrude,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 1,
                InputPoint  = nil,
                OutputPoint = Point.new(0, 1),
            },
        },
        {
            Type = Buildings.ReceiverGood,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 5,
                InputPoint  = nil,
                OutputPoint = Point.new(0, 1),
            },
        },
        {
            Type = Buildings.ReceiverSuper,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                InputPoint  = nil,
                OutputPoint = Point.new(0, 1),
            },
        },
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



--- GetSettings by building type.
---@param buildingType { Type :string } # Builfing type.
---@return table|nil
function BuildingSettings.GetSettingsByReferenceType(buildingType)
    for _, settings in pairs(BuildingSettings) do
        if(type(settings) ~= "function") then
            --Logging.LogDebug("BuildingSettings.GetSettingsByType %s K:%s S:%s", buildingType, _, settings)
            for _, settingByType in ipairs(settings) do
                if (settingByType.Type.Type == buildingType.Type)then
                    return settingByType.Settings
                end
            end
        end
    end

    Logging.LogWarning("BuildingSettings.GetSettingsByType %s not found settings", buildingType)
    return nil
end