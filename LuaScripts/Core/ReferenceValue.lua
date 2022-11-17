--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]

---@class ReferenceValue<T> :Object, { Value: T } #
----@field Value T #
ReferenceValue = { }
---@type ReferenceValue
ReferenceValue = Object:extend(ReferenceValue)

--- func desc
---@generic T :any
---@param value T|nil
---@return ReferenceValue<T>
function ReferenceValue.new(value)
    ---@type ReferenceValue
    local instance = ReferenceValue:make(value)
    return instance
end

function ReferenceValue:initialize(value)
    self.Value = value
end