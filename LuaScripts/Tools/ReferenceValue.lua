--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]

---@class ReferenceValue :Object #
---@field Value any #
ReferenceValue = { }
---@type ReferenceValue
ReferenceValue = Object:extend(ReferenceValue)

--- func desc
---@param value any|nil
---@return ReferenceValue
function ReferenceValue.new(value)
    ---@type ReferenceValue
    local instance = ReferenceValue:make(value)
    return instance
end

function ReferenceValue:initialize(value)
    self.Value = value
end