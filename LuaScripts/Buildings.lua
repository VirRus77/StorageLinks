Buildings = {
    -- Magnet
    ---@alias Point integer[]
    ---@alias BuildingItem { Type :string, Name :string, Ingridients :string[], IngridientsAmount :integer[], ModelName :string, TopLeft :Point, BottomRigth :Point, AccessPoint :Point | nil, CustomModel :boolean }
    ---@type BuildingItem #
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

---@type BuildingItem[]
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
    ---@alias DecorativeItem { Type :string, Name :string, Ingridients :string[], IngridientsAmount :integer[], ModelName :string, CustomModel :boolean }
    ---@type DecorativeItem #
    SwitchOnSymbol = {
        Type = "SwitchOnSymbol",
        Name = "Switch On Symbol (SL)",
        Ingridients = { "TreeSeed", },
        IngridientsAmount = { 1 },
        ModelName = "SwitchOn",
        CustomModel = true,
    },

    -- Misc Symbols
    ---@type DecorativeItem #
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

---@type { OldType :string, NewItem :DecorativeItem }[]
Decoratives.MappingOldTypes = {
    { OldType = "Switch On Symbol (SL)", NewItem = Decoratives.SwitchOnSymbol },
    { OldType = "Broken Symbol (SL)", NewItem = Decoratives.SymbolBroken },
}

--- UpdateType by uniq.
function Decoratives:UpdateTypeByUniq()
    for _, buildingValue in ipairs(self.AllTypes) do
        buildingValue.Type = Constants.UniqueName(buildingValue.Type)
    end
end

---@type BuildingItem[]
Buildings.CrudeTypes = {
    Buildings.PumpCrude,
    Buildings.OverflowPumpCrude,
    Buildings.BalancerCrude,
    Buildings.TransmitterCrude,
    Buildings.ReceiverCrude,
    Buildings.MagnetCrude,
}

---@type BuildingItem[] #
Buildings.GoodTypes = {
    Buildings.PumpGood,
    Buildings.OverflowPumpGood,
    Buildings.BalancerGood,
    Buildings.TransmitterGood,
    Buildings.ReceiverGood,
    Buildings.MagnetGood,
}

---@type BuildingItem[] #
Buildings.SuperTypes = {
    Buildings.PumpSuper,
    Buildings.PumpSuperLong,
    Buildings.OverflowPumpSuper,
    Buildings.BalancerSuper,
    Buildings.BalancerSuperLong,
    Buildings.TransmitterSuper,
    Buildings.ReceiverSuper,
    Buildings.MagnetSuper,
    Buildings.SwitchSuper,
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

--- Check type is magnet
---@param type string
---@return boolean
function Buildings.IsMagnet(type)
    return (
        type == Buildings.MagnetCrude.Type
        or type == Buildings.MagnetGood.Type
        or type == Buildings.MagnetSuper.Type
    )
end

--- Retrun BuildingLevels by magnet type
---@param type string #
---@alias BuildingLevels "Crude"|"Good"|"Super" #
---@return BuildingLevels #
function Buildings.GetMagnetLevel(type)
    if(type == Buildings.MagnetCrude.Type)then
        return BuildingLevels.Crude
    end
    if(type == Buildings.MagnetGood.Type)then
        return BuildingLevels.Good
    end
    if(type == Buildings.MagnetSuper.Type)then
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

function Buildings.CreateOldTypes()
    for _, value in ipairs(Buildings.MappingOldTypes) do
        Buildings.Create (value.NewItem, value.OldType)
    end

    for _, value in ipairs(Decoratives.MappingOldTypes) do
        Buildings.CreateDecorative (value.NewItem, value.OldType)
    end
end

--- UpdateType by uniq.
function Buildings:UpdateTypeByUniq()
    for _, buildingValue in ipairs(self.AllTypes) do
        buildingValue.Type = Constants.UniqueName(buildingValue.Type)
    end
end

--- Extension ModBuilding.CreateBuilding
---@param building BuildingItem
---@param replaceType string?
function Buildings.Create (building, replaceType)
    local type = building.Type
    if (replaceType ~= nil) then
        type = replaceType
    end
    ModBuilding.CreateBuilding (
        type,
        building.Ingridients,
        building.IngridientsAmount,
        building.ModelName,
        building.TopLeft,
        building.BottomRigth,
        building.AccessPoint,
        building.CustomModel or false
    )

    if (building.Scale) then
        ModBuilding.UpdateModelScale (type, building.Scale)
    end
    if (building.Rotation) then
        local rotation = building.Rotation
        rotation.X = rotation.X or 0.0
        rotation.Y = rotation.Y or 0.0
        rotation.Z = rotation.Z or 0.0
        ModBuilding.UpdateModelRotation (type, rotation.X, rotation.Y, rotation.Z)
    end
    if (building.Walkable) then
        ModBuilding.SetBuildingWalkable (type, true)
    end
end

--- func desc
---@param building DecorativeItem
---@param replaceType string?
function Buildings.CreateDecorative (building, replaceType)
    local type = building.Type
    if (replaceType ~= nil) then
        type = replaceType
    end

    ModDecorative.CreateDecorative (
        type,
        building.Ingridients,
        building.IngridientsAmount,
        building.ModelName,
        building.CustomModel or false
    )

    if (building.Scale) then
        ModDecorative.UpdateModelScale (type, building.Scale)
    end
    if (building.Rotation) then
        local rotation = building.Rotation
        rotation.X = rotation.X or 0.0
        rotation.Y = rotation.Y or 0.0
        rotation.Z = rotation.Z or 0.0
        ModDecorative.UpdateModelRotation (type, rotation.X, rotation.Y, rotation.Z)
    end
end