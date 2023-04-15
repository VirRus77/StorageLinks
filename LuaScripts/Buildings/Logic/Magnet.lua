--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Magnet :BuildingFireWallBase #
---@field base BuildingFireWallBase
---@field WorkArea Area #
---@field OutputPoint Point # Direction base rotation
---@field _settings MagnetSettingsItem2
Magnet = {
    SupportTypes = {
        Buildings.MagnetCrude.Type,
        Buildings.MagnetGood.Type,
        Buildings.MagnetSuper.Type,
    },
}
---@type Magnet
Magnet = BuildingFireWallBase:extend(Magnet)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@param fireWall FireWall
---@return Magnet
function Magnet.new(id, type, callbackRemove, fireWall)
    Logging.LogInformation("Magnet.new %d, %s", id, callbackRemove)
    ---@type Magnet
    local instance = Magnet:make(id, type, callbackRemove, fireWall)
    return instance
end

function Magnet:initialize(id, type, callbackRemove, fireWall)
    BuildingFireWallBase.initialize(self, id, type, callbackRemove, fireWall)
    local area = self._settings.Area
    self.WorkArea = self:GetAreaByPosition(area:Width(), area:Height())
    self.OutputPoint = self._settings.OutputPoint
    self:OnRename(self.Name)
    -- Logging.LogDebug("Magnet:initialize %s", self)
end

-- --- func desc
-- ---@param editType BuildingBase.BuildingEditType|nil # nesw = 0123
-- ---@param oldValue Point|nil
-- ---@protected
-- function Magnet:UpdateLogic(editType, oldValue)
--     Logging.LogInformation("Magnet:UpdateLogic %s", editType)
--     if (editType == nil) then
--         self:UpdateName()
--     elseif (editType == BuildingStorageLinksBase.BuildingEditType.Rename) then
--         self:UpdateName()
--         return
--     elseif (editType == BuildingStorageLinksBase.BuildingEditType.Destroy) then
--         self:RemoveFromFireWall()
--     end
-- end

function Magnet:OnTimerCallback()
    local sw = Stopwatch.Start()
    BuildingFireWallBase.OnTimerCallback(self)
    if (self._fireWall:Skip(self.Id)) then
        Logging.LogDebug("Magnet:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
        return
    end
    -- Logging.LogInformation("Magnet:OnTimerCallback \"%s\" [%s] R:%s", self.Name, self.WorkArea, self.Rotation)
    local location = self.Location
    local outputRotate = Point.Rotate(self.OutputPoint, self.Rotation)
    local outputPoint =  Point.new(location.X + outputRotate.X, location.Y + outputRotate.Y)

    local storageId = GetStorageIdOnTile(outputPoint.X, outputPoint.Y)
    if (storageId == nil) then
        Logging.LogDebug("Magnet:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
        return
    end
    -- query storage for min/max
    ---@type UnpackStorageInfo
    local storageInfo = Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(storageId))
    if (not storageInfo.Successfully) then
        Logging.LogDebug("Magnet:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
        return
    end

    local buildingProperties = Extensions.UnpackObjectProperties(ModObject.GetObjectProperties(storageId))
    if (not buildingProperties.Successfully) then
        Logging.LogDebug("Magnet:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
        return
    end

    local captureQuantity = self:CaptureQuantity(storageId, storageInfo, OBJECTS_IN_FLIGHT)
    if (captureQuantity == 0) then
        Logging.LogDebug("Magnet:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
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
    if (holdables == nil or #holdables == 0) then
        Logging.LogDebug("Magnet:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
        return
    end

    local countCapture = 0
    for _, holdableId in pairs(holdables) do
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
                flightObject:Start(self._settings.Speed, self._settings.Height)
                OBJECTS_IN_FLIGHT:Add(flightObject)
                countCapture = countCapture + 1
        end
    end
    Logging.LogDebug("Magnet:OnTimerCallback Id: %d SW: \"%s\"", self.Id, sw.ToTimeSpanString(sw:Elapsed()))
end

function Magnet:OnRotate(newValue)
    BuildingFireWallBase.OnRotate(self, newValue)
    self:UpdateWorkArea()
end

function Magnet:OnMove(newValue)
    BuildingFireWallBase.OnMove(self, newValue)
    self:UpdateWorkArea()
end

function Magnet:OnRename(newValue)
    Logging.LogInformation("Magnet:UpdateName %d %s -> %s", self.Id, self.Name, newValue)
    BuildingFireWallBase.OnRename(self, newValue)

    self:UpdateWorkArea()
    self:UpdateGroup()
    -- Logging.LogDebug("Magnet:UpdateName WorkArea: %s", self.WorkArea)
end

function Magnet:UpdateWorkArea()
    local areaByName = self:GetAreaByName()
    local positionAreaByName = self:GetPositionAreaByName()
    if (areaByName ~= nil) then
        self.WorkArea = areaByName
    elseif (positionAreaByName ~= nil) then
        self.WorkArea = positionAreaByName
    else
        self.WorkArea = self:GetAreaByPosition(self._settings.Area:Width(), self._settings.Area:Height())
    end
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
    if (found == nil or #found ~= 2)then
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
    area = WORLD_LIMITS:ApplyLimits(area)

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
    area = WORLD_LIMITS:ApplyLimits(area)
    return area
end

--- func desc
---@param storageId integer
---@param storageProperties UnpackStorageInfo
---@param objectInFly FlightObjectsList|nil
function Magnet:CaptureQuantity(storageId, storageProperties, objectInFly)
    local countFlyToStorage = { }
    if (objectInFly ~= nil) then
        countFlyToStorage = objectInFly:FlightObjectByTarget(storageId)
    end

    local countByMagnet = 0
    for _, value in pairs(countFlyToStorage) do
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

    local countInOnetime = self._settings.CountOneTime
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
