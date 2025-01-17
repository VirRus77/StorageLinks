--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BuildingController :Object #
---@field _timersStack TimersStack #
---@field Buildings table<integer, BuildingTypedBase> #
---@field BuildingsTypes BuildingTypedBase[]|BuildingFireWallBase[] #
---@field Timers table<integer, string> #
---@field FireWall FireWall #
BuildingController = {
}
---@type BuildingController
BuildingController = Object:extend(BuildingController)

---@param timersStack TimersStack
---@param fireWall FireWall
---@return BuildingController
function BuildingController.new(timersStack, fireWall)
    local instance = BuildingController:make(timersStack, fireWall)
    return instance
end

function BuildingController:initialize(timersStack, fireWall)
    self._timersStack = timersStack
    self.Buildings = { }
    self.Timers = { }
    self.BuildingsTypes = { }
    self.FireWall = fireWall
end

--- func desc
---@param buildingBase BuildingTypedBase
function BuildingController:AddBuildingsType(buildingBase)
    self.BuildingsTypes[#self.BuildingsTypes + 1] = buildingBase
end

--- func desc
---@param typesList BuildingFireWallBase[]|BuildingTypedBase[]|nil
function BuildingController:RegistryTypes(typesList)
    for _, value in pairs(self.BuildingsTypes) do
        local removeFunction = function (removedBuildingBase)
            self:Remove(removedBuildingBase)
        end
        self:InitializeTypes(
            value.SupportTypes,
            function (buildingId, buildingType, isBlueprint, isDragging)
                ---@type BuildingFireWallBase|BuildingTypedBase
                local building = value.new(
                    buildingId,
                    buildingType,
                    removeFunction,
                    self.FireWall
                )
                self:Add(building)
            end
        )
    end

    if (typesList ~= nil and #typesList > 0) then
        for _, value in pairs(typesList) do
            self:AddBuildingsType(value)

            local removeFunction = function (removedBuildingBase)
                self:Remove(removedBuildingBase)
            end
            -- Logging.LogDebug("BuildingController:RegistryTypes \n%s", value.SupportTypes)
            self:InitializeTypes(
                value.SupportTypes,
                function (buildingId, buildingType, isBlueprint, isDragging)
                    ---@type BuildingFireWallBase
                    local building = value.new(
                        buildingId,
                        buildingType,
                        removeFunction,
                        self.FireWall
                    )
                    self:Add(building)
                end
            )
        end
    end
end

---@private
---@param newBuilding BuildingTypedBase
function BuildingController:Add(newBuilding)
    Logging.LogDebug("BuildingController.Add (start)")
    local buildingId = newBuilding.Id
    if (self.Buildings[buildingId] ~= nil) then
        Logging.LogError("BuildingController contains %d", buildingId)
    end
    self.Buildings[buildingId] = newBuilding

    Logging.LogDebug("BuildingController.Add MakeTimer")
    ---@type Timer|nil
    local timer = newBuilding:MakeTimer()
    if (timer) then
       local timerId = self._timersStack:AddTimer(timer)
       Logging.LogDebug("BuildingController.Add MakeTimer timerId=%s", timerId)
       self.Timers[buildingId] = timerId
    end
    Logging.LogDebug("BuildingController.Add (end)")
end

---@param oldBuilding BuildingTypedBase
function BuildingController:Remove(oldBuilding)
    Logging.LogDebug("BuildingController.Remove %d \"%s\"", oldBuilding.Id, oldBuilding.Name)
    local buildingId = oldBuilding.Id
    if (self.Buildings[buildingId] == nil) then
        Logging.LogError("BuildingController.Remove not contains %d", oldBuilding.Id)
        return
    end

    self.Buildings[buildingId] = nil
    local timerId = self.Timers[buildingId]
    if (timerId == nil) then
        Logging.LogWarning("BuildingController.Remove not contains timer %d \"%s\"", oldBuilding.Id, oldBuilding.Name)
        return
    end
    self._timersStack:RemoveTimer(timerId)
    self.Timers[buildingId] = nil
end

---@protected
---@param buildingTypes SupportTypesItem[] #
---@param addNewCallback BuildingTypeSpawnedCallback #
function BuildingController:InitializeTypes(buildingTypes, addNewCallback)
    ---@type string[] #
    local buildingNameTypes = { }
    for _, value in pairs(buildingTypes) do
        if (value.Type ~= nil) then
            buildingNameTypes[#buildingNameTypes + 1] = value.Type.Value
        elseif (value.Value ~= nil) then
            buildingNameTypes[#buildingNameTypes + 1] = value.Value
        else
            error("value.Type == nil and value.Value == nil", 666)
        end
    end

    -- Find exist
    local existBuildings = GetTypedUidsByTypesOnMap(buildingNameTypes)
    for type, ids in pairs(existBuildings) do
        Logging.LogDebug("BuildingController.InitializeTypes Found %s = %d", type, #ids)
        for _, id in pairs(ids) do
            BuildingController.OnSpawnedCallback(id, type, false, false, addNewCallback)
        end
    end

    for _, buildingType in pairs(buildingNameTypes) do
        ModBuilding.RegisterForBuildingTypeSpawnedCallback(
            buildingType,
            function (callBuildingId, callBuildingType, callIsBlueprint, callIsDragging)
                Logging.LogDebug(
                    "ModBuilding.RegisterForBuildingTypeSpawnedCallback(%s, %s, %s, %s)",
                    ToTypedString(callBuildingId),
                    ToTypedString(callBuildingType),
                    ToTypedString(callIsBlueprint),
                    ToTypedString(callIsDragging)
                )
                local makeBuilding = buildingType
                BuildingController.OnSpawnedCallback(callBuildingId, makeBuilding, callIsBlueprint, callIsDragging, addNewCallback)
            end
        )
    end
end

---@param buildingId integer
---@param buildingType string
---@param isBlueprint boolean
---@param isDragging boolean
---@param addNewCallback BuildingTypeSpawnedCallback
function BuildingController.OnSpawnedCallback(buildingId, buildingType, isBlueprint, isDragging, addNewCallback)
    local position = Point.new(table.unpack(ModObject.GetObjectTileCoord(buildingId)))
    Logging.LogInformation(
        "BuildingController.OnSpawnedCallback(%d, %s, %s, %s) (%s) R:%d",
        buildingId,
        buildingType,
        isBlueprint,
        isDragging,
        position,
        ModBuilding.GetRotation(buildingId)
    )

    addNewCallback(buildingId, buildingType, isBlueprint, isDragging)
end