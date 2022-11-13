--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BuildingController #
---@field Id integer # Building UID
---@field Location Point #
---@field Rotation integer #
---@field Timer? Timer #
BuildingController = {
    ---@type table<integer, BuildingBase>
    Buildings = {},
    Timers = {}
}

---@param newBuilding BuildingBase
function BuildingController.Add(newBuilding)
    Logging.LogError("BuildingController.Add")
    local buildingId = newBuilding.Id
    if(BuildingController.Buildings[buildingId] ~= nil) then
        Logging.LogError("BuildingController contains %d", buildingId)
    end
    BuildingController.Buildings[buildingId] = newBuilding

    Logging.LogError("BuildingController.Add MakeTimer")
    local timer = newBuilding:MakeTimer()
    if (timer) then
       local timerId = TimersStack.AddTimer(timer)
       Logging.LogError("BuildingController.Add MakeTimer timerId=%s", timerId)
       BuildingController.Timers[buildingId] = timerId
    end
end

---@param oldBuilding BuildingBase
function BuildingController.Remove(oldBuilding)
    Logging.LogDebug("BuildingController.Remove")
    local buildingId = oldBuilding.Id
    if (BuildingController.Buildings[buildingId] == nil) then
        Logging.LogError("BuildingController not contains %d", oldBuilding.Id)
        return
    end

    BuildingController.Buildings[buildingId] = nil
    local timerId = BuildingController.Timers[buildingId]
    if (timerId ~= nil) then
        TimersStack.RemoveTimer(timerId)
        BuildingController.Timers[buildingId] = nil
    end
end

function BuildingController.Initialize()
    BuildingController.Buildings = { }
    BuildingController.Timers = { }

    -- Extractor
    BuildingController.InitializeTypes(
        BasicExtractor.SupportTypes,
        function (buildingId, buildingType, isBlueprint, isDragging)
            ---@type BuildingBase
            local building = BasicExtractor.new(buildingId, buildingType, BuildingController.Remove)
            BuildingController.Add(building)
        end
    )

    -- Magnet
    BuildingController.InitializeTypes(
        Magnet.SupportTypes,
        function (buildingId, buildingType, isBlueprint, isDragging)
            ---@type BuildingBase
            local building = Magnet.new(buildingId, BuildingController.Remove)
            BuildingController.Add(building)
        end
    )
end

---@protected
---@param buildingTypes { Type :string }[] #
---@param addNewCallback BuildingTypeSpawnedCallback #
function BuildingController.InitializeTypes(buildingTypes, addNewCallback)
    ---@type string[] #
    local buildingNameTypes = { }
    for _, value in ipairs(buildingTypes) do
        buildingNameTypes[#buildingNameTypes + 1] = value.Type
    end

    local existBuildings = GetTypedUidsByTypesOnMap(buildingNameTypes)
    for type, ids in pairs(existBuildings) do
        Logging.LogDebug("BuildingController.InitializeTypes Found %s = %d", type, #ids)
        for _, id in ipairs(ids) do
            BuildingController.OnSpawnedCallback(id, type, false, false, addNewCallback)
        end
    end

    for _, buildingType in ipairs(buildingNameTypes) do
        ModBuilding.RegisterForBuildingTypeSpawnedCallback(
            buildingType,
            function (callBuildingId, callBuildingType, callIsBlueprint, callIsDragging)
                BuildingController.OnSpawnedCallback(callBuildingId, callBuildingType, callIsBlueprint, callIsDragging, addNewCallback)
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

    -- if (isBlueprint or isDragging) then
    --     return
    -- end
    addNewCallback(buildingId, buildingType, isBlueprint, isDragging)
    --BuildingController.OnSpawned(buildingUID, buildingType, isBlueprint, isDragging)
end