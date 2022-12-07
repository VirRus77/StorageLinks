--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class InspectorBase :BuildingStorageLinksBase #
---@field InspectPoint Point # Direction base rotation
---@field SwitchState ReferenceValue<boolean>
---@field Settings MagnetSettingsItem2 #
InspectorBase = {
    SupportTypes = {
        Buildings.Inspector,
    },
    InspectPoint = Point.new(0, -1),
}
---@type InspectorBase
InspectorBase = BuildingStorageLinksBase:extend(InspectorBase)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return InspectorBase
function InspectorBase.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("InspectorBase.new %d, %s", id, callbackRemove)
    ---@type InspectorSettingsItem
    local settings = BuildingSettings.GetSettingsByType(type) or error("InspectorBase Settings not found", 666) or { }

    ---@type InspectorBase
    local instance = InspectorBase:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod, fireWall)
    instance.SwitchState = ReferenceValue.new(false)
    instance.InspectPoint = settings.InspectPoint
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
---@param oldValue string|Point|nil
---@override BuildingBase.UpdateLogic
---@protected
function InspectorBase:UpdateLogic(editType, oldValue)
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

function InspectorBase:OnTimerCallback()
    local location = self.Location
    local inspectPointRotate = Point.Rotate(self.InspectPoint, self.Rotation)
    local inspectPoint = Point.new(location.X + inspectPointRotate.X, location.Y + inspectPointRotate.Y)

    local ids = ModTiles.GetHoldableObjectUIDs(inspectPoint.X, inspectPoint.Y)
    -- Logging.LogDebug("InspectorBase:OnTimerCallback (%s)(%s) foundIds %d", self.Location, inspectPoint, #ids)
    local count = 0
    for _, value in pairs(ids) do
        if (not OBJECTS_IN_FLIGHT:Contains(value)) then
            count = count + 1
        end
    end
    local switchState = count > 0
    if (switchState == self.SwitchState.Value) then
        return
    end
    self.SwitchState.Value = switchState
    self:UpdateVisualState()
end

--- func desc
---@param oldName string|nil
function InspectorBase:UpdateName(oldName)
    Logging.LogInformation("InspectorBase:UpdateName %s", self.Name)
    local newGroupName = self:GetGroupName()
    Logging.LogDebug("InspectorBase:UpdateName %s -> %s", self.Name, newGroupName)
    if (self._groupName == newGroupName) then
        return
    end
    self:UpdateGroup(newGroupName)
end

--- func desc
---@param oldLocation Point|nil
function InspectorBase:UpdateMove(oldLocation)
    -- if (self.LinkedSymbolId ~= nil) then
    --     ModObject.MoveToInstantly(self.LinkedSymbolId, self.Location.X, self.Location.Y)
    -- end
end

function InspectorBase:UpdateVisualState()
    if (not ModObject.IsValidObjectUID(self.Id)) then
        return
    end

    if (self.SwitchState.Value) then
        -- self.LinkedSymbolId = ModBase.SpawnItem(Decoratives.SwitchOnSymbol.Type, self.Location.X, self.Location.Y, false, true, false)
        --end
    else
        self:RemoveLink()
    end
end

--- func desc
---@param newGroupName string|nil
function InspectorBase:UpdateGroup(newGroupName)
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
function InspectorBase:RemoveLink(removeFromFirewall)
    -- if (self.LinkedSymbolId ~= nil)then
    --     ModObject.DestroyObject(self.LinkedSymbolId)
    --     self.LinkedSymbolId = nil
    -- end
    if (removeFromFirewall) then
        if (self._groupName ~= nil) then
            self.FireWall:RemoveSwitcher(self.Id, self._groupName)
        end
    end
end