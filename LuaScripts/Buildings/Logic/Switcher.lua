--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Switcher :BuildingStorageLinksBase
---@field SwitchState ReferenceValue<boolean>
---@field LinkedSymbolId integer
Switcher = {
    SupportTypes = {
        Buildings.SwitchSuper
    },
}
--@type Switcher
Switcher = BuildingStorageLinksBase:extend(Switcher)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return Switcher
function Switcher.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("Switcher.new %d, %s", id, callbackRemove)
    ---@type SwittcherSettingsItem
    local settings = BuildingSettings.GetSettingsByType(type) or error("Switcher Settings not found", 666) or { }

    ---@type Switcher
    local instance = Switcher:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod, fireWall)
    instance.SwitchState = ReferenceValue.new(false)
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
---@param oldValue string|Point|nil
---@override BuildingBase.UpdateLogic
---@protected
function Switcher:UpdateLogic(editType, oldValue)
    Logging.LogInformation("Switcher:UpdateLogic %s", editType)
    if (editType == nil) then
        self:UpdateName()
        self:UpdateVisualState()
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
        self:UpdateName(oldValue --[[@as string|nil]])
        return
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Move) then
        self:UpdateMove(oldValue --[[@as Point]])
        return
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Destroy) then
        self:RemoveLink(true)
        return
    end
end

function Switcher:OnTimerCallback()
    local playerLocation = Point.new(table.unpack(ModPlayer.GetLocation()))
    local numBotsOnTile = ModTiles.GetAmountObjectsOfTypeInArea('Worker', self.Location.X, self.Location.Y, self.Location.X, self.Location.Y)
    local switchState = playerLocation:Equals(self.Location) or (numBotsOnTile > 0)
    if (switchState == self.SwitchState.Value) then
        return
    end
    self.SwitchState.Value = switchState
    self:UpdateVisualState()
end

--- func desc
---@param oldName string|nil
function Switcher:UpdateName(oldName)
    Logging.LogInformation("Switcher:UpdateName %s", self.Name)
    local newGroupName = self:GetGroupName()
    Logging.LogDebug("Switcher:UpdateName %s -> %s", self.Name, newGroupName)
    if (self._groupName == newGroupName) then
        return
    end
    self:UpdateGroup(newGroupName)
end

--- func desc
---@param oldLocation Point|nil
function Switcher:UpdateMove(oldLocation)
    if (self.LinkedSymbolId ~= nil) then
        ModObject.MoveToInstantly(self.LinkedSymbolId, self.Location.X, self.Location.Y)
    end
end

function Switcher:UpdateVisualState()
    if (not ModObject.IsValidObjectUID(self.Id)) then
        return
    end

    if (self.SwitchState.Value) then
        ModObject.SetNodeMaterial(self.Id, "Cylinder", "GlowingGreen")
        -- self.LinkedSymbolId = ModBase.SpawnItem(Decoratives.SwitchOnSymbol.Type.Value, self.Location.X, self.Location.Y, false, true, false)
        --end
    else
        ModObject.SetNodeMaterial(self.Id, "Cylinder", "GlowingRed")
        self:RemoveLink()
    end
end

--- func desc
---@param newGroupName string|nil
function Switcher:UpdateGroup(newGroupName)
    if (self._groupName ~= nil) then
        self.FireWall:RemoveSwitcher(self.Id, self._groupName)
        self._groupName = nil
    end

    if (newGroupName ~= nil) then
        self.FireWall:AddSwitcher(self.Id, newGroupName, self.SwitchState)
        self._groupName = newGroupName
        --self.FireWall:SetSwitcher(self.Id, newGroupName, self.SwitchState)
    end
end

--- func desc
---@param removeFromFirewall boolean|nil
function Switcher:RemoveLink(removeFromFirewall)
    if(self.LinkedSymbolId ~= nil)then
        ModObject.DestroyObject(self.LinkedSymbolId)
        self.LinkedSymbolId = nil
    end
    if (removeFromFirewall) then
        if(self._groupName ~= nil) then
            self.FireWall:RemoveSwitcher(self.Id, self._groupName)
        end
    end
end