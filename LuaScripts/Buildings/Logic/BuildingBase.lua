--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BuildingBase :Object
---@field SupportTypes ReferenceValue<string>[]
BuildingBase = { }
---@type BuildingBase
BuildingBase = Object:extend(BuildingBase)

---@return BuildingBase
function BuildingBase.new()
    ---@type BuildingBase
    local instance = BuildingBase:make() --[[@as BuildingBase]]
    return instance
end

function BuildingBase:initialize(supportTypes)
    self.SupportTypes = supportTypes
end