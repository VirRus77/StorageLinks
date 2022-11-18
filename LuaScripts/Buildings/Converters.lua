--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@type ConverterItem[]
Converters = {
    -- -- Extractors
    -- ---@alias ConverterItem { Type :string, Recipes : string[]|nil, Ingridients :string[]|nil, IngridientsAmount :integer[]|nil, ModelName :string, TopLeft :Point2, BottomRigth :Point2, AccessPoint :Point2|nil, SpawnPoint :Point2|nil, Scale? :number, Rotation? :Point3, Walkable? :boolean, CustomModel :boolean } # Item by building.
    -- ---@type ConverterItem #
}

---@type ConverterItem
Converters.AllTypes = {
    -- Extractors
    --Converters.Extractor
}

--- UpdateType by uniq.
function Converters:UpdateTypeByUniq()
    for _, buildingValue in ipairs(self.AllTypes) do
        buildingValue.Type = Constants.UniqueName(buildingValue.Type)
    end
end

--- Add all buildings.
function Converters.CreateAll ()
    Logging.LogInformation("Converters.CreateAll")

    for _, value in ipairs(Converters.AllTypes) do
        Converters.CreateConverter(value)
    end
end

--- Extension ModBuilding.CreateBuilding
---@param converter ConverterItem #
---@param replaceType? string # Replace uniq type
function Converters.CreateConverter (converter, replaceType)
    ---@type string
    local type = converter.Type
    if (replaceType ~= nil) then
        type = replaceType
    end

    ModConverter.CreateConverter (
        type,
        converter.Recipes or { },
        converter.Ingridients or { },
        converter.IngridientsAmount or { },
        converter.ModelName,
        converter.TopLeft,
        converter.BottomRigth,
        converter.AccessPoint or converter.SpawnPoint,
        converter.SpawnPoint or converter.AccessPoint,
        converter.CustomModel or false
    )

    if (converter.Scale) then
        ModConverter.UpdateModelScale (type, converter.Scale)
    end
    if (converter.Rotation) then
        ---@type Point3
        local rotation = converter.Rotation
        rotation.X = rotation.X or 0.0
        rotation.Y = rotation.Y or 0.0
        rotation.Z = rotation.Z or 0.0
        ModConverter.UpdateModelRotation (type, rotation.X, rotation.Y, rotation.Z)
    end
    if (converter.Walkable) then
        ModBuilding.SetBuildingWalkable (type, converter.Walkable)
    end
end

function Converters.UpdateState()
    -- for _, converter in ipairs(Converters.AllTypes) do
    --     if (converter.AccessPoint == nil) then
    --         ModBuilding.ShowBuildingAccessPoint(converter.Type, false)
    --     end
    -- end
end
