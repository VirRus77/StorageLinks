--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Switcher :BuildingBase
---@field SwitchState boolean
---@field LinkedSymbolId integer
Switcher = {
    SupportTypes = {
        Buildings.SwitchSuper
    },
}
Switcher = BuildingBase:extend(Switcher)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
----@param oldMaterial string #
---@return Switcher
function Switcher.new(id, type, callbackRemove)
    Logging.LogInformation("Switcher.new %d, %s", id, callbackRemove)
    ---@type SwittcherSettingsItem
    local settings = BuildingSettings.GetSettingsByType(type) or error("Switcher Settings not found", 666) or { }
    ---@type Switcher
    local instance = Switcher:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod)
    instance.SwitchState = settings.SwitchState
    instance.oldMaterial = "Gap"
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
---@param oldValue Point|nil
---@protected
function Switcher:UpdateLogic(editType, oldValue)
    Logging.LogInformation("Switcher:UpdateLogic %s", editType)
    if (editType == nil) then
        self:UpdateName()
        self:UpdateVisualState()
    elseif (editType == BuildingBase.BuildingEditType.Rename) then
        self:UpdateName()
        return
    elseif (editType == BuildingBase.BuildingEditType.Move) then
        self:UpdateMove(oldValue --[[@as Point]])
        return
    elseif (editType == BuildingBase.BuildingEditType.Destroy) then
        --self:RemoveLink()
        return
    end
end

function Switcher:OnTimerCallback()
    local playerLocation = Point.new(table.unpack(ModPlayer.GetLocation()))
    local numBotsOnTile = ModTiles.GetAmountObjectsOfTypeInArea('Worker', self.Location.X, self.Location.Y, self.Location.X, self.Location.Y)
    local switchState = playerLocation:Equals(self.Location) or (numBotsOnTile > 0)
    if (switchState == self.SwitchState) then
        return
    end
    self.SwitchState = switchState
    self:UpdateVisualState()
end

function Switcher:UpdateName()
    Logging.LogInformation("Switcher:UpdateName %s", self.Name)
end

function Switcher:UpdateMove(oldLocation)
    if (self.LinkedSymbolId ~= nil) then
        ModObject.MoveToInstantly(self.LinkedSymbolId, self.Location.X, self.Location.Y)
    end
end

function Switcher:UpdateVisualState()
    if (not ModObject.IsValidObjectUID(self.Id)) then
        return
    end

    local symbolIds = ModTiles.GetObjectUIDsOfType(Decoratives.SwitchOnSymbol.Type, self.Location.X, self.Location.Y, self.Location.X, self.Location.Y)
    if(self.SwitchState) then
        if (#symbolIds == 0) then
            self.LinkedSymbolId = ModBase.SpawnItem(Decoratives.SwitchOnSymbol.Type, self.Location.X, self.Location.Y, false, true, false)
        end
    else
        for _, symbolId in pairs(symbolIds) do
            ModObject.DestroyObject(symbolId)
        end
        self.LinkedSymbolId = nil
    end

    -- local objectName = "Cylinder"
    -- local root = "mt"
    -- local red = "Storage Link 2.0/Material/_GlowingRed"
    -- --local red = "mt/connected"
    -- local green = "Storage Link 2.0/Material/_GlowingGreen"
    -- --local green = "mt/not_connected"
    -- if (self.SwitchState) then
    --     ModObject.SetNodeMaterial(self.Id, objectName, red)
    -- else
    --     ModObject.SetNodeMaterial(self.Id, objectName, green)
    -- end
end