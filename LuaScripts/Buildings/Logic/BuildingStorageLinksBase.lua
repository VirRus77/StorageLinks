--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


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

---@class BuildingStorageLinksBase :Object #
---@field _logicPeriod number #
---@field _callbackRemove fun(BuildingStorageLinksBase) #
---@field _groupName string
---@field Id integer # Building UID
---@field Type string #
---@field Location Point #
---@field Rotation integer #
---@field Name string #
---@field FireWall FireWall #
---@field SupportTypes { Type :string }[] # Association building types.
---@function MakeTimer
---@function OnStateChangedCallback
---@function UpdateLogic
BuildingStorageLinksBase = {
    ---@type number
    _logicPeriod = nil,
    ---@type fun(BuildingBase)
    _callbackRemove = nil,
    ---@type { Type :string }[] #
    SupportTypes = { },

    ---@enum BuildingBase.BuildingEditType #
    BuildingEditType = {
        Rotate = "Rotate",
        Move = "Move",
        Rename = "Rename",
        Destroy = "Destroy"
    }
}
---@type BuildingStorageLinksBase
BuildingStorageLinksBase = Object:extend(BuildingStorageLinksBase)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall
---@return BuildingStorageLinksBase
function BuildingStorageLinksBase.new(id, type, callbackRemove, fireWall)
    error("BuildingBase.new", 666)
end

-- Constructor.
---@param id integer # Building UID.
---@param type string # Building type.
---@param callbackRemove fun(BuildingBase) # Callback remove.
---@param location? Point # Building position.
---@param rotation? integer # Building position.
---@param logicPeriod? number # Period timer in seconds.
---@param fireWall FireWall #
---@return BuildingStorageLinksBase
function BuildingStorageLinksBase.new(id, type, callbackRemove, location, rotation, logicPeriod, fireWall)
    error("BuildingBase.new", 666)
    -- Logging.LogInformation("BuildingBase.new %d %s R:%s T:%s", id, callbackRemove, tostring(rotation), tostring(logicPeriod))
    ---@type BuildingStorageLinksBase
    local newInstance = BuildingStorageLinksBase:make(id, type, callbackRemove, location, rotation, logicPeriod, fireWall)
    return newInstance
end

function BuildingStorageLinksBase:initialize(id, type, callbackRemove, location, rotation, logicPeriod, fireWall)
    Logging.LogInformation("BuildingBase:initialize %d, %s, R:%s, T:%s", id, callbackRemove, tostring(rotation), tostring(logicPeriod))
    self._logicPeriod = logicPeriod
    self.Id = id
    self.Type = type
    local objectProperties = Extensions.UnpackObjectProperties(ModObject.GetObjectProperties(id))
    self.Location = location or Point.new(objectProperties.TileX, objectProperties.TileY)
    self.Rotation = rotation or ModBuilding.GetRotation(id)
    self.Name = objectProperties.Name
    self.FireWall = fireWall
    self._callbackRemove = callbackRemove

    ModBuilding.RegisterForBuildingEditedCallback(id, function (buildingUID, editType, newValue) self:OnEditedCallback(buildingUID, editType, newValue); end)
    ModBuilding.RegisterForBuildingStateChangedCallback(id, function (buildingUID, newState) self:OnStateChangedCallback(buildingUID, newState); end )
end

--- func desc
---@return Timer|nil
function BuildingStorageLinksBase:MakeTimer()
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
function BuildingStorageLinksBase:OnEditedCallback(buildingUID, editType, newValue)
    Logging.LogInformation("BuildingBase.OnEditedCallback(%d, %s, %s)", buildingUID, editType, serializeTable(newValue))
    if (editType == BuildingStorageLinksBase.BuildingEditType.Rotate) then
        self:OnRotate(newValue)
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Move) then
        local pointValues = { }
        --string.gmatch(newValue, "(%d+):(%d+)")
        for value in string.gmatch(newValue, "%d+") do
            pointValues[#pointValues + 1] = tonumber(value)
        end
        -- Logging.LogDebug("BuildingEditType.Move %s", serializeTable(pointValues))
        self:OnMove(Point.new(table.unpack(pointValues)))
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
        self:OnRename(newValue)
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Destroy) then
        self:OnDestroy()
    end
