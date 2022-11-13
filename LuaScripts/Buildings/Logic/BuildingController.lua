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

    BuildingController.Init(
        BasicExtractor.Type.Type,
        function (buildingId, buildingType, isBlueprint, isDragging)
            BuildingController.Add(BasicExtractor.new(buildingId, BuildingController.Remove))
        end
    )
end

---@protected
---@param buildingType string
function BuildingController.Init(buildingType, addNewCallback)
    ModBuilding.RegisterForBuildingTypeSpawnedCallback(
        buildingType,
        function (buildingId, buildingType, isBlueprint, isDragging)
            BuildingController.OnSpawnedCallback(buildingId, buildingType, isBlueprint, isDragging, addNewCallback)
        end
    )
end

---@param buildingId integer
---@param buildingType string
---@param isBlueprint boolean
---@param isDragging boolean
---@param addNewCallback BuildingTypeSpawnedCallback
function BuildingController.OnSpawnedCallback(buildingId, buildingType, isBlueprint, isDragging, addNewCallback)
    local position = Point.new(table.unpack(ModObject.GetObjectTileCoord(buildingId)))
    Logging.LogInformation(
        "BuildingBase.OnSpawnedCallback(%d, %s, %s, %s) [%d, %d] %d",
        buildingId,
        buildingType,
        isBlueprint,
        isDragging,
        position.X,
        position.Y,
        ModBuilding.GetRotation(buildingId)
    )

    -- if (isBlueprint or isDragging) then
    --     return
    -- end
    addNewCallback(buildingId, buildingType, isBlueprint, isDragging)
    --BuildingController.OnSpawned(buildingUID, buildingType, isBlueprint, isDragging)
end