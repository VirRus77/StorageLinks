---@type { Left :number, Top :number, Width :number, Height :number }
WORLD_LIMITS = {
    Left = 0,
    Top = 0,
    Width = 1,
    Height = 1
}

---@param worldParameters integer[]
function WORLD_LIMITS.Update (worldParameters)
    WORLD_LIMITS.Width = worldParameters[1] - 1
    WORLD_LIMITS.Height = worldParameters[2] - 1
end