--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Area #
---@field Left integer
---@field Top integer
---@field Right integer
---@field Bottom integer
Area = {
    Left = 0,
    Top = 0,
    Right = 0,
    Bottom = 0
}
---@type Area|Object
Area = Object:extend(Area)

--- func desc
---@param left? integer
---@param top? integer
---@param right? integer
---@param bottom? integer
---@return Area
function Area.new(left, top, right, bottom)
    ---@type Area
    local newInstance = Area:make(left, top, right, bottom)
    return newInstance
end

--- func desc
---@param left? integer
---@param top? integer
---@param right? integer
---@param bottom? integer
function Area:initialize(left, top, right, bottom)
    self.Left = math.min(left or 0, right or 0)
    self.Top = math.min(top or 0, bottom or 0)
    self.Right = math.max(left or 0, right or 0)
    self.Bottom = math.max(top or 0, bottom or 0)
end

function Area:Width()
    return self.Right - self.Left + 1
end

function Area:Height()
    return self.Bottom - self.Top + 1
end

function Area:__tostring()
    return string.format("%d:%d, %d:%d", self.Left, self.Top, self.Right, self.Bottom)
end