---@type number
SECONDS_BETWEEN_UNLOCK_CHECKS = 5
---@type Timer
UNLOCK_LEVEL_TIMER = nil

---@alias ItemType { Dependency :string[], Buildings :string[] } #
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

function SwitchLockBySelectedLevel(unlockBuildings, buildings)
    local stateUnlock = isBuildingUnlocked(unlockBuildings)
    local invertBuildings = GetBuildingsUnlockedState(buildings, not stateUnlock)
    local stateValue = 0;
    if (stateUnlock) then
        stateValue = 1;
    end

    if (GetTableLength(invertBuildings) > 0) then
        Logging.Log(
            serializeTable({
                stateUnlock = stateUnlock,
                invertBuildings = invertBuildings,
                stateValue = stateValue
            })
        )
    end

    for _, value in ipairs(invertBuildings) do
        ModVariable.SetVariableForObjectAsInt(value, "Unlocked", stateValue)
    end
end

function SwitchLockByLevel()
    Logging.Log("SwitchLockByLevel")
    for index, value in ipairs(Buildings.LevelDependency) do
        SwitchLockBySelectedLevel(value.Dependency, value.Buildings)
    end
end

function GetBuildingsUnlockedState(buildings, state)
    local result = { }
    for _, value in ipairs(buildings) do
        --local flag = ModQuest.IsObjectTypeUnlocked(value) == state
        local flag = (ModVariable.GetVariableForObjectAsInt(value, "Unlocked") > 0) == state
        if (flag) then
            table.insert( result, value )
        end
    end
    return result
end