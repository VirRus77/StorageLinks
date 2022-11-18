--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class FireWall :Object
---@field _filterGroup table<string, FilterGroup>
---@field _itemToGroup table<integer, string>
FireWall = { }
---@type Provider
FireWall = Object:extend(FireWall)

---@return FireWall
function FireWall.new()
    ---@type FireWall
    local instance = FireWall:make()
    return instance
end

---@private
function FireWall:initialize()
    self._filterGroup = { }
    self._itemToGroup = { }
end

---@param id integer
---@param groupName string
function FireWall:Add(id, groupName)
    if (self._itemToGroup[id] ~= nil) then
        Logging.LogWarning("FireWall:Add contains item %d %s", id, groupName)
        self:Remove(id)
    end
    self._itemToGroup[id] = groupName
end

--- func desc
---@param id integer
function FireWall:Remove(id)
    local group = self._itemToGroup[id]
    if (group == nil) then
        Logging.LogWarning("FireWall:Add not contains item %d", id)
        return
    end
    self._itemToGroup[id] = nil
end

--- func desc
---@param id integer
---@param groupName string
---@param refFlag ReferenceValue<boolean>
function FireWall:AddSwitcher(id, groupName, refFlag)
    Logging.LogDebug("FireWall:AddSwitcher [%d] '%s'", id, groupName)
    local idsInGroup = self._filterGroup[groupName]
    if (idsInGroup ~= nil and idsInGroup._switchers[id] ~= nil) then
        Logging.LogWarning("FireWall:AddSwitcher contains item %d %s", id, groupName)
        self:RemoveSwitcher(id, groupName)
    end
    if (idsInGroup == nil) then
        idsInGroup = FireWall.MakeFilterGroup(groupName)
        self._filterGroup[groupName] = idsInGroup
    end
    idsInGroup:Add(id, refFlag)
end

--- func desc
---@param id integer
---@param groupName string
function FireWall:RemoveSwitcher(id, groupName)
    local idsInGroup = self._filterGroup[groupName]
    if (idsInGroup == nil) then
        Logging.LogWarning("FireWall:RemoveSwitcher group not exist %s", groupName)
        return
    end
    if (idsInGroup._switchers[id] ~= nil) then
        Logging.LogWarning("FireWall:RemoveSwitcher item not exist %d %s", id, groupName)
        return
    end
    idsInGroup:Remove(id)
end

-- --- func desc
-- ---@param id integer
-- ---@param groupName string
-- ---@param flag ReferenceValue<boolean>
-- function FireWall:SetSwitcher(id, groupName, flag)
--     local idsInGroup = self._filterGroup[groupName]
--     if (idsInGroup == nil) then
--         Logging.LogWarning("FireWall:SetSwitcher group not exist %s", groupName)
--         return
--     end
--     if (idsInGroup:SetState(id, flag) == nil) then
--         Logging.LogWarning("FireWall:SetSwitcher item not exist %d %s", id, groupName)
--         return
--     end
--     idsInGroup[id] = flag

-- end

--- func desc
---@param id integer
---@return boolean
function FireWall:Skip(id)
    return self:Contains(id)
end

--- func desc
---@param id integer
---@return boolean
function FireWall:Contains(id)
    local groupName = self._itemToGroup[id]
    if (groupName == nil) then
        return false
    end

    local group = self._filterGroup[groupName]
    if (group == nil) then
        Logging.LogWarning("FireWall:Contains not found group: %s\n%s", groupName, self)
        return false
    end
    return group:GetState()
end

---@return FilterGroup
function FireWall.MakeFilterGroup(name)
    return FilterGroup.new(name)
end