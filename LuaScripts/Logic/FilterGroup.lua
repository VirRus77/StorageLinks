--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class FilterGroup :Object
---@field _switchers table<integer, ReferenceValue<boolean>>
---@field Name string
---@field State ReferenceValue<boolean>
FilterGroup = { }
---@type FilterGroup
FilterGroup = Object:extend(FilterGroup)

---@param name string
---@return FilterGroup
function FilterGroup.new(name)
    ---@type FilterGroup
    local instance = FilterGroup:make(name)
    return instance
end

function FilterGroup:initialize(name)
    self._switchers = { }
    self.Name = name
    self.State = ReferenceValue.new(false)
end

--- func desc
---@param id integer
---@param flag ReferenceValue<boolean>
function FilterGroup:Add(id, flag)
    if (self._switchers[id] ~= nil) then
        Logging.LogWarning("FilterGroup:Add exist item %d", id)
    end
    self._switchers[id] = flag
    self.State.Value = self:GetState()
end

--- func desc
---@param id integer
function FilterGroup:Remove(id)
    if (self._switchers[id] == nil) then
        Logging.LogWarning("FilterGroup:Remove not exist item %d", id)
        return
    end
    self._switchers[id] = nil
    -- self.State.Value = self:GetState()
end

-- --- func desc
-- ---@param id integer
-- ---@param flag boolean
-- function FilterGroup:SetState(id, flag)
--     if (self._switchers[id] == nil) then
--         Logging.LogWarning("FilterGroup:SetState not exist item %d", id)
--     end
--     self._switchers[id] = flag
--     self.State.Value = self:GetState()
-- end

---@return boolean
function FilterGroup:GetState()
    local flag = false
    for _, value in pairs(self._switchers) do
        flag = flag or value.Value
        if (flag) then
            return flag
        end
    end
    return flag
end