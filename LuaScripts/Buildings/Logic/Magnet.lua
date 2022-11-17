--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Magnet :BuildingBase #
---@field WorkArea Area #
---@field OutputPoint Point # Direction base rotation
---@field Settings MagnetSettingsItem2 #
Magnet = {
    SupportTypes = {
        Buildings.MagnetCrude,
        Buildings.MagnetGood,
        Buildings.MagnetSuper,
    },
    OutputPoint = Point.new(1, 0),
}
---@type Magnet
Magnet = BuildingBase:extend(Magnet)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@return Magnet
function Magnet.new(id, type, callbackRemove)
    Logging.LogInformation("Magnet.new %d, %s", id, callbackRemove)
    ---@type MagnetSettingsItem2
    local settings = BuildingSettings.GetSettingsByType(type) or error("Magnet Settings not found", 666) or { }

    ---@type Magnet
    local instance = Magnet:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod)
    instance.Settings = settings
    local area = instance.Settings.Area
    instance.WorkArea = instance:GetAreaByPosition(area:Width(), area:Height())
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
---@param oldValue Point|nil
---@protected
function Magnet:UpdateLogic(editType, oldValue)
    Logging.LogInformation("Magnet:UpdateLogic %s", editType)
    if (editType == nil) then
        self:UpdateName()
    elseif (editType == BuildingBase.BuildingEditType.Rename) then
        self:UpdateName()
        return
    end
end

function Magnet:OnTimerCallback()
    -- Logging.LogInformation("Magnet:OnTimerCallback \"%s\" [%s] R:%s", self.Name, self.WorkArea, self.Rotation)
    local location = self.Location
    local outputRotate = Point.Rotate(self.OutputPoint, self.Rotation)
    local outputPoint =  Point.new(location.X + outputRotate.X, location.Y + outputRotate.Y)

    local storageId = GetStorageIdOnTile(outputPoint.X, outputPoint.Y)
    if (storageId == nil) then
        return
    end
    -- query storage for min/max
    ---@type UnpackStorageInfo
    local storageInfo = Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(storageId))
    if (not storageInfo.Successfully) then
        return
    end

    local buildingProperties = Extensions.UnpackObjectProperties(ModObject.GetObjectProperties(storageId))
    if (not buildingProperties.Successfully) then
        return
    end

    local captureQuantity = self:CaptureQuantity(storageId, storageInfo)
    if (captureQuantity == 0) then
        return
    end

    local workArea = self.WorkArea
    local holdables = ModTiles.GetObjectUIDsOfType(
        storageInfo.TypeStores,
        workArea.Left,
        workArea.Top,
        workArea.Right,
        workArea.Bottom
    )
    if(holdables == nil or holdables[1] == nil) then
        return
    end
    local countCapture = 0
    for _, holdableId in ipairs(holdables) do
        if (countCapture >= captureQuantity) then
            break
        end

        if (not OBJECTS_IN_FLIGHT:Contains(holdableId)) then
            local from = Point.new(table.unpack(ModObject.GetObjectTileCoord(holdableId)))
            local to = Point.new(buildingProperties.TileX, buildingProperties.TileY)
            local flightObject = FlightObject.new(
                    holdableId,
                    storageId,
                    self.Id,
                    from,
                    to,
                    Magnet.OnFlightComplete
                )
                flightObject:Start(self.Settings.Speed, self.Settings.Height)
                OBJECTS_IN_FLIGHT:Add(flightObject)
                countCapture = countCapture + 1
        end
    end
end

function Magnet:UpdateName()
    Logging.LogInformation("Magnet:UpdateName %s", self.Name)
    ---@type integer
    local limit = 1
    local areaByName = self:GetAreaByName()
    local positionAreaByName = self:GetPositionAreaByName()

    if (areaByName ~= nil) then
        self.WorkArea = areaByName
    elseif (positionAreaByName ~= nil) then
        self.WorkArea = positionAreaByName
    else
        self.WorkArea = self:GetAreaByPosition(self.Settings.Area:Width(), self.Settings.Area:Height())
    end
    Logging.LogDebug("Magnet:UpdateName WorkArea: %s", self.WorkArea)
