--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class SwitcherBase :BuildingFireWallBase
---@field SwitchState ReferenceValue<boolean>
SwitcherBase = {
}
--@type SwitcherBase
SwitcherBase = BuildingFireWallBase:extend(SwitcherBase)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall #
---@return SwitcherBase
function SwitcherBase.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("SwitcherBase.new %d, %s", id, callbackRemove)
    ---@type SwitcherBase
    local instance = SwitcherBase:make(id, type, callbackRemove, fireWall)
    return instance
end

function SwitcherBase:initialize(id, type, callbackRemove, fireWall)
    BuildingFireWallBase.initialize(self, id, type, callbackRemove, fireWall)
    self.SwitchState = ReferenceValue.new(true)
    self:UpdateGroup()
    Logging.LogDebug("SwitcherBase:initialize switchState: %s Ref: %s",  self.SwitchState.Value, tostring(self.SwitchState))
end

function SwitcherBase:OnTimerCallback()
    Logging.LogDebug("SwitcherBase:OnTimerCallback %s %s", self.Name, self._groupName)
end

function SwitcherBase:OnDestroy(newValue)
    Logging.LogDebug("SwitcherBase:OnDestroy %d \"%s\"", self.Id, self.Name)
    self:RemoveLink(true)
    BuildingFireWallBase.OnDestroy(self, newValue)
end

function SwitcherBase:UpdateGroup()
    Logging.LogDebug("SwitcherBase:UpdateGroup %s", self._groupName)
    local newGroup = self:GetGroupName()
    Logging.LogDebug("SwitcherBase:UpdateGroup %s -> %s", self.Name, ToTypedString(newGroup))
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
function SwitcherBase:RemoveLink(removeFromFirewall)
    Logging.LogTrace("SwitcherBase:RemoveLink %s FireWall: %s", removeFromFirewall, self._fireWall)
    if (removeFromFirewall) then
        if (self._groupName ~= nil) then
            self._fireWall:RemoveSwitcher(self.Id, self._groupName)
        end
    end
end