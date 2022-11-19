INIT_MATERIALS = false
-- Wishlist
-- OVERFLOW PIPE (/pressure relief) -> when source side is full, move one if possible.
-- Transmitter Priority by name "Priority 1", "Priority 2"... 1 being most important.
-- Receiver Priority "Priority 1", "Priority 2"...etc
-- Priority: - Unprioritized? use level 50.

--- Used near exclusively for Steam Workshop and Mod information
function SteamDetails()
    ModDebug.ClearLog()
    Logging.LogInformation("SteamDetails")

    local description = [[
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
and https://steamcommunity.com/sharedfiles/filedetails/?id=2841552670

Source mod: https://github.com/VirRus77/StorageLinks

]]
    -- Setting of Steam details
    ModBase.SetSteamWorkshopDetails("Storage Links 2.0",
        description,
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

    -- ModObject.AddMaterialsToCache("Material")


    -- if(not INIT_MATERIALS) then
    --     ModObject.AddMaterialsToCache("Switch")
    --     INIT_MATERIALS = true
    -- end

    -- if (Settings.ReplaceOldBuildings.Value) then
    --     Buildings.CreateOldTypes()
    -- end

    -- Set some overall globals that determine if we want to use a TIMER, or callbacks.
    -- USE_EVENT_STYLE = ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION) and
    --     ModBase.ClassAndMethodExist('ModBuilding','RegisterForBuildingRenamedCallback')

end

--- Initial load function by game
function BeforeLoad()
    Logging.LogInformation("BeforeLoad")
    if (not IsSupportGameVersion()) then
        return
    end

    for _, value in pairs(Buildings.AllTypes) do
        ModBuilding.ShowBuildingAccessPoint(value.Type, value.AccessPoint ~= nil)
    end

    ModVariable.SetVariableForObjectAsInt(Buildings.Extractor.Type, "Unlocked", 0)

    -- for _, value in pairs(Decoratives.AllTypes) do
    --     ModBuilding.ShowBuildingAccessPoint(value.Type, false)
    -- end
    -- ModBuilding.ShowBuildingAccessPoint(Converters.Extractor.Type, true)
    -- BuildingsDependencyTree.SwitchAllLockState()

end

--- Only called on loading a game. [v134.23]
function AfterLoad_LoadedWorld()
    Logging.LogInformation("AfterLoad_LoadedWorld")
    if (not IsSupportGameVersion()) then
        return
    end

    Translates.SetNames()
    WORLD_LIMITS.Update ( ModTiles.GetMapLimits() )
end

--- Once a game has loaded key functionality, this is called.
function AfterLoad()
    Logging.LogInformation("AfterLoad")
    if (not IsSupportGameVersion()) then
        return
    end

    -- Remove all Decoratives
    for _, value in pairs(Decoratives.AllTypes) do
        local symbolIds = ModTiles.GetObjectUIDsOfType(value.Type, WORLD_LIMITS:Unpack())
        for _, symbolId in pairs(symbolIds) do
            ModObject.DestroyObject(symbolId)
        end
    end

    TIMERS_STACK:Clear()
    TIMERS_STACK:AddTimer  (Timer.new(5, BuildingsDependencyTree.SwitchAllLockState))
    TIMERS_STACK:AddTimer  (Timer.new(1, function() VIRTUAL_NETWORK:TimeCallback() end))

    Converters.UpdateState()
    BuildingsDependencyTree.SwitchAllLockState()
    BUILDING_CONTROLLER:RegistryTypes({
        BasicExtractor,
        Magnet,
        PumpBase,
        Transmitter,
        Switcher,
        InspectorBase
    })
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
            TIMERS_STACK:AppendDelta(timeDelta)
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