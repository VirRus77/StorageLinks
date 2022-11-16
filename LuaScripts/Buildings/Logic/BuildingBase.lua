--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@enum #
BuildingEditType = {
    Rotate = "Rotate",
    Move = "Move",
    Rename = "Rename",
    Destroy = "Destroy"
 }

DirectionDeltaPoint = {
    ---@type Point # n
    [0] = Point.new( 0, -1),
    ---@type Point # e
    [1] = Point.new( 1,  0),
    ---@type Point # s
    [2] = Point.new( 0,  1),
    ---@type Point # w
    [3] = Point.new(-1,  0),
}

AngleRotationToNSEW = {
    ---@type integer # n
    [0] = 0,
    ---@type integer # e
    [90] = 1,
    ---@type integer # s
    [180] = 2,
    ---@type integer # w
    [270] = 3,
}

---@class BuildingBase :Object #
---@field _logicPeriod number #
---@field _callbackRemove fun(BuildingBase) #
---@field Id integer # Building UID
---@field Type string #
---@field Location Point #
---@field Rotation integer #
---@field Name string #
---@field SupportTypes { Type :string }[] # Association building types.
---@function MakeTimer
---@function OnStateChangedCallback
---@function UpdateLogic
BuildingBase = {
    ---@type number
    _logicPeriod = nil,
    ---@type fun(BuildingBase)
    _callbackRemove = nil,
    ---@type { Type :string }[] #
    SupportTypes = { },
}
---@type BuildingBase
BuildingBase = Object:extend(BuildingBase)

-- Constructor.
---@param id integer # Building UID.
---@param type string # Building type.
---@param callbackRemove fun(BuildingBase) # Callback remove.
---@param location? Point # Building position.
---@param rotation? integer # Building position.
---@param logicPeriod? number # Period timer in seconds.
---@return BuildingBase
function BuildingBase.new(id, type, callbackRemove, location, rotation, logicPeriod)
    -- Logging.LogInformation("BuildingBase.new %d %s R:%s T:%s", id, callbackRemove, tostring(rotation), tostring(logicPeriod))
    ---@type BuildingBase
    local newInstance = BuildingBase:make(id, type, callbackRemove, location, rotation, logicPeriod)
    return newInstance
end

function BuildingBase:initialize(id, type, callbackRemove, location, rotation, logicPeriod)
    -- Logging.LogInformation("BuildingBase:initialize %d, %s, R:%s, T:%s", id, callbackRemove, tostring(rotation), tostring(logicPeriod))
    self._logicPeriod = logicPeriod
    self.Id = id
    self.Type = type
    local objectProperties = Extensions.UnpackObjectProperties(ModObject.GetObjectProperties(id))
    self.Location = location or Point.new(objectProperties.TileX, objectProperties.TileY)
    self.Rotation = rotation or ModBuilding.GetRotation(id)
    self.Name = objectProperties.Name
    self._callbackRemove = callbackRemove

    ModBuilding.RegisterForBuildingEditedCallback(id, function (buildingUID, editType, newValue) self:OnEditedCallback(buildingUID, editType, newValue); end)
    ModBuilding.RegisterForBuildingStateChangedCallback(id, function (buildingUID, newState) self:OnStateChangedCallback(buildingUID, newState); end )
end

--- func desc
---@return Timer|nil
function BuildingBase:MakeTimer()
    Logging.LogInformation("BuildingBase:MakeTimer")
    if (self._logicPeriod == nil) then
        Logging.LogInformation("BuildingBase:MakeTimer self._logicPeriod nil")
        return nil
    end

    self.Timer = Timer.new(self._logicPeriod, function() self:OnTimerCallback(); end, Timer.MillisecondsToSeconds(math.random() * self._logicPeriod))
    return self.Timer
end

--- func desc
---@param buildingUID integer
---@param editType "Rotate"|"Move"|"Rename"|"Destroy"
---@param newValue any
function BuildingBase:OnEditedCallback(buildingUID, editType, newValue)
    Logging.LogInformation("BuildingBase.OnEditedCallback(%d, %s, %s)", buildingUID, editType, serializeTable(newValue))
    if (editType == BuildingEditType.Rotate) then
        self:OnRotate(newValue)
    elseif (editType == BuildingEditType.Move) then
        local pointValues = { }
        --string.gmatch(newValue, "(%d+):(%d+)")
        for value in string.gmatch(newValue, "%d+") do
            pointValues[#pointValues + 1] = tonumber(value)
        end
        -- Logging.LogDebug("BuildingEditType.Move %s", serializeTable(pointValues))
        self:OnMove(Point.new(table.unpack(pointValues)))
    elseif (editType == BuildingEditType.Rename) then
        self:OnRename(newValue)
    elseif (editType == BuildingEditType.Destroy) then
        self:OnDestroy()
    end
end

---@param buildingUID integer
---@param newState any
function BuildingBase:OnStateChangedCallback(buildingUID, newState)
    Logging.LogInformation("BuildingBase.OnStateChangedCallback(%d, %s)", buildingUID, serializeTable(newState))
end

--- func desc
---@param editType BuildingEditType|nil # nesw = 0123
---@protected
function BuildingBase:UpdateLogic(editType)
    Logging.LogInformation("BuildingBase:UpdateLogic")
end

--- func desc
---@param direction integer # nesw = 0123
---@protected
function BuildingBase:OnRotate(direction)
    Logging.LogInformation("BuildingBase:OnRotate %d", direction)
    self.Rotation = direction
    self:UpdateLogic(BuildingEditType.Move)
end

--- func desc
---@param newLocation Point #
---@protected
function BuildingBase:OnMove(newLocation)
    Logging.LogInformation("BuildingBase:OnMove %s", newLocation)
    self.Location = newLocation
    self:UpdateLogic(BuildingEditType.Move)
end

--- func desc
---@param newName string # nesw = 0123
---@protected
function BuildingBase:OnRename(newName)
    Logging.LogInformation("BuildingBase:OnRename %s", newName)
    self.Name = newName
    self:UpdateLogic(BuildingEditType.Rename)
end

--- func desc
---@protected
function BuildingBase:OnDestroy()
    Logging.LogInformation("BuildingBase:OnDestroy")
    ModBuilding.UnregisterForBuildingEditedCallback(self.Id)
    ---@note Not exist unsubscrible RegisterForBuildingStateChangedCallback
    -- ModBuilding.RegisterForBuildingStateChangedCallback(id, function (buildingUID, newState) self:OnStateChangedCallback(buildingUID, newState); end )
    self:_callbackRemove()
    self:UpdateLogic(BuildingEditType.Destroy)
end

function BuildingBase:OnTimerCallback()
    Logging.LogInformation("BuildingBase:OnTimerCallback")
    --local buildingRotation = ModBuilding.GetRotation(self.Id)
    --Logging.LogInformation("buildingRotation: %d", buildingRotation)
end
