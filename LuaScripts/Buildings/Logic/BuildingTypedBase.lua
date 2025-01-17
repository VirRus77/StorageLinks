--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BuildingTypedBase :BuildingBase
---@field base BuildingBase
---@field _uniqType string
---@field _settings BuildingSettingItem|SettingPeriod|nil
BuildingTypedBase = { }
---@type BuildingTypedBase 
BuildingTypedBase = BuildingBase:extend(BuildingTypedBase)

---@param id integer #
---@param uniqType string # Building uniq type
---@param callbackRemove fun(value :BuildingBase) #
---@return BuildingTypedBase
function BuildingTypedBase.new(id, uniqType, callbackRemove)
    ---@type BuildingTypedBase
    local instance = BuildingTypedBase:make(id, uniqType, callbackRemove)
    return instance
end

---@param self BuildingTypedBase
---@param id integer #
---@param uniqType string # Building uniq type
---@param callbackRemove fun() #
function BuildingTypedBase:initialize(id, uniqType, callbackRemove)
    BuildingBase.initialize(self, id, callbackRemove)
    self._uniqType = uniqType
    self._settings = BuildingSettings.GetSettingsByType(uniqType)
end

--- func desc
---@return Timer
function BuildingTypedBase:MakeTimer()
    local timer = Timer.new(self._settings.UpdatePeriod, function () self:OnTimerCallback() end)
    return timer:RandomizeStart()
end

function BuildingTypedBase:OnTimerCallback()
    Logging.LogInformation("BuildingTypedBase:OnTimerCallback %d %s (%s)", self.Id, self.Name, self.Location)
    --local buildingRotation = ModBuilding.GetRotation(self.Id)
    --Logging.LogInformation("buildingRotation: %d", buildingRotation)
end