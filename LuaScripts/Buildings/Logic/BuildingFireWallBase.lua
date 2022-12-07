--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BuildingFireWallBase :BuildingTypedBase
---@field base BuildingTypedBase
---@field _fireWall FireWall
---@field _groupName string|nil
BuildingFireWallBase = { }
---@type BuildingFireWallBase
BuildingFireWallBase = BuildingTypedBase:extend(BuildingFireWallBase)
BuildingFireWallBase.BuildingEditType = {
    Rotate = "Rotate",
    Move = "Move",
    Rename = "Rename",
    Destroy = "Destroy"
}

---@param id integer #
---@param callbackRemove fun() #
---@param fireWall FireWall
---@return BuildingFireWallBase
function BuildingFireWallBase.new(id, uniqType, callbackRemove, fireWall)
    ---@type BuildingFireWallBase
    local instance = BuildingFireWallBase:make(id, uniqType, callbackRemove, fireWall)
    return instance
end

---@param id integer #
---@param uniqType string #
---@param callbackRemove fun() #
---@param fireWall FireWall
function BuildingFireWallBase:initialize(id, uniqType, callbackRemove, fireWall)
    BuildingTypedBase.initialize(self, id, uniqType, callbackRemove)
    self._fireWall = fireWall
    -- Each successor must call itself at the end of its initialization.
    -- self:UpdateGroup()
end

--- func desc
---@param newValue string
function BuildingFireWallBase:OnRename(newValue)
    BuildingTypedBase.OnRename(self, newValue)
    self:UpdateGroup()
end

function BuildingFireWallBase:OnDestroy(newValue)
    Logging.LogDebug("BuildingFireWallBase:OnDestroy %d \"%s\"", self.Id, self.Name)
    self:RemoveFromFireWall()
    BuildingTypedBase.OnDestroy(self, newValue)
end

function BuildingFireWallBase:UpdateGroup()
    Logging.LogDebug("BuildingFireWallBase:UpdateGroup %s", self._groupName)
    local newGroup = self:GetGroupName()
    Logging.LogDebug("BuildingFireWallBase:UpdateGroup %s -> %s", self.Name, ToTypedString(newGroup))
    if (newGroup == self._groupName) then
        return
    end

    if (self._groupName ~= nil) then
        self._fireWall:Remove(self.Id)
        self._groupName = nil
    end

    if (newGroup ~= nil) then
        Logging.LogDebug("BuildingFireWallBase:UpdateGroup FireWall add [%d] \'%s\' -> \'%s\'", self.Id, self.Name, newGroup)
        self._fireWall:Add(self.Id, newGroup)
        self._groupName = newGroup
    end
end

--- func desc
---@return string|nil
function BuildingFireWallBase:GetGroupName()
    local findPattern = StringFindPattern.new("%[[^[]+%]")
        :AfterFind(function (value) return string.sub(value, 2, string.len(value) - 1) end)
    local found = findPattern:Find(self.Name, 1)
    if (found == nil or #found ~= 1 or string.len(found[1]) == 0) then
        return nil
    end
    return found[1]
end

function BuildingFireWallBase:RemoveFromFireWall()
    if (self._groupName == nil) then
        return
    end

    self._fireWall:Remove(self.Id)
end