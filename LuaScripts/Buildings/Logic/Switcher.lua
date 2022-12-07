--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Switcher :BuildingFireWallBase
---@field SwitchState ReferenceValue<boolean>
---@field LinkedSymbolId integer
Switcher = {
    SupportTypes = {
        Buildings.SwitchSuper
    },
}
--@type Switcher
Switcher = BuildingFireWallBase:extend(Switcher)

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

function Switcher:initialize(id, type, callbackRemove, fireWall)
    BuildingFireWallBase.initialize(self, id, type, callbackRemove, fireWall)
    self.SwitchState = ReferenceValue.new(false)
    self:UpdateGroup()
    Logging.LogDebug("Switcher:initialize switchState: %s Ref: %s",  self.SwitchState.Value, tostring(self.SwitchState))
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

function Switcher:OnDestroy(newValue)
    Logging.LogDebug("Switcher:OnDestroy %d \"%s\"", self.Id, self.Name)
    self:RemoveLink(true)
    BuildingFireWallBase.OnDestroy(self, newValue)
end

--- func desc
---@param newValue Point
function Switcher:OnMove(newValue)
    Logging.LogDebug("Switcher:OnMove %d %s -> %s", self.Id, self.Location, newValue)
    BuildingFireWallBase.OnMove(self, newValue)
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

function Switcher:UpdateGroup()
    Logging.LogDebug("Switcher:UpdateGroup %s", self._groupName)
    local newGroup = self:GetGroupName()
    Logging.LogDebug("Switcher:UpdateGroup %s -> %s", self.Name, ToTypedString(newGroup))
    if (newGroup == self._groupName) then
        return
    end

    if (self._groupName ~= nil) then
        self._fireWall:RemoveSwitcher(self.Id, self._groupName)
        self._groupName = nil
    end

    if (newGroup ~= nil) then
        self._fireWall:AddSwitcher(self.Id, newGroup, self.SwitchState)
        self._groupName = newGroup
    end
end

--- func desc
---@param removeFromFirewall boolean|nil
function Switcher:RemoveLink(removeFromFirewall)
    if (self.LinkedSymbolId ~= nil)then
        ModObject.DestroyObject(self.LinkedSymbolId)
        self.LinkedSymbolId = nil
    end
    if (removeFromFirewall) then
        if (self._groupName ~= nil) then
            self._fireWall:RemoveSwitcher(self.Id, self._groupName)
        end
    end
end