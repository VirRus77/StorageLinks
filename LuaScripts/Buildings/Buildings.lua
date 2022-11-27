--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


Buildings = {
    ---@alias Point2 integer[] # Point [1] = X, [2] = Y
    ---@alias Point3 { X? :number, Y? :number, Z? :number }
    ---@alias BuildingItem { Type :ReferenceValue<string>, Name :string, Ingridients :string[], IngridientsAmount :integer[], ModelName :string, TopLeft :Point2, BottomRigth :Point2, AccessPoint :Point2 | nil, Scale? :number, Rotation? :Point3, Walkable? :boolean, CustomModel :boolean } # Item by building.
    ---@type BuildingItem #
    Extractor = {
        Type = ReferenceValue.new("Extractor"),
        Recipes = nil,
        Ingridients = { "Log", "TreeSeed" },
        IngridientsAmount = { 1, 1 },
        ModelName = "Extractor",
        TopLeft = { 0, 0 },
        BottomRigth = { 0, 0 },
        AccessPoint = { 0, -1 },
        --SpawnPoint = { 0, -1 },
        Scale = 3,
        Rotation = { Y = 90 },
        Walkable = true,
        CustomModel = true,
    },

    ---@type BuildingItem #
    Inspector = {
        Type = ReferenceValue.new("Inspector"),
        Recipes = nil,
        Ingridients = { "Log", "TreeSeed", "Stick" },
        IngridientsAmount = { 1, 2, 4 },
        ModelName = "Inspector",
        TopLeft = { 0, 0 },
        BottomRigth = { 0, 0 },
        AccessPoint = nil,
        --SpawnPoint = { 0, -1 },
        Scale = 3,
        Rotation = { Y = 90 },
        Walkable = true,
        CustomModel = true,
    },

    -- Magnet
    MagnetCrude = {
        Type = ReferenceValue.new("MagnetCrude"),
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
    ---@type BuildingItem #
    MagnetGood = {
        Type = ReferenceValue.new("MagnetGood"),
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
        Type = ReferenceValue.new("MagnetSuper"),
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
        Type = ReferenceValue.new("PumpCrude"),
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
        Type = ReferenceValue.new("PumpGood"),
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
        Type = ReferenceValue.new("PumpSuper"),
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
        Type = ReferenceValue.new("PumpSuperLong"),
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
        Type = ReferenceValue.new("OverflowPumpCrude"),
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
        Type = ReferenceValue.new("OverflowPumpGood"),
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
        Type = ReferenceValue.new("OverflowPumpSuper"),
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
        Type = ReferenceValue.new("BalancerCrude"),
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
        Type = ReferenceValue.new("BalancerGood"),
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
        Type = ReferenceValue.new("BalancerSuper"),
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
        Type =ReferenceValue.new("BalancerSuperLong"),
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
        Type = ReferenceValue.new("TransmitterCrude"),
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
        Type = ReferenceValue.new("TransmitterGood"),
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
        Type = ReferenceValue.new("TransmitterSuper"),
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
        Type = ReferenceValue.new("ReceiverCrude"),
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
        Type = ReferenceValue.new("ReceiverGood"),
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
        Type = ReferenceValue.new("ReceiverSuper"),
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
        Type = ReferenceValue.new("SwitchSuper"),
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
    Buildings.Extractor,
    Buildings.Inspector,
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

--- Check type is magnet
---@param type string #
---@return boolean #
function Buildings.IsMagnet(type)
    return (
        type == Buildings.MagnetCrude.Type.Value
        or type == Buildings.MagnetGood.Type.Value
        or type == Buildings.MagnetSuper.Type.Value
    )
end

--- Retrun BuildingLevels by magnet type
---@param type string #
---@return BuildingLevels #
function Buildings.GetMagnetLevel(type)
    if (type == Buildings.MagnetCrude.Type.Value) then
        return BuildingLevels.Crude
    end
    if (type == Buildings.MagnetGood.Type.Value) then
        return BuildingLevels.Good
    end
    if (type == Buildings.MagnetSuper.Type.Value) then
        return BuildingLevels.Super
    end
    error("Unknown magnet type: "..type, 200)
end

--- Add all buildings.
function Buildings.CreateAll ()
    Logging.LogInformation("Buildings.CreateAll")

    -- Extractor Inspector
    Buildings.Create (Buildings.Extractor)
    Buildings.Create (Buildings.Inspector)
    Buildings.Create (Buildings.SwitchSuper)

    -- Switch
    Decoratives.CreateDecorative (Decoratives.SwitchOnSymbol)

    Buildings.Create (Buildings.MagnetCrude)
    Buildings.Create (Buildings.TransmitterCrude)
    Buildings.Create (Buildings.ReceiverCrude)
    Buildings.Create (Buildings.PumpCrude)
    Buildings.Create (Buildings.OverflowPumpCrude)
    Buildings.Create (Buildings.BalancerCrude)

    Buildings.Create (Buildings.MagnetGood)
    Buildings.Create (Buildings.PumpGood)
    Buildings.Create (Buildings.OverflowPumpGood)
    Buildings.Create (Buildings.BalancerGood)
    Buildings.Create (Buildings.TransmitterGood)
    Buildings.Create (Buildings.ReceiverGood)

    Buildings.Create (Buildings.MagnetSuper)
    Buildings.Create (Buildings.PumpSuper)
    Buildings.Create (Buildings.PumpSuperLong)
    Buildings.Create (Buildings.OverflowPumpSuper)
    Buildings.Create (Buildings.BalancerSuper)
    Buildings.Create (Buildings.BalancerSuperLong)
    Buildings.Create (Buildings.TransmitterSuper)
    Buildings.Create (Buildings.ReceiverSuper)

    -- Misc Symbols
    Decoratives.CreateDecorative (Decoratives.SymbolBroken)
end

Buildings.NameUpdated = false
--- UpdateType by uniq.
function Buildings:UpdateTypeByUniq()
    if (self.NameUpdated) then
        return
    end
    for _, buildingValue in ipairs(self.AllTypes) do
        buildingValue.Type.Value = Constants.UniqueName(buildingValue.Type.Value)
    end
    self.NameUpdated = true
end

--- Extension ModBuilding.CreateBuilding
---@param building BuildingItem #
---@param replaceType? string # Replace uniq type
function Buildings.Create (building, replaceType)
    ---@type string
    local type = building.Type.Value
    if (replaceType ~= nil) then
        type = replaceType
    end

    Logging.LogDebug("Buildings.Create: %s", type)
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

    Logging.LogDebug("Buildings.Create (complete): %s", type)

    if (building.Scale) then
        ModBuilding.UpdateModelScale (type, building.Scale)
    end
    if (building.Rotation) then
        ---@type Point3
        local rotation = building.Rotation
        rotation.X = rotation.X or 0.0
        rotation.Y = rotation.Y or 0.0
        rotation.Z = rotation.Z or 0.0
        ModBuilding.UpdateModelRotation (type, rotation.X, rotation.Y, rotation.Z)
    end
    if (building.Walkable) then
        ModBuilding.SetBuildingWalkable (type, building.Walkable)
    end
end
