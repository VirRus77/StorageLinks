--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BuildingTypedBase :BuildingBase, SupportTypesBase
---@field _uniqType string
---@field _settings BuildingSettingItem|nil
BuildingTypedBase = { }
---@type BuildingTypedBase
BuildingTypedBase = BuildingBase:extend(BuildingTypedBase)

---@param id integer #
---@param uniqType string # Building uniq type
---@param callbackRemove fun() #
---@return BuildingTypedBase
function BuildingTypedBase.new(id, uniqType, callbackRemove)
    ---@type BuildingTypedBase
    local instance = BuildingTypedBase:make(id, uniqType, callbackRemove)
    return instance
end

function BuildingTypedBase:initialize(id, uniqType, callbackRemove)
    self.base:initialize(id, callbackRemove)
    self._uniqType = uniqType
    self._settings = BuildingSettings.GetSettingsByType(uniqType)
end