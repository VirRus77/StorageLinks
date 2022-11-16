---@type { OldType :string, NewItem :DecorativeItem }[]
Decoratives.MappingOldTypes = {
    { OldType = "Switch On Symbol (SL)", NewItem = Decoratives.SwitchOnSymbol },
    { OldType = "Broken Symbol (SL)", NewItem = Decoratives.SymbolBroken },
}

---@type { OldType :string, NewItem :BuildingItem }[]
Buildings.MappingOldTypes = {

	-- Discontinuing these names -- here so they show up in existing games
	--ModBuilding.CreateBuilding("Storage Pump (SL)"	  		, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "PumpSuper"  		, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Pump XL (SL)"	  	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "PumpSuperLong"  	, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Transmitter (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {4, 6, 6, 1}, "TransmitterSuper" 	, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Receiver (SL)"	  	, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {4, 6, 6, 1}, "ReceiverSuper"  		, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Magnet (SL)"		, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {2, 2, 4, 1}, "MagnetSuper"  	, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Balancer (SL)"		, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "BalSuper"		, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Balancer XL (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "BalSuperLong"	, {0,0} , {0,0}, nil, true )

    -- Legacy
    { OldType = "Storage Pump (SL)",        NewItem = Buildings.PumpSuper },
    { OldType = "Storage Pump XL (SL)",     NewItem = Buildings.PumpSuperLong },
    { OldType = "Storage Transmitter (SL)", NewItem = Buildings.TransmitterSuper },
    { OldType = "Storage Receiver (SL)",    NewItem = Buildings.ReceiverSuper },
    { OldType = "Storage Magnet (SL)",      NewItem = Buildings.MagnetSuper },
    { OldType = "Storage Balancer (SL)",    NewItem = Buildings.BalancerSuper },
    { OldType = "Storage Balancer XL (SL)", NewItem = Buildings.BalancerSuperLong },

    -- Magnet
    { OldType = "Crude Magnet (SL)", NewItem = Buildings.MagnetCrude },
    { OldType = "Good Magnet (SL)",  NewItem = Buildings.MagnetGood },
    { OldType = "Super Magnet (SL)", NewItem = Buildings.MagnetSuper },

    -- Pump
    { OldType = "Crude Pump (SL)",       NewItem = Buildings.PumpCrude },
    { OldType = "Good Pump (SL)",        NewItem = Buildings.PumpGood },
    { OldType = "Super Pump (SL)",       NewItem = Buildings.PumpSuper },
    { OldType = "Super Pump Long (SL)",  NewItem = Buildings.PumpSuperLong },

    -- Overflow Pump
    { OldType = "Crude Overflow Pump (SL)", NewItem = Buildings.OverflowPumpCrude },
    { OldType = "Good Overflow Pump (SL)",  NewItem = Buildings.OverflowPumpGood },
    { OldType = "Super Overflow Pump (SL)", NewItem = Buildings.OverflowPumpSuper },

    -- Balancer
    { OldType = "Crude Balancer (SL)",      NewItem = Buildings.BalancerCrude },
    { OldType = "Good Balancer (SL)",       NewItem = Buildings.BalancerGood },
    { OldType = "Super Balancer (SL)",      NewItem = Buildings.BalancerSuper },
    { OldType = "Super Balancer Long (SL)", NewItem = Buildings.BalancerSuperLong },

    -- Transmitter    
    { OldType = "Crude Transmitter (SL)", NewItem = Buildings.TransmitterCrude },
    { OldType = "Good Transmitter (SL)",  NewItem = Buildings.TransmitterGood },
    { OldType = "Super Transmitter (SL)", NewItem = Buildings.TransmitterSuper },

    -- Receiver
    { OldType = "Crude Receiver (SL)", NewItem = Buildings.ReceiverCrude },
    { OldType = "Good Receiver (SL)",  NewItem = Buildings.ReceiverGood },
    { OldType = "Super Receiver (SL)", NewItem = Buildings.ReceiverSuper },

    -- Switch
    { OldType = "Super Switch (SL)", NewItem = Buildings.SwitchSuper },
}

---@obsolete
function Buildings.CreateOldTypes()
    for _, value in ipairs(Buildings.MappingOldTypes) do
        Buildings.Create (value.NewItem, value.OldType)
    end

    for _, value in ipairs(Decoratives.MappingOldTypes) do
        Buildings.CreateDecorative (value.NewItem, value.OldType)
    end
end

---@obsolete
function ReplaceOldBuildings()
    if (not Settings.ReplaceOldBuildings.Value) then
        return
    end

    -- Logging.LogDebug(serializeTable({
    --     Buildings.MappingOldTypes,
    --     "Buildings.MappingOldTypes"
    -- }),serializeTable({
    --     Decoratives.MappingOldTypes,
    --     "Decoratives.MappingOldTypes"
    -- }))

    for _, value in ipairs(Buildings.MappingOldTypes) do
        ModVariable.SetVariableForObjectAsInt(value.OldType, "Unlocked", 1)
    end
    for _, value in ipairs(Decoratives.MappingOldTypes) do
        ModVariable.SetVariableForObjectAsInt(value.OldType, "Unlocked", 1)
    end

    ---@type ReplaceItem[]
    local swapTypes = { }
    for index, value in ipairs(Buildings.MappingOldTypes) do
        table.insert(swapTypes, { OldType = value.OldType, NewType = value.NewItem.Type })
    end
    for index, value in ipairs(Decoratives.MappingOldTypes) do
        table.insert(swapTypes, { OldType = value.OldType, NewType = value.NewItem.Type })
    end
    Logging.LogDebug("Replace old...")
    ReplaceOldTypesToNewTypes(swapTypes)

    Logging.LogDebug("Disable old...")
    for _, value in ipairs(Buildings.MappingOldTypes) do
        ModVariable.SetVariableForObjectAsInt(value.OldType, "Unlocked", 0)
    end
    for _, value in ipairs(Decoratives.MappingOldTypes) do
        ModVariable.SetVariableForObjectAsInt(value.OldType, "Unlocked", 0)
    end
end