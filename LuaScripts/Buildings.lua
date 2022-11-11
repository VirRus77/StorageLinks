Buildings = {
    -- Magnet
    MagnetCrude = {
        Type = "MagnetCrude",
        Name = "Crude Magnet (SL)",
        Ingridients = { "Rock", "TreeSeed" },
        IngridientsAmount = {2, 1},
        ModelName = Constants.Models.MagnetCrude,
        TopLeft = {0, 0},
        BottomRigth = {0, 0},
        AccessPoint = nil,
        --Scale = 3,
        --Rotation = { X = 0, Y = 90, Z = 0 },
        --Walkable = true
        CustomModel = true,
    },
    MagnetGood = {
        Type = "MagnetGood",
        Name = "Good Magnet (SL)",
        Ingridients = { "Rock", "StringBall" },
        IngridientsAmount = { 4, 3 },
        ModelName = Constants.Models.MagnetGood,
        TopLeft = {0, 0},
        BottomRigth = {0, 0},
        AccessPoint = nil,
        --Scale = 3,
        --Rotation = { X = 0, Y = 90, Z = 0 },
        --Walkable = true
        CustomModel = true,
    },
    MagnetSuper = {
        Type = "MagnetSuper",
        Name = "Super Magnet (SL)",
        Ingridients = { "MetalPlateCrude", "MetalPoleCrude", "Rivets", "UpgradeWorkerCarrySuper" },
        IngridientsAmount = { 2, 2, 4, 1 },
        ModelName = Constants.Models.MagnetSuper,
        TopLeft = {0, 0},
        BottomRigth = {0, 0},
        AccessPoint = nil,
        --Scale = 3,
        --Rotation = { X = 0, Y = 90, Z = 0 },
        --Walkable = true
        CustomModel = true,
    },

    -- Pump
    PumpCrude = {
        Type = "PumpCrude",
        Name = "Crude Pump (SL)",
        Ingridients = { "Log", "Pole" },
        IngridientsAmount = { 1, 2 },
        ModelName = "PumpCrude",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    PumpGood = {
        Type = "PumpGood",
        Name = "Good Pump (SL)",
        Ingridients = { "Mortar", "Pole" },
        IngridientsAmount = { 4, 8 },
        ModelName = "PumpGood",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    PumpSuper = {
        Type = "PumpSuper",
        Name = "Super Pump (SL)",
        Ingridients = { "MetalPlateCrude", "MetalPoleCrude", "Rivets" },
        IngridientsAmount = { 4, 8, 8 },
        ModelName = "PumpSuper",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    PumpSuperLong = {
        Type = "PumpSuperLong",
        Name = "Super Pump Long (SL)",
        Ingridients = { "MetalPlateCrude", "MetalPoleCrude", "Rivets" },
        IngridientsAmount = { 4, 8, 8 },
        ModelName = "PumpSuperLong",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },

    -- Overflow Pump
    OverflowPumpCrude = {
        Type = "OverflowPumpCrude",
        Name = "Crude Overflow Pump (SL)",
        Ingridients = { "Log", "Pole" },
        IngridientsAmount = { 1, 2 },
        ModelName = "OverflowCrude",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    OverflowPumpGood = {
        Type = "OverflowPumpGood",
        Name = "Good Overflow Pump (SL)",
        Ingridients = { "Mortar", "Pole" },
        IngridientsAmount = { 4, 8 },
        ModelName = "OverflowGood",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    OverflowPumpSuper = {
        Type = "OverflowPumpSuper",
        Name = "Super Overflow Pump (SL)",
        Ingridients = { "MetalPlateCrude", "MetalPoleCrude", "Rivets" },
        IngridientsAmount = { 4, 8, 8 },
        ModelName = "OverflowSuper",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },

	-- Balancer
    BalancerCrude = {
        Type = "BalancerCrude",
        Name = "Crude Balancer (SL)",
        Ingridients = { "Log", "Pole" },
        IngridientsAmount = { 1, 2 },
        ModelName = "BalCrude",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    BalancerGood = {
        Type = "BalancerGood",
        Name = "Good Balancer (SL)",
        Ingridients = { "Mortar", "Pole" },
        IngridientsAmount = { 4, 8 },
        ModelName = "BalGood",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    BalancerSuper = {
        Type = "BalancerSuper",
        Name = "Super Balancer (SL)",
        Ingridients = { "MetalPlateCrude", "MetalPoleCrude", "Rivets" },
        IngridientsAmount = { 4, 8, 8 },
        ModelName = "BalSuper",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    BalancerSuperLong = {
        Type ="BalancerSuperLong",
        Name = "Super Balancer Long (SL)",
        Ingridients = { "MetalPlateCrude", "MetalPoleCrude", "Rivets" },
        IngridientsAmount = { 4, 8, 8 },
        ModelName = "BalSuperLong",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },

    -- Transmitter
    TransmitterCrude = {
        Type = "TransmitterCrude",
        Name = "Crude Transmitter (SL)",
        Ingridients = { "Log", "Pole", "TreeSeed" },
        IngridientsAmount = { 2, 3, 1 },
        ModelName = "TransmitterCrude",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    TransmitterGood = {
        Type = "TransmitterGood",
        Name = "Good Transmitter (SL)",
        Ingridients = { "Mortar", "Pole", "TreeSeed" },
        IngridientsAmount = { 4, 10, 1 },
        ModelName = "TransmitterGood",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    TransmitterSuper = {
        Type = "TransmitterSuper",
        Name = "Super Transmitter (SL)",
        Ingridients = { "MetalPlateCrude", "MetalPoleCrude", "Rivets", "UpgradeWorkerCarrySuper" },
        IngridientsAmount = { 4, 6, 6, 1 },
        ModelName = "TransmitterSuper",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },

    -- Receiver
    ReceiverCrude = {
        Type = "ReceiverCrude",
        Name = "Crude Receiver (SL)",
        Ingridients = { "Log","Pole","TreeSeed" },
        IngridientsAmount = { 2, 3, 1 },
        ModelName = "ReceiverCrude",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    ReceiverGood = {
        Type = "ReceiverGood",
        Name = "Good Receiver (SL)",
        Ingridients = { "Mortar","Pole","TreeSeed" },
        IngridientsAmount = { 4, 10, 1 },
        ModelName = "ReceiverGood",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },
    ReceiverSuper = {
        Type = "ReceiverSuper",
        Name = "Super Receiver (SL)",
        Ingridients = { "MetalPlateCrude", "MetalPoleCrude", "Rivets", "UpgradeWorkerCarrySuper" },
        IngridientsAmount = { 4, 6, 6, 1 },
        ModelName = "ReceiverSuper",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        CustomModel = true,
    },

    -- Switch
    SwitchSuper = {
        Type = "SwitchSuper",
        Name = "Super Switch (SL)",
        Ingridients = { "MetalPlateCrude", "Plank" },
        IngridientsAmount = { 1, 3 },
        ModelName = "Switch",
        TopLeft = {0,0},
        BottomRigth = {0,0},
        AccessPoint = nil,
        Walkable = true,
        CustomModel = true,
    },
}

Buildings.AllTypes = {
        -- Magnet
        Buildings.MagnetCrude,
        Buildings.MagnetGood,
        Buildings.MagnetSuper,

        -- Pump
        Buildings.PumpCrude,
        Buildings.PumpGood,
        Buildings.PumpSuper,
        Buildings.PumpSuperLong,

        -- Overflow Pump
        Buildings.OverflowPumpCrude,
        Buildings.OverflowPumpGood,
        Buildings.OverflowPumpSuper,

        -- Balancer
        Buildings.BalancerCrude,
        Buildings.BalancerGood,
        Buildings.BalancerSuper,
        Buildings.BalancerSuperLong,

        -- Transmitter    
        Buildings.TransmitterCrude,
        Buildings.TransmitterGood,
        Buildings.TransmitterSuper,

        -- Receiver
        Buildings.ReceiverCrude,
        Buildings.ReceiverGood,
        Buildings.ReceiverSuper,

        -- Switch
        Buildings.SwitchSuper,
}

Decoratives = {
    SwitchOnSymbol = {
        Type = "SwitchOnSymbol",
        Name = "Switch On Symbol (SL)",
        Ingridients = { "TreeSeed", },
        IngridientsAmount = { 1 },
        ModelName = "SwitchOn",
        CustomModel = true,
    },

    -- Misc Symbols
    SymbolBroken = {
        Type = "SymbolBroken",
        Name = "Broken Symbol (SL)",
        Ingridients = { "TreeSeed" },
        IngridientsAmount = { 1 },
        ModelName = "BrokenSymbol",
        CustomModel = true,
    },
}

Decoratives.AllTypes = {
    Decoratives.SwitchOnSymbol,

    -- Misc Symbols
    Decoratives.SymbolBroken,
}

--- UpdateType by uniq.
function Decoratives:UpdateTypeByUniq()
    for _, buildingValue in ipairs(self.AllTypes) do
        buildingValue.Type = Constants.UniqueName(buildingValue.Type)
    end
end

---@type string[]
Buildings.CrudeTypes = {
    Buildings.PumpCrude.Name,
    Buildings.OverflowPumpCrude.Name,
    Buildings.BalancerCrude.Name,
    Buildings.TransmitterCrude.Name,
    Buildings.ReceiverCrude.Name,
    Buildings.MagnetCrude.Name,
}

---@type string[]
Buildings.GoodTypes = {
    Buildings.PumpGood.Name,
    Buildings.OverflowPumpGood.Name,
    Buildings.BalancerGood.Name,
    Buildings.TransmitterGood.Name,
    Buildings.ReceiverGood.Name,
    Buildings.MagnetGood.Name,
}

---@type string[]
Buildings.SuperTypes = {
    Buildings.PumpSuper.Name,
    Buildings.PumpSuperLong.Name,
    Buildings.OverflowPumpSuper.Name,
    Buildings.BalancerSuper.Name,
    Buildings.BalancerSuperLong.Name,
    Buildings.TransmitterSuper.Name,
    Buildings.ReceiverSuper.Name,
    Buildings.MagnetSuper.Name,
    Buildings.SwitchSuper.Name,
}

--- Check type is magnet
---@param type string
---@return boolean
function Buildings.IsMagnet(type)
    return (
        type == Buildings.MagnetCrude.Name
        or type == Buildings.MagnetGood.Name
        or type == Buildings.MagnetSuper.Name
    )
end

--- Retrun BuildingLevels by magnet type
---@param type string #
---@alias BuildingLevels "Crude"|"Good"|"Super" #
---@return BuildingLevels #
function Buildings.GetMagnetLevel(type)
    if(type == Buildings.MagnetCrude.Name)then
        return BuildingLevels.Crude
    end
    if(type == Buildings.MagnetGood.Name)then
        return BuildingLevels.Good
    end
    if(type == Buildings.MagnetSuper.Name)then
        return BuildingLevels.Super
    end
    error("Unknown magnet type: "..type, 200)
end

--- Add all buildings.
function Buildings.CreateAll ()
    -- Magnet
    Buildings.Create (Buildings.MagnetCrude)
    Buildings.Create (Buildings.MagnetGood)
    Buildings.Create (Buildings.MagnetSuper)

    -- Pump
    Buildings.Create (Buildings.PumpCrude)
    Buildings.Create (Buildings.PumpGood)
    Buildings.Create (Buildings.PumpSuper)
    Buildings.Create (Buildings.PumpSuperLong)

    -- Overflow Pump
    Buildings.Create (Buildings.OverflowPumpCrude)
    Buildings.Create (Buildings.OverflowPumpGood)
    Buildings.Create (Buildings.OverflowPumpSuper)

    -- Balancer
    Buildings.Create (Buildings.BalancerCrude)
    Buildings.Create (Buildings.BalancerGood)
    Buildings.Create (Buildings.BalancerSuper)
    Buildings.Create (Buildings.BalancerSuperLong)

    -- Transmitter
    Buildings.Create (Buildings.TransmitterCrude)
    Buildings.Create (Buildings.TransmitterGood)
    Buildings.Create (Buildings.TransmitterSuper)

    -- Receiver
    Buildings.Create (Buildings.ReceiverCrude)
    Buildings.Create (Buildings.ReceiverGood)
    Buildings.Create (Buildings.ReceiverSuper)

    -- Switch
    Buildings.Create (Buildings.SwitchSuper)
    Buildings.CreateDecorative (Decoratives.SwitchOnSymbol)

    -- Misc Symbols
    Buildings.CreateDecorative (Decoratives.SymbolBroken)

    -- Old version buildings
    --Buildings.CreateOld ()
end

function Buildings.CreateOld ()
	-- Discontinuing these names -- here so they show up in existing games
	--ModBuilding.CreateBuilding("Storage Pump (SL)"	  		, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "PumpSuper"  		, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Pump XL (SL)"	  	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "PumpSuperLong"  	, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Transmitter (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {4, 6, 6, 1}, "TransmitterSuper" 	, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Receiver (SL)"	  	, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {4, 6, 6, 1}, "ReceiverSuper"  		, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Magnet (SL)"		, {"MetalPlateCrude","MetalPoleCrude","Rivets", "UpgradeWorkerCarrySuper"}, {2, 2, 4, 1}, "MagnetSuper"  	, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Balancer (SL)"		, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "BalSuper"		, {0,0} , {0,0}, nil, true )
	--ModBuilding.CreateBuilding("Storage Balancer XL (SL)"	, {"MetalPlateCrude","MetalPoleCrude","Rivets"}	, {4, 8, 8}	, "BalSuperLong"	, {0,0} , {0,0}, nil, true )
end

--- UpdateType by uniq.
function Buildings:UpdateTypeByUniq()
    for _, buildingValue in ipairs(self.AllTypes) do
        buildingValue.Type = Constants.UniqueName(buildingValue.Type)
    end
end

--- Extension ModBuilding.CreateBuilding
---@param building table
function Buildings.Create (building)
    ModBuilding.CreateBuilding (
        building.Name,
        building.Ingridients,
        building.IngridientsAmount,
        building.ModelName,
        building.TopLeft,
        building.BottomRigth,
        building.AccessPoint,
        building.CustomModel or false
    )

    if (building.Scale) then
        ModBuilding.UpdateModelScale (building.Name, building.Scale)
    end
    if (building.Rotation) then
        local rotation = building.Rotation
        rotation.X = rotation.X or 0.0
        rotation.Y = rotation.Y or 0.0
        rotation.Z = rotation.Z or 0.0
        ModBuilding.UpdateModelRotation (building.Name, rotation.X, rotation.Y, rotation.Z)
    end
    if (building.Walkable) then
        ModBuilding.SetBuildingWalkable (building.Name, true)
    end
end

function Buildings.CreateDecorative (building)
    ModDecorative.CreateDecorative (
        building.Name,
        building.Ingridients,
        building.IngridientsAmount,
        building.ModelName,
        building.CustomModel or false
    )

    if (building.Scale) then
        ModDecorative.UpdateModelScale (building.Name, building.Scale)
    end
    if (building.Rotation) then
        local rotation = building.Rotation
        rotation.X = rotation.X or 0.0
        rotation.Y = rotation.Y or 0.0
        rotation.Z = rotation.Z or 0.0
        ModDecorative.UpdateModelRotation (building.Name, rotation.X, rotation.Y, rotation.Z)
    end
end