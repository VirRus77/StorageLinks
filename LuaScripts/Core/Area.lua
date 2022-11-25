--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Area :Object #
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
---@param self Area
---@param left?   integer|nil
---@param top?    integer|nil
---@param right?  integer|nil
---@param bottom? integer|nil
function Area:initialize(left, top, right, bottom)
    self.Left   = left or 0
    self.Top    = top or 0
    self.Right  = right or 0
    self.Bottom = bottom or 0
    -- self.meta.__eq = Area.Equals
    self.meta.__tostring = Area.ToString

    self:Normalize()
end

function Area:Width()
    return self.Right - self.Left + 1
end

function Area:Height()
    return self.Bottom - self.Top + 1
end

--- Normalize: Flip update on: left <= right, top <= bottom
---@param area Area
---@return Area
function Area.Normalize(area)
    local left   = math.min(area.Left, area.Right)
    local top    = math.min(area.Top,  area.Bottom)
    local right  = math.max(area.Left, area.Right)
    local bottom = math.max(area.Top,  area.Bottom)
    area.Left   = left
    area.Top    = top
    area.Right  = right
    area.Bottom = bottom
    return area
end

--- Unpack Left, Top, Right, Bottom
---@param area Area
---@return integer, integer, integer, integer # Left, Top, Right, Bottom
function Area.Unpack(area)
    return area.Left, area.Top, area.Right, area.Bottom
end

--- func desc
---@param area1 Area
---@param area2 Area
---@return boolean
function Area.Equals(area1, area2)
    return (area1.Left == area2.Left
        and area1.Top == area2.Top
        and area1.Right == area2.Right
        and area1.Bottom == area1.Bottom)
end

function Area.ToString(area)
    return string.format("{%d, %d; %d, %d}", area.Left, area.Top, area.Right, area.Bottom)
end