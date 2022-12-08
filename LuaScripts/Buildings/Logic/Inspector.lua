--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Inspector :SwitcherBase #
---@field InspectPoint Point # Direction base rotation
---@field SwitchState ReferenceValue<boolean>
---@field _settings InspectorSettingsItem #
Inspector = {
    SupportTypes = {
        Buildings.Inspector,
    }
}
---@type Inspector
Inspector = SwitcherBase:extend(Inspector)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return Inspector
function Inspector.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("Inspector.new %d, %s", id, callbackRemove)
    ---@type Inspector
    local instance = Inspector:make(id, type, callbackRemove, fireWall)
    return instance
end

function Inspector:initialize(id, type, callbackRemove, fireWall)
    SwitcherBase.initialize(self, id, type, callbackRemove, fireWall)
    self.InspectPoint = self._settings.InspectPoint
    self:UpdateGroup()
end

function Inspector:OnTimerCallback()
    local location = self.Location
    local inspectPointRotate = Point.Rotate(self.InspectPoint, self.Rotation)
    local inspectPoint = location + inspectPointRotate

    local ids = ModTiles.GetHoldableObjectUIDs(inspectPoint:Unpack())
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

function Inspector:UpdateVisualState()
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