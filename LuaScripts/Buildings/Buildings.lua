--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


Buildings = {
    -- Magnet
    ---@alias Point2 integer[] # Point [1] = X, [2] = Y
    ---@alias Point3 { X? :number, Y? :number, Z? :number }
    ---@alias BuildingItem { Type :string, Name :string, Ingridients :string[], IngridientsAmount :integer[], ModelName :string, TopLeft :Point2, BottomRigth :Point2, AccessPoint :Point2 | nil, Scale? :number, Rotation? :Point3, Walkable? :boolean, CustomModel :boolean } # Item by building.
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
    ---@type BuildingItem #
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
    ---@alias DecorativeItem { Type :string, Name :string, Ingridients :string[], IngridientsAmount :integer[], ModelName :string, Scale? :number, Rotation? :Point3, CustomModel :boolean }
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

---@type DecorativeItem[]
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
        type == Buildings.MagnetCrude.Type
        or type == Buildings.MagnetGood.Type
        or type == Buildings.MagnetSuper.Type
    )
end

--- Retrun BuildingLevels by magnet type
---@param type string #
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
    Logging.LogInformation("Buildings.CreateAll")

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

    Buildings.Create (Buildings.SwitchSuper)

    -- Switch
    Buildings.CreateDecorative (Decoratives.SwitchOnSymbol)
    -- Misc Symbols
    Buildings.CreateDecorative (Decoratives.SymbolBroken)
end

--- UpdateType by uniq.
function Buildings:UpdateTypeByUniq()
    for _, buildingValue in ipairs(self.AllTypes) do
        buildingValue.Type = Constants.UniqueName(buildingValue.Type)
    end
end

--- Extension ModBuilding.CreateBuilding
---@param building BuildingItem #
---@param replaceType? string # Replace uniq type
function Buildings.Create (building, replaceType)
    ---@type string
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

--- func desc
---@param decorative DecorativeItem
---@param replaceType string?
function Buildings.CreateDecorative (decorative, replaceType)
    ---@type string
    local type = decorative.Type
    if (replaceType ~= nil) then
        type = replaceType
    end

    ModDecorative.CreateDecorative (
        type,
        decorative.Ingridients,
        decorative.IngridientsAmount,
        decorative.ModelName,
        decorative.CustomModel or false
    )

    if (decorative.Scale) then
        ModDecorative.UpdateModelScale (type, decorative.Scale)
    end
    if (decorative.Rotation) then
        ---@type Point3
        local rotation = decorative.Rotation
        rotation.X = rotation.X or 0.0
        rotation.Y = rotation.Y or 0.0
        rotation.Z = rotation.Z or 0.0
        ModDecorative.UpdateModelRotation (type, rotation.X, rotation.Y, rotation.Z)
    end
end