end

---@param buildingUID integer
---@param newState any
function BuildingStorageLinksBase:OnStateChangedCallback(buildingUID, newState)
    Logging.LogInformation("BuildingBase.OnStateChangedCallback(%d, %s)", buildingUID, serializeTable(newState))
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil #
---@param oldValue string|Point|nil
---@protected
function BuildingStorageLinksBase:UpdateLogic(editType, oldValue)
    Logging.LogInformation("BuildingBase:UpdateLogic")
end

--- func desc
---@param direction integer # nesw = 0123
---@protected
function BuildingStorageLinksBase:OnRotate(direction)
    Logging.LogInformation("BuildingBase:OnRotate %d", direction)
    self.Rotation = direction
    self:UpdateLogic(BuildingStorageLinksBase.BuildingEditType.Move)
end

--- func desc
---@param newLocation Point #
---@protected
function BuildingStorageLinksBase:OnMove(newLocation)
    Logging.LogInformation("BuildingBase:OnMove %s", newLocation)
    local oldValue = self.Location
    self.Location = newLocation
    self:UpdateLogic(BuildingStorageLinksBase.BuildingEditType.Move, oldValue)
end

--- func desc
---@param newName string # nesw = 0123
---@protected
function BuildingStorageLinksBase:OnRename(newName)
    Logging.LogInformation("BuildingBase:OnRename %s", newName)
    local oldValue = self.Name
    self.Name = newName
    self:UpdateLogic(BuildingStorageLinksBase.BuildingEditType.Rename, oldValue)
end

--- func desc
---@protected
function BuildingStorageLinksBase:OnDestroy()
    Logging.LogInformation("BuildingBase:OnDestroy")
    ModBuilding.UnregisterForBuildingEditedCallback(self.Id)
    ---@note Not exist unsubscrible RegisterForBuildingStateChangedCallback
    -- ModBuilding.RegisterForBuildingStateChangedCallback(id, function (buildingUID, newState) self:OnStateChangedCallback(buildingUID, newState); end )
    self:_callbackRemove()
    self:UpdateLogic(BuildingStorageLinksBase.BuildingEditType.Destroy)
end

function BuildingStorageLinksBase:OnTimerCallback()
    Logging.LogInformation("BuildingBase:OnTimerCallback")
    --local buildingRotation = ModBuilding.GetRotation(self.Id)
    --Logging.LogInformation("buildingRotation: %d", buildingRotation)
end

--- func desc
---@return string|nil
function BuildingStorageLinksBase:GetGroupName()
    local findPattern = StringFindPattern.new("%[[^[]+%]")
        :AfterFind(function (value) return string.sub(value, 2, string.len(value) - 1) end)
    local found = findPattern:Find(self.Name, 1)
    if(found == nil or #found ~= 1 or string.len(found[1]) == 0) then
        return nil
    end
    return found[1]
end

function BuildingStorageLinksBase:UpdateGroup()
    Logging.LogDebug("BuildingStorageLinksBase:UpdateGroup")
    local newGroup = self:GetGroupName()
    Logging.LogDebug("BuildingStorageLinksBase:UpdateGroup %s -> %s", self.Name, ToTypedString(newGroup))

    if (self._groupName ~= nil) then
        self.FireWall:Remove(self.Id)
        self._groupName = nil
    end

    if (newGroup ~= nil) then
        Logging.LogDebug("BuildingStorageLinksBase:UpdateGroup FireWall add [%s] \'%s\' -> \'%s\'", ToTypedString(self.Id), self.Name, ToTypedString(newGroup))
        self.FireWall:Add(self.Id, newGroup)
        self._groupName = newGroup
        --self.FireWall:SetSwitcher(self.Id, newGroupName, self.SwitchState)
    end
end

function BuildingStorageLinksBase:RemoveFromFireWall()
    if(self._groupName ~= nil) then
        self.FireWall:Remove(self.Id)
    end
end