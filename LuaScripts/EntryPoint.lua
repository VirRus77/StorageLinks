
-- Wishlist
-- OVERFLOW PIPE (/pressure relief) -> when source side is full, move one if possible.
-- Transmitter Priority by name "Priority 1", "Priority 2"... 1 being most important.
-- Receiver Priority "Priority 1", "Priority 2"...etc
-- Priority: - Unprioritized? use level 50.

--- Used near exclusively for Steam Workshop and Mod information
function SteamDetails()

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
	if (ModBase.GetGameVersionMajor() == 136 and ModBase.GetGameVersionMinor() == 17 and ModBase.GetGameVersionPatch() == 2) then
		return
	end

	ModBase.ExposeVariable("Enable Debug Mode", false, ExposedVariableCallback)
	ModBase.ExposeKeybinding("Debug: Move", 8, ExposedKeyCallback)
end

--- Used to create any custom converters or buildings
function Creation()
    Buildings.CreateAll()

	-- Pump
	ModBuilding.CreateBuilding("Crude Pump (SL)"	  	, {"Log","Pole"}							   	, {1, 2}	, "PumpCrude" 		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Good Pump (SL)"	  		, {"Mortar","Pole"}					   		   	, {4, 8}   	, "PumpGood" 		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Super Pump (SL)"	  	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "PumpSuper"  		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Super Pump Long (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "PumpSuperLong"  	, {0,0} , {0,0}, nil, true )

	-- Overflow Pump
	ModBuilding.CreateBuilding("Crude Overflow Pump (SL)"	, {"Log","Pole"}							   	, {1, 2}	, "OverflowCrude" 		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Good Overflow Pump (SL)"	, {"Mortar","Pole"}					   		   	, {4, 8}   	, "OverflowGood" 		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Super Overflow Pump (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "OverflowSuper"		, {0,0} , {0,0}, nil, true )

	-- Balancer
	ModBuilding.CreateBuilding("Crude Balancer (SL)"	, {"Log","Pole"}							   	, {1, 2}	, "BalCrude" 		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Good Balancer (SL)"	  	, {"Mortar","Pole"}					   		   	, {4, 8}   	, "BalGood" 		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Super Balancer (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "BalSuper"		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Super Balancer Long (SL)",{"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "BalSuperLong"	, {0,0} , {0,0}, nil, true )

	-- Transmitter
	ModBuilding.CreateBuilding("Crude Transmitter (SL)"	, {"Log","Pole","TreeSeed"}					  	, {2, 3, 1}	, "TransmitterCrude", {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Good Transmitter (SL)"	, {"Mortar","Pole","TreeSeed"}				  	, {4, 10, 1}, "TransmitterGood"	, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Super Transmitter (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {4, 6, 6, 1}, "TransmitterSuper" 	, {0,0} , {0,0}, nil, true )

	-- Receiver
	ModBuilding.CreateBuilding("Crude Receiver (SL)"	, {"Log","Pole","TreeSeed"}						, {2, 3, 1}	, "ReceiverCrude" 	, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Good Receiver (SL)"		, {"Mortar","Pole","TreeSeed"}				  	, {4, 10, 1}, "ReceiverGood" 	, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Super Receiver (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {4, 6, 6, 1}, "ReceiverSuper"  		, {0,0} , {0,0}, nil, true )

	-- Switch
	ModBuilding.CreateBuilding("Super Switch (SL)"		, {"MetalPlateCrude","Plank"}					, {1, 3}, "Switch"  	  , {0,0} , {0,0}, nil, true )
	ModDecorative.CreateDecorative("Switch On Symbol (SL)", {"TreeSeed",}								, {1}, "SwitchOn"  	  , true )

	-- Misc Symbols
	ModDecorative.CreateDecorative("Broken Symbol (SL)"	  , {"TreeSeed"}								, {1}, "BrokenSymbol", true )

	-- Buildings that can be walked through
	ModBuilding.SetBuildingWalkable("Super Switch (SL)", true)

	-- Discontinuing these names -- here so they show up in existing games
	ModBuilding.CreateBuilding("Storage Pump (SL)"	  		, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "PumpSuper"  		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Storage Pump XL (SL)"	  	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "PumpSuperLong"  	, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Storage Transmitter (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {4, 6, 6, 1}, "TransmitterSuper" 	, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Storage Receiver (SL)"	  	, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {4, 6, 6, 1}, "ReceiverSuper"  		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Storage Magnet (SL)"		, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {2, 2, 4, 1}, "MagnetSuper"  	, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Storage Balancer (SL)"		, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "BalSuper"		, {0,0} , {0,0}, nil, true )
	ModBuilding.CreateBuilding("Storage Balancer XL (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "BalSuperLong"	, {0,0} , {0,0}, nil, true )

	-- Set some overall globals that determine if we want to use a TIMER, or callbacks.
	if ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION) then
		if ModBase.ClassAndMethodExist('ModBuilding','RegisterForBuildingRenamedCallback') then
			USE_EVENT_STYLE = true
		end
	end

end

--- Initial load function by game
function BeforeLoad()

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

	-- Hide old names
	ModVariable.SetVariableForObjectAsInt("Storage Pump (SL)","Unlocked",0 )
	ModVariable.SetVariableForObjectAsInt("Storage Pump XL (SL)","Unlocked",0 )
	ModVariable.SetVariableForObjectAsInt("Storage Transmitter (SL)","Unlocked",0 )
	ModVariable.SetVariableForObjectAsInt("Storage Receiver (SL)","Unlocked",0 )
	ModVariable.SetVariableForObjectAsInt("Storage Magnet (SL)","Unlocked",0 )
	ModVariable.SetVariableForObjectAsInt("Storage Balancer (SL)","Unlocked",0 )
	ModVariable.SetVariableForObjectAsInt("Storage Balancer XL (SL)","Unlocked",0 )

	-- Hide symbols
	ModVariable.SetVariableForObjectAsInt("Switch On Symbol (SL)","Unlocked", 0)
	ModVariable.SetVariableForObjectAsInt("Broken Symbol (SL)"   ,"Unlocked", 0)

	--lockLevels()
	checkUnlockLevels()

end

--- Once a game has loaded key functionality, this is called.
function AfterLoad()
	swapOldNamesToNew()
end

--- Only called when creating a game. [v134.23]
function AfterLoad_CreatedWorld()

end

--- Only called on loading a game. [v134.23]
function AfterLoad_LoadedWorld()
	lockLevels()
	checkUnlockLevels()
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

	if DEBUG_ENABLED == false then

		--local secondsDiff = timeDelta + LAST_TIME_DELTA
		--LAST_TIME_DELTA = timeDelta -- time is in decimal seconds

		-- Update timing trackers
		CRUDE_TIMER_SECOND = CRUDE_TIMER_SECOND + timeDelta
		GOOD_TIMER_SECOND = GOOD_TIMER_SECOND + timeDelta
		SUPER_TIMER_SECOND = SUPER_TIMER_SECOND + timeDelta
		UNLOCK_TIMER_SECOND = UNLOCK_TIMER_SECOND + timeDelta


		-- Crude Level
		if CRUDE_TIMER_SECOND >= (1 / CRUDE_CHECKS_PER_SECOND) then
			locateLinks('Crude')
			CRUDE_TIMER_SECOND = 0
		end

		-- Good Level
		if GOOD_TIMER_SECOND >= (1 / GOOD_CHECKS_PER_SECOND) then
			locateLinks('Good')
			GOOD_TIMER_SECOND = 0
		end

		-- Super Level
		if SUPER_TIMER_SECOND >= (1 / SUPER_CHECKS_PER_SECOND) then
			locateLinks('Super')
			SUPER_TIMER_SECOND = 0
		end

		-- UnlockCheck
		-- if UNLOCK_TIMER_SECOND >= SECONDS_BETWEEN_UNLOCK_CHECKS then
			-- checkUnlockLevels()
			-- UNLOCK_TIMER_SECOND = 0
		-- end

	end

end

