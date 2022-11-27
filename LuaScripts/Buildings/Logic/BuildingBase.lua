--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@alias SupportTypesItem { Type :ReferenceValue<string> }|ReferenceValue<string>
---@class SupportTypesBase #{ SupportTypes :SupportTypesItem[]}
---@field SupportTypes SupportTypesItem[]
SupportTypesBase = { }

---@class BuildingBase :Object
---@field _callbackRemove fun()
---@field Id integer
---@field Location Point
---@field Rotation integer
---@field Name string
BuildingBase = {
    BuildingEditType = {
        Rotate = "Rotate",
        Move = "Move",
        Rename = "Rename",
        Destroy = "Destroy"
    }
}
---@type BuildingBase
BuildingBase = Object:extend(BuildingBase)

---@param id integer #
---@param callbackRemove fun() #
---@return BuildingBase
function BuildingBase.new(id, callbackRemove)
    ---@type BuildingBase
    local instance = BuildingBase:make(id, callbackRemove)
    return instance
end

function BuildingBase:initialize(id, callbackRemove)
    Logging.LogDebug("BuildingBase:initialize %d", id)
    local objectProperties = Extensions.UnpackObjectProperties(ModObject.GetObjectProperties(id))
    -- Logging.LogDebug("BuildingBase:initialize ModObject.GetObjectProperties %s", objectProperties)

    self.Id = id
    self.Location = Point.new(objectProperties.TileX, objectProperties.TileY)
    self.Rotation = ModBuilding.GetRotation(id)
    self.Name = objectProperties.Name
    self._callbackRemove = callbackRemove
    Logging.LogInformation("BuildingBase:initialize Id: %d, Location: %d, CallbackRemove: %s, Rotation: %d", id, self.Location, callbackRemove, self.Rotation)

    ModBuilding.RegisterForBuildingEditedCallback(id, function (buildingUID, editType, newValue) self:OnEditedCallback(buildingUID, editType, newValue); end)
    ModBuilding.RegisterForBuildingStateChangedCallback(id, function (buildingUID, newState) self:OnStateChangedCallback(buildingUID, newState); end )
end

--- func desc
---@param buildingUID integer
---@param editType "Rotate"|"Move"|"Rename"|"Destroy"
---@param newValue any
function BuildingBase:OnEditedCallback(buildingUID, editType, newValue)
    Logging.LogInformation("BuildingBase.OnEditedCallback(%d, %s, %s)", buildingUID, editType, newValue)
    if (editType == BuildingStorageLinksBase.BuildingEditType.Rotate) then
        self:OnRotate(newValue)
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Move) then
        ---@type StringFindPattern
        local stringPattern = StringFindPattern.new("%d+:%d+")
        stringPattern:AddChild("%d+")
        local values = stringPattern:Find(newValue)
        Logging.LogDebug("BuildingBase:OnEditedCallback [%s]\n%s -> %s", editType, newValue, values)
        local pointValues = Linq.Select(values or { }, function (key, value) return tonumber(value) end)

        self:OnMove(Point.new(table.unpack(pointValues)))
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
        self:OnRename(newValue)
    elseif (editType == BuildingStorageLinksBase.BuildingEditType.Destroy) then
        self:OnDestroy(newValue)
    end
end

---@param buildingUID integer
---@param newState any
function BuildingBase:OnStateChangedCallback(buildingUID, newState)
    Logging.LogInformation("BuildingBase.OnStateChangedCallback(%d, %s) %d", buildingUID, newState, self.Id)
end

--- func desc
---@param newValue integer
function BuildingBase:OnRotate(newValue)
    Logging.LogDebug("BuildingBase:OnRotate %d %d -> %d", self.Id, self.Rotation, newValue)
    self.Rotation = newValue
end

--- func desc
---@param newValue Point
function BuildingBase:OnMove(newValue)
    Logging.LogDebug("BuildingBase:OnMove %d %s -> %s", self.Id, self.Location, newValue)
    self.Location = newValue
end

--- func desc
---@param newValue string
function BuildingBase:OnRename(newValue)
    Logging.LogDebug("BuildingBase:OnRename %d %s -> %s", self.Id, self.Name, newValue)
    self.Name = newValue
end

--- func desc
---@param newValue string
function BuildingBase:OnDestroy(newValue)
    Logging.LogDebug("BuildingBase:OnDestroy %d %s %s", self.Id, self.Name, newValue)
    ModBuilding.UnregisterForBuildingEditedCallback(self.Id)
end