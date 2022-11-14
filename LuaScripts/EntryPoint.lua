
-- Wishlist
-- OVERFLOW PIPE (/pressure relief) -> when source side is full, move one if possible.
-- Transmitter Priority by name "Priority 1", "Priority 2"... 1 being most important.
-- Receiver Priority "Priority 1", "Priority 2"...etc
-- Priority: - Unprioritized? use level 50.

--- Used near exclusively for Steam Workshop and Mod information
function SteamDetails()
    ModDebug.ClearLog()
    Logging.LogInformation("SteamDetails")

    -- Setting of Steam details
    ModBase.SetSteamWorkshopDetails("Storage Links 2.0", [[
A set of links that can hook storages together. This is a great minimal mod.

=== Crude, Good, Super ===
 - Crude _____ are available at all times, can move up to 1 item every 5 seconds.
 - Good _____ are available once a Mortar Mixer is built and can move up to 5 items every second.
 - Super _____ are available once a Steam Hammer is built and can move unlimited items per second.
 - All levels have the capability to be SWITCHED on or off using the 'Super Switch (SL)'

=== Balancer (SL) ===
 - Keeps two storages of similiar type balanced.
 - Long version functions exactly the same.

=== Pump (SL) ===
 - Pumps product into the storage indicated by the arrow.
 - Long version functions exactly the same.
 
=== Overflow Pump (SL) ===
 - Only operates if the source side is at max capacity.
 - Removes the qty as defined below:
 - Crude: 1% (rounded up).
 - Good: 5% (rounded up).
 - Super: 10% (rounded up).
 
=== Receiver (SL) ===
 - Requests and will receive whatever it can of the type that fits into this storage.
 - If there are multiple receivers per type of item stored, the emptiest storage is always dealt with first.
 
=== Transmitter (SL) ===
 - Transmits any requested types, if it can from the attached storage.
 
=== Magnet (SL) ===
 - Attach to a storage. Collects items that fit in storage, within 10x10 around magnet.
 - If you can name the magnet, setting name to '80x80' will collect items 80 tiles wide by 80 tiles tall.
 
=== Switch (SL) ===
 - Name the link you wish to control with a name like "sw[GROUP NAME]" (Use "L" key.).
 - Build the switch anywhere.
 - Name the SWITCH like ">GROUP NAME". (always start with ">")
 - You can only have one switch per group name. (use anything you want for group name)

~= Enjoy =~

Fork: https://steamcommunity.com/sharedfiles/filedetails/?id=2087715431
https://steamcommunity.com/sharedfiles/filedetails/?id=2841552670
      
Source mod: https://github.com/VirRus77/StorageLinks

    ]],
    { "transport", "storage", "move", "transmitter", "receiver", "magnet", "ejector" },
    "logo2.jpg"
)

--~~ Future ~~
-- - Be able to transfer to/from train carriages. As of 136.24, the Modding API does not support interacting with train carriages.

end

--- Here you can expose any variables to the game for settings
function Expose()
    Logging.LogInformation("Expose")

    if (not IsSupportGameVersion()) then
        ModUI.ShowPopup(
            "Storage Links 2.0 (Error)",
            string.format("%s\nUnsupport version game %s. Need before %s.", "Storage Links 2.0", ModBase.GetGameVersion(), VERSION_WITH_CLASSMETHODCHECK_FUNCTION))
        return
    end

    ModBase.ExposeVariable(Settings.DebugMode.Name, Settings.DebugMode.Value, Settings.ExposedVariableCallback)
    -- ModBase.ExposeVariable(Settings.ReplaceOldBuildings.Name, Settings.ReplaceOldBuildings.Value, Settings.ExposedVariableCallback)
    ModBase.ExposeKeybinding(Settings.DebugMove.Name, Settings.DebugMove.Value, Settings.ExposedKeyCallback)
end

--- Used to create any custom converters or buildings
function Creation()
    ModDebug.ClearLog()
    Logging.LogInformation("Creation (ver. %s)", ModBase.GetGameVersion())
    if (not IsSupportGameVersion()) then
        return
    end

    Buildings:UpdateTypeByUniq()
    Decoratives:UpdateTypeByUniq()
    Converters:UpdateTypeByUniq()
    Buildings.CreateAll()
    Converters.CreateAll()
    BuildingsDependencyTree.SwitchAllLockState()

    if (Settings.ReplaceOldBuildings.Value) then
        Buildings.CreateOldTypes()
    end

    -- Set some overall globals that determine if we want to use a TIMER, or callbacks.
    USE_EVENT_STYLE = ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION) and
        ModBase.ClassAndMethodExist('ModBuilding','RegisterForBuildingRenamedCallback')

end

