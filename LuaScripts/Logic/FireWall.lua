--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]
---@alias FilterGroupItem { Filtering :boolean, Elements: table<integer, boolean> }


---@class FireWall :Object
---@field FilterGroup table<string, FilterGroupItem>
---@field ItemToGroup table<integer, string>
FireWall = { }
---@type Provider
FireWall = AccessPoint:extend(FireWall)

---@return FireWall
function FireWall.new()
    ---@type FireWall
    local instance = FireWall:make()
    return instance
end

---@private
function FireWall:initialize()
    self.FilterGroup = { }
    self.ItemToGroup = { }
end

---@param id integer
---@param groupName string
function FireWall:Add(id, groupName)
    if (self.ItemToGroup[id] ~= nil) then
        Logging.LogWarning("FireWall:Add contains item %d %s", id, groupName)
        self:Remove(id)
    end
    self.ItemToGroup[id] = groupName
    ---@type FilterGroupItem
    local group = Tools.Dictionary.GetOrAddValueLazy(self.FilterGroup, groupName, function () return { Filtering = false, Elements = {} } end)
    group.Elements[id] = true
end

--- func desc
---@param id integer
function FireWall:Remove(id)
    local group = self.ItemToGroup[id]
    if (group == nil) then
        Logging.LogWarning("FireWall:Add not contains item %d", id)
        return
    end
    self.ItemToGroup[id] = nil
    self.FilterGroup[group].Filtering[id] = nil
end

--- func desc
---@param groupName string
---@param flag boolean
function FireWall:FilterGroup(groupName, flag)
    local group = Tools.Dictionary.GetOrAddValueLazy(self.FilterGroup, groupName, function () return { Filtering = false, Elements = {} } end)
    group.Filtering = flag
end

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
    local groupName = self.ItemToGroup[id]
    if (groupName == nil) then
        return false
    end
    return self.FilterGroup[groupName].Filtering
end
