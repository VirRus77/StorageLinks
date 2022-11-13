--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@type { Left :integer, Top :integer, Width :integer, Height :integer }
WORLD_LIMITS = {
    ---@type integer
    Left = nil,
    ---@type integer
    Top = nil,
    ---@type integer
    Width = nil,
    ---@type integer
    Height = nil
}

---@param worldParameters integer[]
function WORLD_LIMITS.Update (worldParameters)
    Logging.LogDebug("WORLD_LIMITS.Update %s", worldParameters)
    WORLD_LIMITS.Left = 0
    WORLD_LIMITS.Top = 0
    WORLD_LIMITS.Width = worldParameters[1] - 1
    WORLD_LIMITS.Height = worldParameters[2] - 1
    Logging.LogDebug("WORLD_LIMITS.Update %s %s %s %s", tostring(WORLD_LIMITS.Left), tostring(WORLD_LIMITS.Top), tostring(WORLD_LIMITS.Width), tostring(WORLD_LIMITS.Height))
end

function WORLD_LIMITS:__tostring()
    return string.format("%s %s %s %s", tostring(self.Left), tostring(self.Top), tostring(self.Width), tostring(self.Height))
end