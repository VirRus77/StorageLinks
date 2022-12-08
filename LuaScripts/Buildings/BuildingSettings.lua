--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class SettingPeriod
---@field UpdatePeriod number
SettingPeriod = {}

---@generic T :SettingPeriod
---@class BuildingSettingItem<T>
---@field Type ReferenceValue<string>
---@field Settings SettingPeriod
BuildingSettingItem = {}


---@generic T
----@alias BuildingSettingItem<T> { Type :ReferenceValue<string>, Settings :T }
---@type table<string, BuildingSettingItem[]>
BuildingSettings = {
    ---@type BuildingSettingItem<InspectorSettingsItem>[]
    Inspector = {
        {
            Type = Buildings.Inspector.Type,
            ---@alias InspectorSettingsItem { UpdatePeriod :number, SwitchState :boolean, InspectPoint :Point } #
            Settings = {
                UpdatePeriod = 1 / 4,
                SwitchState = true,
                InspectPoint = Point.new(0, -1)
            }
        }
    },

    ---@type BuildingSettingItem<MagnetSettingsItem2>[] #
    Magnets = {
        {
            Type = Buildings.MagnetCrude.Type,
            ---@alias MagnetSettingsItem2 { UpdatePeriod :number, CountOneTime :integer, Speed :integer, Height :integer, Area :Area, StackLimit :integer, OutputPoint :Point }
            Settings = {
                UpdatePeriod = 1 / 4,
                CountOneTime = 1,
                Speed = 10,
                Height = 10,
                Area = Area.new(0, 0, 10, 10),
                OutputPoint = Point.new(1, 0),
            },
        },
        {
            Type = Buildings.MagnetGood.Type,
            Settings = {
                UpdatePeriod = 1 / 4,
                CountOneTime = 5,
                Speed = 15,
                Height = 10,
                Area = Area.new(0, 0, 10, 10),
                OutputPoint = Point.new(1, 0),
            },
        },
        {
            Type = Buildings.MagnetSuper.Type,
            Settings = {
                UpdatePeriod = 1 / 4,
                CountOneTime = 15,
                Speed = 20,
                Height = 10,
                Area = Area.new(0, 0, 10, 10),
                OutputPoint = Point.new(1, 0),
            },
        }
    },

    ---@type BuildingSettingItem<PumpSettingsItem>[] #
    Pump = {
        {
            Type = Buildings.PumpCrude.Type,
            ---@alias PumpSettingsItem { UpdatePeriod :number, MaxTransferPercentOneTime :integer, LogicType: "Transfer"|"Overflow"|"Balancer", InputPoint :Point, OutputPoint :Point }
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 1,
                LogicType = "Transfer",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
        {
            Type = Buildings.PumpGood.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 5,
                LogicType = "Transfer",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
        {
            Type = Buildings.PumpSuper.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Transfer",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
        {
            Type = Buildings.PumpSuperLong.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Transfer",
                InputPoint  = Point.new(0, -2),
                OutputPoint = Point.new(0,  2),
            },
        },
    },

    ---@type BuildingSettingItem<PumpSettingsItem>[] #
    OverflowPump = {
        {
            Type = Buildings.OverflowPumpCrude.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 1,
                LogicType = "Overflow",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
        {
            Type = Buildings.OverflowPumpGood.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 5,
                LogicType = "Overflow",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
        {
            Type = Buildings.OverflowPumpSuper.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Overflow",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
    },

    ---@type BuildingSettingItem<PumpSettingsItem>[] #
    BalancerPump = {
        {
            Type = Buildings.BalancerCrude.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 1,
                LogicType = "Balancer",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
        {
            Type = Buildings.BalancerGood.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 5,
                LogicType = "Balancer",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
        {
            Type = Buildings.BalancerSuper.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Balancer",
                InputPoint  = Point.new(0, -1),
                OutputPoint = Point.new(0,  1),
            },
        },
        {
            Type = Buildings.BalancerSuperLong.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferPercentOneTime = 10,
                LogicType = "Balancer",
                InputPoint  = Point.new(0, -2),
                OutputPoint = Point.new(0,  2),
            },
        },
    },

    ---@type BuildingSettingItem<TransmitterSettingsItem>[] #
    Transmitter = {
        {
            Type = Buildings.TransmitterCrude.Type,
            ---@alias TransmitterSettingsItem { UpdatePeriod :number, MaxTransferOneTime :integer, InputPoint? :Point|nil, OutputPoint? :Point|nil }
            Settings = {
                UpdatePeriod = 1,
                MaxTransferOneTime = 1,
                InputPoint  = Point.new(0, -1),
                OutputPoint = nil,
            },
        },
        {
            Type = Buildings.TransmitterGood.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferOneTime = 5,
                InputPoint  = Point.new(0, -1),
                OutputPoint = nil,
            },
        },
        {
            Type = Buildings.TransmitterSuper.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferOneTime = 15,
                InputPoint  = Point.new(0, -1),
                OutputPoint = nil,
            },
        },
    },

    ---@type BuildingSettingItem<TransmitterSettingsItem>[] #
    Receiver = {
        {
            Type = Buildings.ReceiverCrude.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferOneTime = 1,
                InputPoint  = nil,
                OutputPoint = Point.new(0, 1),
            },
        },
        {
            Type = Buildings.ReceiverGood.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferOneTime = 5,
                InputPoint  = nil,
                OutputPoint = Point.new(0, 1),
            },
        },
        {
            Type = Buildings.ReceiverSuper.Type,
            Settings = {
                UpdatePeriod = 1,
                MaxTransferOneTime = 15,
                InputPoint  = nil,
                OutputPoint = Point.new(0, 1),
            },
        },
    },

    ---@type BuildingSettingItem<SwittcherSettingsItem>[]
    Switcher = {
        {
            Type = Buildings.SwitchSuper.Type,
            ---@alias SwittcherSettingsItem { UpdatePeriod :number, SwitchState :boolean } #
            Settings = {
                UpdatePeriod = 1 / 4,
                SwitchState = true
            }
        }
    },
}

--- GetSettings by building type.
---@param buildingType string # Builfing type.
---@return table|nil
function BuildingSettings.GetSettingsByType(buildingType)
    for _, settings in pairs(BuildingSettings) do
        if (type(settings) ~= "function") then
            --Logging.LogDebug("BuildingSettings.GetSettingsByType %s K:%s S:%s", buildingType, _, settings)
            for _, settingByType in ipairs(settings) do
                if (settingByType.Type.Value == buildingType)then
                    return settingByType.Settings
                end
            end
        end
    end

    Logging.LogWarning("BuildingSettings.GetSettingsByType %s not found settings", buildingType)
    return nil
end

--- GetSettings by building type.
---@param buildingType { Type :ReferenceValue<string> } # Builfing type.
---@return table|nil
function BuildingSettings.GetSettingsByReferenceType(buildingType)
    for _, settings in pairs(BuildingSettings) do
        if (type(settings) ~= "function") then
            --Logging.LogDebug("BuildingSettings.GetSettingsByType %s K:%s S:%s", buildingType, _, settings)
            for _, settingByType in ipairs(settings) do
                if (settingByType.Type.Value == buildingType.Type.Value)then
                    return settingByType.Settings
                end
            end
        end
    end

    Logging.LogWarning("BuildingSettings.GetSettingsByType %s not found settings", buildingType)
    return nil
end