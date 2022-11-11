---@type number
SECONDS_BETWEEN_UNLOCK_CHECKS = 5

---@alias ItemType { Dependency :string[], Buildings :BuildingItem[] } #
---@type ItemType[] #
Buildings.LevelDependency = {
    {
        Dependency = {
            'MortarMixerCrude',
            'MortarMixerGood'
        },
        Buildings = Buildings.GoodTypes
    },
    {
        Dependency = {
            'MetalWorkbench'
        },
        Buildings = Buildings.SuperTypes
    },
}

--- func desc
---@param unlockBuildings string[]
---@param buildings BuildingItem[]
function SwitchLockBySelectedLevel(unlockBuildings, buildings)
    local stateUnlock = isBuildingUnlocked(unlockBuildings)
    local invertBuildings = GetBuildingsUnlockedState(buildings, not stateUnlock)
    local stateValue = 0;
    if (stateUnlock) then
        stateValue = 1;
    end

    -- if (GetTableLength(invertBuildings) > 0) then
    --     Logging.Log(
    --         serializeTable({
    --             stateUnlock = stateUnlock,
    --             invertBuildings = invertBuildings,
    --             stateValue = stateValue
    --         })
    --     )
    -- end

    for _, value in ipairs(invertBuildings) do
        ModVariable.SetVariableForObjectAsInt(value.Type, "Unlocked", stateValue)
    end
end

function SwitchLockByLevel()
    Logging.Log("SwitchLockByLevel")
    for index, value in ipairs(Buildings.LevelDependency) do
        SwitchLockBySelectedLevel(value.Dependency, value.Buildings)
    end
end

--- func desc
---@param buildings BuildingItem[]
---@param state boolean
---@return BuildingItem[]
function GetBuildingsUnlockedState(buildings, state)
    local result = { }
    for _, value in ipairs(buildings) do
        --local flag = ModQuest.IsObjectTypeUnlocked(value) == state
        local flag = (ModVariable.GetVariableForObjectAsInt(value.Type, "Unlocked") > 0) == state
        if (flag) then
            table.insert( result, value )
        end
    end
    return result
end