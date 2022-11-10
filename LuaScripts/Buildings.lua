Buildings = {
    -- Magnet
    CrudeMagnet = {
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
}

--- Add all buildings.
function Buildings.CreateAll ()
    Buildings.Create (Buildings.CrudeMagnet)
    Buildings.Create (Buildings.MagnetGood)
    Buildings.Create (Buildings.MagnetSuper)
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