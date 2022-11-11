
-- Wishlist
-- OVERFLOW PIPE (/pressure relief) -> when source side is full, move one if possible.
-- Transmitter Priority by name "Priority 1", "Priority 2"... 1 being most important.
-- Receiver Priority "Priority 1", "Priority 2"...etc
-- Priority: - Unprioritized? use level 50.

--- Used near exclusively for Steam Workshop and Mod information
function SteamDetails()
    Logging.Log("SteamDetails")

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

~~ Future ~~
 - Be able to transfer to/from train carriages. As of 136.24, the Modding API does not support interacting with train carriages.


~= Enjoy =~

    ]], {"transport", "storage"}, "logo.jpg")

end

--- Here you can expose any variables to the game for settings
function Expose()
    Logging.Log("Expose")
    if (ModBase.GetGameVersionMajor() == 136 and ModBase.GetGameVersionMinor() == 17 and ModBase.GetGameVersionPatch() == 2) then
        return
    end

    ModBase.ExposeVariable("Enable Debug Mode", false, ExposedVariableCallback)
    ModBase.ExposeKeybinding("Debug: Move", 8, ExposedKeyCallback)
end

--- Used to create any custom converters or buildings
function Creation()
    Logging.Log("Creation")
    Buildings.CreateAll()
    Buildings:UpdateTypeByUniq()
    Logging.Log(serializeTable(Buildings, "Buildings"))
    Decoratives:UpdateTypeByUniq()
    Logging.Log(serializeTable(Decoratives, "Buildings"))
    

    -- Set some overall globals that determine if we want to use a TIMER, or callbacks.
    if ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION) then
        if ModBase.ClassAndMethodExist('ModBuilding','RegisterForBuildingRenamedCallback') then
            USE_EVENT_STYLE = true
        end
    end

end

--- Initial load function by game
function BeforeLoad()
    Logging.Log("BeforeLoad")

    SwitchLockByLevel()
    UNLOCK_LEVEL_TIMER = Timer.new(SECONDS_BETWEEN_UNLOCK_CHECKS, SwitchLockByLevel)

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

    -- -- Hide old names
    -- ModVariable.SetVariableForObjectAsInt ("Storage Pump (SL)"       , "Unlocked", 0)
    -- ModVariable.SetVariableForObjectAsInt ("Storage Pump XL (SL)"    , "Unlocked", 0)
    -- ModVariable.SetVariableForObjectAsInt ("Storage Transmitter (SL)", "Unlocked", 0)
    -- ModVariable.SetVariableForObjectAsInt ("Storage Receiver (SL)"   , "Unlocked", 0)
    -- ModVariable.SetVariableForObjectAsInt ("Storage Magnet (SL)"     , "Unlocked", 0)
    -- ModVariable.SetVariableForObjectAsInt ("Storage Balancer (SL)"   , "Unlocked", 0)
    -- ModVariable.SetVariableForObjectAsInt ("Storage Balancer XL (SL)", "Unlocked", 0)
-- 
    -- -- Hide symbols
    -- ModVariable.SetVariableForObjectAsInt("Switch On Symbol (SL)","Unlocked", 0)
    -- ModVariable.SetVariableForObjectAsInt("Broken Symbol (SL)"   ,"Unlocked", 0)

    --lockLevels()
    --checkUnlockLevels()

end

--- Once a game has loaded key functionality, this is called.
function AfterLoad()
    Logging.Log("AfterLoad")
    --swapOldNamesToNew()
end

--- Only called when creating a game. [v134.23]
function AfterLoad_CreatedWorld()
    Logging.Log("AfterLoad_CreatedWorld")
end

--- Only called on loading a game. [v134.23]
function AfterLoad_LoadedWorld()
    Logging.Log("AfterLoad_LoadedWorld")
    --lockLevels()
    --checkUnlockLevels()
    SwitchLockByLevel()

    WORLD_LIMITS = ModTiles.GetMapLimits()

    -- Reset caches
    LINK_UIDS = {}
    STORAGE_UIDS = {}

    -- When world is loaded, find Magnets!
    discoverUnknownMagnets()
end

--- Called every frame, see also Time.deltaTime
---@param timeDelta number
function OnUpdate(timeDelta)
    -- Called on every cycle!
    updateFlightPositions()
    everyFrame(timeDelta)

    -- Every Five SECONDS_BETWEEN_UNLOCK_CHECKS
    FIVE_SECOND_TIMER = FIVE_SECOND_TIMER + timeDelta
    if FIVE_SECOND_TIMER >= 5 then
        -- discoverUnknownMagnets()
        FIVE_SECOND_TIMER = 0
    end

    --if (ONE_SECOND_TIMER > 1) then
    --	ONE_SECOND_TIMER = 0
    --	checkUnlockLevels()
    --end
    --ModQuest.IsObjectTypeUnlocked("MetalCog")

    if (DEBUG_ENABLED == false) then
        UNLOCK_LEVEL_TIMER:AppendDelta(timeDelta)

        --local secondsDiff = timeDelta + LAST_TIME_DELTA
        --LAST_TIME_DELTA = timeDelta -- time is in decimal seconds

        -- Update timing trackers
        CRUDE_TIMER_SECOND = CRUDE_TIMER_SECOND + timeDelta
        GOOD_TIMER_SECOND = GOOD_TIMER_SECOND + timeDelta
        SUPER_TIMER_SECOND = SUPER_TIMER_SECOND + timeDelta

        -- Crude Level
        if CRUDE_TIMER_SECOND >= (1 / CRUDE_CHECKS_PER_SECOND) then
            locateLinks(BuildingLevels.Crude)
            CRUDE_TIMER_SECOND = 0
        end

        -- Good Level
        if GOOD_TIMER_SECOND >= (1 / GOOD_CHECKS_PER_SECOND) then
            locateLinks(BuildingLevels.Good)
            GOOD_TIMER_SECOND = 0
        end

        -- Super Level
        if SUPER_TIMER_SECOND >= (1 / SUPER_CHECKS_PER_SECOND) then
            locateLinks(BuildingLevels.Super)
            SUPER_TIMER_SECOND = 0
        end
    end

end

