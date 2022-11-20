--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class WorldLimits :Object
----@type { Left :integer, Top :integer, Width :integer, Height :integer }
WorldLimits = {
    ---@type integer
    Left = nil,
    ---@type integer
    Top = nil,
    ---@type integer
    Right = nil,
    ---@type integer
    Bottom = nil,
    ---@type integer
    Width = nil,
    ---@type integer
    Height = nil,
}
---@type WorldLimits
WorldLimits = Object:extend(WorldLimits)

---@return WorldLimits
function WorldLimits.new()
    return WorldLimits:make()
end

---@param worldParameters integer[]
function WorldLimits:Update (worldParameters)
    Logging.LogDebug("WORLD_LIMITS.Update %s", worldParameters)
    self.Left = 0
    self.Top = 0
    self.Width = worldParameters[1] - 1
    self.Height = worldParameters[2] - 1
    self.Right = self.Left + self.Width
    self.Bottom = self.Top + self.Height
    Logging.LogDebug("WORLD_LIMITS.Update %s %s %s %s", tostring(self.Left), tostring(self.Top), tostring(self.Width), tostring(self.Height))
end

--- func desc
---@param area Area
---@return Area
function WorldLimits:ApplyLimits(area)
    local newArea = Area.new()
    newArea.Left   = math.max(self.Left,   math.min(area.Left,  self.Right))
    newArea.Top    = math.max(self.Top,    math.min(area.Top,   self.Bottom))
    newArea.Right  = math.min(self.Right,  math.max(area.Right, self.Left))
    newArea.Bottom = math.min(self.Bottom, math.max(area.Bottom, self.Top))
    return newArea
end

---@return integer, integer, integer, integer
function WorldLimits:Unpack()
    return self.Left, self.Top, self.Right, self.Bottom
end

function WorldLimits:__tostring()
    return string.format("%s %s %s %s", tostring(self.Left), tostring(self.Top), tostring(self.Width), tostring(self.Height))
end