--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Switcher :SwitcherBase
---@field SwitchState ReferenceValue<boolean>
---@field LinkedSymbolId integer
Switcher = {
    SupportTypes = {
        Buildings.SwitchSuper
    },
}
--@type Switcher
Switcher = SwitcherBase:extend(Switcher)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return Switcher
function Switcher.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("Switcher.new %d, %s", id, callbackRemove)
    ---@type Switcher
    local instance = Switcher:make(id, type, callbackRemove, fireWall)
    return instance
end

function Switcher:OnTimerCallback()
    Logging.LogDebug("Switcher:OnTimerCallback %s %s", self.Name, self._groupName)
    local playerLocation = Point.new(table.unpack(ModPlayer.GetLocation()))
    local numBotsOnTile = ModTiles.GetAmountObjectsOfTypeInArea('Worker', self.Location.X, self.Location.Y, self.Location.X, self.Location.Y)
    local switchState = playerLocation:Equals(self.Location) or (numBotsOnTile > 0)
    Logging.LogDebug("Switcher:OnTimerCallback switchState: %s => %s Ref: %s",  self.SwitchState.Value, switchState, tostring(self.SwitchState))
    if (switchState == self.SwitchState.Value) then
        return
    end
    self.SwitchState.Value = switchState
    self:UpdateVisualState()
end

--- func desc
---@param newValue Point
function Switcher:OnMove(newValue)
    Logging.LogDebug("Switcher:OnMove %d %s -> %s", self.Id, self.Location, newValue)
    SwitcherBase.OnMove(self, newValue)
    if (self.LinkedSymbolId ~= nil) then
        ModObject.MoveToInstantly(self.LinkedSymbolId, self.Location.X, self.Location.Y)
    end
end

function Switcher:UpdateVisualState()
    Logging.LogDebug("Switcher:UpdateVisualState %s %s %s", self.Name, self._groupName, self.SwitchState.Value)
    if (not ModObject.IsValidObjectUID(self.Id)) then
        return
    end

    if (self.SwitchState.Value) then
        ModObject.SetNodeMaterial(self.Id, "^Cube_Cube.003$", "Materials/_GlowingGreen")
        -- self.LinkedSymbolId = ModBase.SpawnItem(Decoratives.SwitchOnSymbol.Type.Value, self.Location.X, self.Location.Y, false, true, false)
        --end
    else
        ModObject.SetNodeMaterial(self.Id, "^Cube_Cube.003$", "Materials/_GlowingRed")
        self:RemoveLink()
    end
end

--- func desc
---@param removeFromFirewall boolean|nil
function Switcher:RemoveLink(removeFromFirewall)
    SwitcherBase.RemoveLink(self, removeFromFirewall)
    if (self.LinkedSymbolId ~= nil)then
        ModObject.DestroyObject(self.LinkedSymbolId)
        self.LinkedSymbolId = nil
    end
end