--- Initial load function by game
function BeforeLoad()
    Logging.LogInformation("BeforeLoad")
    if (not IsSupportGameVersion()) then
        return
    end

    Translates.SetNames()
    -- -- Pump
    -- ModVariable.SetVariableForBuildingUpgrade("Crude Pump (SL)", "Good Pump (SL)" )
    -- ModVariable.SetVariableForBuildingUpgrade("Good Pump (SL)" , "Super Pump (SL)")

    -- -- Overflow Pump
    -- ModVariable.SetVariableForBuildingUpgrade("Crude Overflow Pump (SL)", "Good Overflow Pump (SL)" )
    -- ModVariable.SetVariableForBuildingUpgrade("Good Overflow Pump (SL)" , "Super Overflow Pump (SL)")


    -- -- Balancer
    -- ModVariable.SetVariableForBuildingUpgrade("Crude Balancer (SL)", "Good Balancer (SL)" )
    -- ModVariable.SetVariableForBuildingUpgrade("Good Balancer (SL)" , "Super Balancer (SL)")

    -- -- Magnet
    -- ModVariable.SetVariableForBuildingUpgrade("Crude Magnet (SL)", "Good Magnet (SL)" )
    -- ModVariable.SetVariableForBuildingUpgrade("Good Magnet (SL)" , "Super Magnet (SL)")

    -- -- Transmitter
    -- ModVariable.SetVariableForBuildingUpgrade("Crude Transmitter (SL)", "Good Transmitter (SL)" )
    -- ModVariable.SetVariableForBuildingUpgrade("Good Transmitter (SL)" , "Super Transmitter (SL)")

    -- -- Receiver
    -- ModVariable.SetVariableForBuildingUpgrade("Crude Receiver (SL)", "Good Receiver (SL)" )
    -- ModVariable.SetVariableForBuildingUpgrade("Good Receiver (SL)" , "Super Receiver (SL)")

    -- Access Points
    -- ModBuilding.ShowBuildingAccessPoint("Crude Pump (SL)"			, true)
    -- ModBuilding.ShowBuildingAccessPoint("Good Pump (SL)" 			, true)
    -- ModBuilding.ShowBuildingAccessPoint("Crude Overflow Pump (SL)"	, true)
    -- ModBuilding.ShowBuildingAccessPoint("Good Overflow Pump (SL)" 	, true)
    -- ModBuilding.ShowBuildingAccessPoint("Crude Balancer (SL)"		, true)
    -- ModBuilding.ShowBuildingAccessPoint("Good Balancer (SL)"		, true)
    -- ModBuilding.ShowBuildingAccessPoint("Crude Magnet (SL)"			, true)
    -- ModBuilding.ShowBuildingAccessPoint("Good Magnet (SL)"			, true)
    -- ModBuilding.ShowBuildingAccessPoint("Crude Transmitter (SL)"	, true)
    -- ModBuilding.ShowBuildingAccessPoint("Good Transmitter (SL)"		, true)
    -- ModBuilding.ShowBuildingAccessPoint("Crude Receiver (SL)"		, true)
    -- ModBuilding.ShowBuildingAccessPoint("Good Receiver (SL)"		, true)

    --lockLevels()
    --checkUnlockLevels()

end

--- Only called on loading a game. [v134.23]
function AfterLoad_LoadedWorld()
    Logging.LogInformation("AfterLoad_LoadedWorld")
    if (not IsSupportGameVersion()) then
        return
    end

    -- Reset caches
    LINK_UIDS = { }
    STORAGE_UIDS = { }
    WORLD_LIMITS.Update ( ModTiles.GetMapLimits() )
    --DiscoveredAllMap:Go()
    --MakeDevelopMap:Make()

    -- When world is loaded, find Magnets!
    -- discoverUnknownMagnets()
end

--- Once a game has loaded key functionality, this is called.
function AfterLoad()
    Logging.LogInformation("AfterLoad")
    if (not IsSupportGameVersion()) then
        return
    end

    TimersStack.Clear()
    TimersStack.AddTimer  (Timer.new(5, BuildingsDependencyTree.SwitchAllLockState))
    TimersStack.AddTimers (MakeTimers (BuildingLevels.Crude))
    TimersStack.AddTimers (MakeTimers (BuildingLevels.Good))
    TimersStack.AddTimers (MakeTimers (BuildingLevels.Super))

    if (Settings.ReplaceOldBuildings.Value) then
        for _, value in ipairs(Buildings.MappingOldTypes) do
            ModVariable.SetVariableForObjectAsInt(value.OldType, "Unlocked", 0)
        end
        for _, value in ipairs(Decoratives.MappingOldTypes) do
            ModVariable.SetVariableForObjectAsInt(value.OldType, "Unlocked", 0)
        end
    end

    Converters.UpdateState()

    BuildingsDependencyTree.SwitchAllLockState()
    BuildingController.Initialize()
    ReplaceOldBuildings()

    --swapOldNamesToNew()
end

--- Only called when creating a game. [v134.23]
function AfterLoad_CreatedWorld()
    Logging.LogInformation("AfterLoad_CreatedWorld")
    if (not IsSupportGameVersion()) then
        return
    end
end

--- Called every frame, see also Time.deltaTime
---@param timeDelta number
function OnUpdate(timeDelta)
    if (not IsSupportGameVersion()) then
        return
    end
    -- Called on every cycle!
    OBJECTS_IN_FLIGHT:Check()

    if (not Settings.DebugMode.Value) then
        if(ModBase.GetGameState() == "Normal") then
            TimersStack:AppendDelta(timeDelta)
        end
    end
end

--- func desc
---@return boolean
function IsSupportGameVersion()
    local support = ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION)

    if (not support) then
        Logging.LogFatal("Unsupport version game %s. Need before %s.", ModBase.GetGameVersion(), VERSION_WITH_CLASSMETHODCHECK_FUNCTION)
    end

    return support
end