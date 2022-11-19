--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


BuildingsDependencyTree = {
    ---@alias DependecyItem { Buildings :{ Type : string }[], DependencyOn :string[]|nil } #
    ---@type DependecyItem[] #
    Dependencies = { }
}

BuildingsDependencyTree.Dependencies = {
    ---@type DependecyItem
    {
        Buildings = {
            Buildings.MagnetGood,
            Buildings.PumpGood,
            Buildings.OverflowPumpGood,
            Buildings.BalancerGood,
            Buildings.TransmitterGood,
            Buildings.ReceiverGood
        },
        DependencyOn = {
            'MortarMixerCrude',
            'MortarMixerGood'
        }
    },
    ---@type DependecyItem
    {
        Buildings = {
            Buildings.MagnetSuper,
            Buildings.PumpSuper,
            Buildings.OverflowPumpSuper,
            Buildings.BalancerSuper,
            Buildings.TransmitterSuper,
            Buildings.ReceiverSuper
        },
        DependencyOn = {
            'MetalWorkbench'
        }
    },
    -- ---@type DependecyItem
    -- {
    --     Buildings = {
    --         Converters.Extractor
    --     },
    --     DependencyOn = nil
    -- }
}

--- Check any buildings in buildingTable unlock
---@param buildingTable string[]
function BuildingsDependencyTree.IsAnyBuildingUnlocked(buildingTable)
    if (buildingTable == nil or buildingTable[1] ~= nil) then
        return false
    end

    for _, value in ipairs(buildingTable) do
        if (ModVariable.GetVariableForObjectAsInt(value, "Unlocked") > 0) then
            return true
        end
    end

    return false
end

---@param buildingTable string[]|nil
function BuildingsDependencyTree.IsAllBuildingUnlocked(buildingTable)
    if (buildingTable == nil or #buildingTable == 0) then
        return true
    end

    for _, value in ipairs(buildingTable) do
        local lockValue = (ModVariable.GetVariableForObjectAsInt(value, "Unlocked"))
        if (not (lockValue > 0)) then
            Logging.LogDebug("BuildingsDependencyTree.IsAllBuildingUnlocked %s %d",value, lockValue)
            return false
        end
    end

    return true
end

--- Switch lock all dependency buildings.
function BuildingsDependencyTree.SwitchAllLockState()
    Logging.LogDebug("BuildingsDependencyTree.SwitchAllLockState")
    for _, dependency in ipairs(BuildingsDependencyTree.Dependencies) do
        BuildingsDependencyTree.SwitchLockByUnlockBuildings (dependency)
    end
end

--- Switch lock dependency buildings.
---@param dependecy DependecyItem #
function BuildingsDependencyTree.SwitchLockByUnlockBuildings(dependecy)
    local stateUnlock = BuildingsDependencyTree.IsAllBuildingUnlocked(dependecy.DependencyOn)
    local invertBuildings = BuildingsDependencyTree.GetBuildingsUnlockedState(dependecy.Buildings, not stateUnlock)
    -- Logging.LogDebug("BuildingsDependencyTree.SwitchLockByUnlockBuildings invertBuildings:\n%s", invertBuildings)

    ---@type integer
    local stateValue = 0;
    if (stateUnlock) then
        stateValue = 1;
    end

    if (Settings.DebugMode.Value and (#invertBuildings > 0)) then
        Logging.LogDebug("BuildingsDependencyTree.SwitchLockByUnlockBuildings\n%s",
            serializeTable({
                stateUnlock = stateUnlock,
                invertBuildings = invertBuildings,
                stateValue = stateValue
            })
        )
    end

    for _, value in pairs(invertBuildings) do        
        ModVariable.SetVariableForObjectAsInt(value.Type, "Unlocked", stateValue)
        -- Logging.LogDebug("BuildingsDependencyTree.SwitchLockByUnlockBuildings %s %d == %d", value.Type, stateValue, ModVariable.GetVariableForObjectAsInt(value.Type, "Unlocked"))
    end
end

--- Find value by @{state}.
---@param buildings BuildingItem[] #
---@param state boolean # Find value state.
---@return BuildingItem[] #
function BuildingsDependencyTree.GetBuildingsUnlockedState(buildings, state)
    local result = { }
    for _, value in ipairs(buildings) do
        local lockState = ModVariable.GetVariableForObjectAsInt(value.Type, "Unlocked")
        local flag = (lockState > 0) == state
        if (flag) then
            result[#result + 1] = value
        end
    end
    return result
end

--- func desc
---@param dependecy DependecyItem #
function BuildingsDependencyTree.AddDependency(dependecy)
    table.insert (BuildingsDependencyTree.Dependencies, dependecy)
end
