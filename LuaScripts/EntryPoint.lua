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
===  ENGLISH (Google translate)
A set of links that can hook storages together. This is a great minimal mod.

=== Crude, Good, Super ===
 - Crude _____ are available at any time, you can move up to 1 item every second.
 - Good _____ are available after building a mortar mixer and can move up to 5 items every second.
 - Super _____ are available after building a steam hammer and can move 15 items per second.
 - All levels can be turned ON or OFF with "Super Switch (SL)" or "Inspector".

=== Balancer (SL) ===
 - Keeps the balance of two storages of the same type.
 - The long version works exactly the same.

=== Pump (SL) ===
 - Transfers the product to the storage indicated by the arrow.
 - The long version works exactly the same.
 
=== Bypass pump (SL) ===
 - Only works if the source side is at maximum power.
 - Removes quantity as defined below:
 - Raw: 1% (rounded up).
 - Good: 5% (rounded up).
 - Super: 10% (rounded up).
 
=== Receiver (SL) ===
 - Requests and will receive everything it can, of the type that is placed in this store.
 - If there are multiple recipients for each stored item type, the most empty storage is always processed first.
 
=== Transmitter (SL) ===
 - Passes any requested types, if possible, from the attached store.
 
=== Magnet (SL) ===
 - Attach to storage. Gathers items that fit in storage within 11x11 around the magnet.
 - If you name the magnet by setting the name to "80x80", you will collect items that are 80 tiles wide and 80 tiles high.
 - If you name the magnet by setting the name to "{10,12;20,23}", you will collect items in that area.
 - Raw: Attracts 1 item at a time.
 - Good: Attracts 5 items at a time.
 - Super: Attracts 15 items at a time.
 
=== Switch (SL) ===
 - The link you want to manage, for example: "[GROUP NAME]" (use the "L" key) enter in the name of the building (mod buildings only).
 - Build a switch anywhere.
 - Add in the name of the SWITCH, for example "[GROUP NAME]".
 - You can have as many switches or inspectors for each group name as you want (when any one is triggered, the group logic will stop). (use any group name)

=== Inspector (SL) ===
 - The link you want to manage, for example: "[GROUP NAME]" (use the "L" key) enter in the name of the building (mod buildings only).
 - Build an inspector in any place where you want to control the location of the object (for example, the exit of the constructor).
 - Add in the name of the INSPECTOR, for example "[GROUP NAME]".
 - You can have as many switches or inspectors for each group name as you want (when any one is triggered, the group logic will stop). (use any group name)

=== Support languages ===
 - English
 - Russian
 - German (thanks [url=https://steamcommunity.com/id/Lord_Junes]Lord_Junes[/url])
 - another (write author translate) ;)

~= Enjoy =~

Fork abandoned mods: https://steamcommunity.com/sharedfiles/filedetails/?id=2087715431
and https://steamcommunity.com/sharedfiles/filedetails/?id=2841552670

Source mod: https://github.com/VirRus77/StorageLinks

]]
    -- Setting of Steam details
    ModBase.SetSteamWorkshopDetails("Storage Links 2.0",
        description,
        { "transport", "storage", "move", "transmitter", "receiver", "magnet" },
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
    CACHE_ITEM_INFO:Clear()

    ModObject.AddMaterialsToCache("Materials")
    -- Buildings:UpdateTypeByUniq()
    -- Decoratives:UpdateTypeByUniq()
    -- Converters:UpdateTypeByUniq()
    -- Buildings.CreateAll()
    -- Converters.CreateAll()

    -- ModObject.AddMaterialsToCache("Material")


    -- if (not INIT_MATERIALS) then
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
        ModBuilding.ShowBuildingAccessPoint(value.Type.Value, value.AccessPoint ~= nil)
    end

    Translates.SetNames()

    -- Disable Extractor.
    ModVariable.SetVariableForObjectAsInt(Buildings.Extractor.Type.Value, "Unlocked", 0)

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
end

--- Once a game has loaded key functionality, this is called.
function AfterLoad()
    Logging.LogInformation("AfterLoad")
    if (not IsSupportGameVersion()) then
        return
    end

    HASH_TABLES:Clear()
    WORLD_LIMITS:Update ( ModTiles.GetMapLimits() )
    FIRE_WALL:Clear()
    VIRTUAL_NETWORK:Clear()
    OBJECTS_IN_FLIGHT:Clear()
    TIMERS_STACK:Clear()
    BUILDING_CONTROLLER = BuildingController.new(TIMERS_STACK, FIRE_WALL)
    CACHE_ITEM_INFO:Clear()
    TILE_CONTROLLER:Clear()
    Utils.AddInspectors(TILE_CONTROLLER)

    -- Remove all Decoratives
    for _, value in pairs(Decoratives.AllTypes) do
        Logging.LogDebug("AfterLoad: %s, WORLD_LIMITS: %s", value, WORLD_LIMITS)
        local symbolIds = ModTiles.GetObjectUIDsOfType(value.Type.Value, WORLD_LIMITS:Unpack())
        for _, symbolId in pairs(symbolIds) do
            ModObject.DestroyObject(symbolId)
        end
    end

    TIMERS_STACK:AddTimer  (Timer.new(5, BuildingsDependencyTree.SwitchAllLockState):RandomizeStart())
    TIMERS_STACK:AddTimer  (Timer.new(1, function() VIRTUAL_NETWORK:TimeCallback() end))

    Converters.UpdateState()
    BuildingsDependencyTree.SwitchAllLockState()
    BUILDING_CONTROLLER:RegistryTypes({
        Extractor,
        Magnet,
        Pumps,
        Transmitter,
        Switcher,
        Inspector
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
        if (ModBase.GetGameState() == "Normal") then
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