end

--- func desc
---@param storageId integer
---@param storageProperties UnpackStorageInfo
function Magnet:CaptureQuantity(storageId, storageProperties)
    local countFlyToStorage = OBJECTS_IN_FLIGHT:FlightObjectByTarget(storageId)
    local countByMagnet = 0
    for _, value in ipairs(countFlyToStorage) do
        if (value.InitiatorId == self.Id) then
            countByMagnet = countByMagnet + 1
        end
    end
    local countFlying = #countFlyToStorage

    if (not storageProperties.Successfully) then
        return 0
    end

    if storageProperties.AmountStored == nil then
        return 0
    end
    if storageProperties.Capacity == nil then
        return 0
    end

    -- Adjust max to be "how many could actually fit into crate"
    local maxCanCollect = storageProperties.Capacity - storageProperties.AmountStored - countFlying

    local countInOnetime = self.Settings.CountOneTime
    maxCanCollect = math.max(0, math.min(countInOnetime, maxCanCollect, countInOnetime - countByMagnet))
    return maxCanCollect
end

--- func desc
---@param flyingObject FlightObject
---@param successfully boolean
function Magnet.OnFlightComplete(flyingObject, successfully)
    -- Logging.LogDebug(' OnFlightComplete(successfully = %s)\n%s', successfully, serializeTable(flyingObject))
    local flyingId = flyingObject.Id
    if (not ModObject.IsValidObjectUID(flyingId)) then
        return
    end

    local storageId = flyingObject.TagerId or -1
    if (storageId == -1) then
        return
    end

    StorageTools.AddItemToStorage(storageId, flyingId)
end

---@return Area|nil
function Magnet:GetPositionAreaByName()
    local findPattern = StringFindPattern.new("%d+x%d+")
    findPattern:AddChild("%d+")
    ---@type integer
    local width = self.WorkArea:Width()
    ---@type integer
    local height = self.WorkArea:Height()

    local found = findPattern:Find(self.Name, 1)
    if(found == nil or #found ~= 2)then
        return nil
    end
    if (found ~= nil and #found == 2) then
       width = tonumber(found[1]) or error("cant parse to number: " .. found[1], 666) or width
       height = tonumber(found[2]) or error("cant parse to number: " .. found[2], 666) or width
    end
    -- Logging:LogDebug("Magnet:GetPositionAreaByName: %d %d", width, height)
    return self:GetAreaByPosition(width, height)
end

--- func desc
---@param width integer
---@param height integer
---@return Area
function Magnet:GetAreaByPosition(width, height)
    local left = self.Location.X - math.floor(width / 2)
    local top = self.Location.Y - math.floor(height / 2)
    local right = left + width
    local bottom = top + height

    local area = Area.new(left, top, right, bottom)
    WORLD_LIMITS:ApplyLimits(area)

    return area
end

--- func desc
---@return Area|nil
function Magnet:GetAreaByName()
    local findPattern = StringFindPattern.new("{%s*%d+%s*,%s*%d+%s*;%s*%d+%s*,%s*%d+%s*}")
    findPattern:AddChild("%d+")
    ---@type integer

    ---@type string[]|nil
    local found = findPattern:Find(self.Name, 1)
    --Logging.LogDebug("Magnet:GetAreaByName #found: %d found: %s", #found, found)

    if (found == nil or #found ~= 4) then
        return nil
    end

    ---@type integer[]
    local values = { }
    for i = 1, 4, 1 do
        values[#values + 1] = tonumber(found[i]) or error("cant parse to number: " .. found[i], 666) or 0
    end
    -- Logging.LogDebug("Magnet:GetAreaByName values: %s", values)
    local area = Area.new(table.unpack(values))
    WORLD_LIMITS:ApplyLimits(area)
    return area
end