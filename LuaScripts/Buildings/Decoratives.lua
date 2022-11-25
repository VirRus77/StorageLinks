Decoratives = {
    ---@alias DecorativeItem { Type :ReferenceValue<string>, Name :string, Ingridients :string[], IngridientsAmount :integer[], ModelName :string, Scale? :number, Rotation? :Point3, CustomModel :boolean }
    ---@type DecorativeItem #
    SwitchOnSymbol = {
        Type = ReferenceValue.new("SwitchOnSymbol"),
        Name = "Switch On Symbol (SL)",
        Ingridients = { "TreeSeed", },
        IngridientsAmount = { 1 },
        ModelName = "SwitchOn",
        CustomModel = true,
    },

    -- Misc Symbols
    ---@type DecorativeItem #
    SymbolBroken = {
        Type = ReferenceValue.new("SymbolBroken"),
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

Decoratives.NameUpdated = false;
--- UpdateType by uniq.
function Decoratives:UpdateTypeByUniq()
    if (self.NameUpdated) then
        return
    end
    for _, buildingValue in ipairs(self.AllTypes) do
        buildingValue.Type.Value = Constants.UniqueName(buildingValue.Type.Value)
    end
    self.NameUpdated = true
end

--- func desc
---@param decorative DecorativeItem
---@param replaceType string?
function Decoratives.CreateDecorative (decorative, replaceType)
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