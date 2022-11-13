--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Magnet :BuildingBase #
---@field WorkArea Area #
---@field OutputPoint integer # Direction base rotation
---@field Settings MagnetSettingsItem2 #
Magnet = {
    SupportTypes = {
        Buildings.MagnetCrude,
        Buildings.MagnetGood,
        Buildings.MagnetSuper,
    },
    OutputPoint = 1,
    InputPoint  = nil,
}
Magnet = BuildingBase:extend(Magnet)

---@param id integer #
---@param type string #
---@param callbackRemove fun() #
---@return Magnet
function Magnet.new(id, type, callbackRemove)
    Logging.LogInformation("Magnet.new %d, %s", id, callbackRemove)
    ---@type MagnetSettingsItem2
    local settings = BuildingSettings.GetSettingsByType(type) or error("Magnet Settings not found", 666) or { }

    local instance = Magnet:make(id, type, callbackRemove, nil, nil, settings.UpdatePeriod)
    instance.Settings = settings
    local area = instance.Settings.Area
    instance.WorkArea = instance:GetAreaByPosition(area:Width(), area:Height())
    instance:UpdateLogic()
    return instance
end

--- func desc
---@param editType BuildingEditType # nesw = 0123
---@protected
function Magnet:UpdateLogic(editType)
    Logging.LogInformation("Magnet:UpdateLogic %s", editType)
    if (editType == nil) then
        self:UpdateName()
    elseif (editType == BuildingEditType.Rename) then
        self:UpdateName()
        return
    end
end

function Magnet:OnTimerCallback()
    Logging.LogInformation("Magnet:OnTimerCallback \"%s\" [%s] R:%s", self.Name, self.WorkArea, self.Rotation)
    local location = self.Location
    local outputDelta = DirectionDeltaPoint[(Magnet.OutputPoint + self.Rotation) % 4]
    local outputPoint = Point.new(location.X + outputDelta.X, location.Y + outputDelta.Y)

    local storageId = GetStorageIdOnTile(outputPoint.X, outputPoint.Y)
    if (storageId == nil) then
        return
    end
    -- query storage for min/max
    ---@type UnpackStorageInfo
    local storageInfo = UnpackStorageInfo(ModStorage.GetStorageInfo(storageId))
    if (not storageInfo.Successfully) then
        return
    end

    local buildingProperties = UnpackObjectProperties(ModObject.GetObjectProperties(storageId))
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
    ---@type integer
    local width = self.WorkArea:Width()
    local height = self.WorkArea:Height()

    local startStringWidth, endStringWidth = string.find(self.Name, '%d+x')
    local startStringHeight, endStringHeight = string.find(self.Name, 'x%d+')
    if (startStringWidth ~= nil and endStringWidth ~= nil) then
        ---@type integer
        width = tonumber(string.sub(self.Name, startStringWidth, endStringWidth - 1)) or width
        ---@type integer
        height = tonumber(string.sub(self.Name, startStringHeight + 1, endStringHeight)) or height
    end
    Logging.LogInformation("BasicExtractor:UpdateName limit %d", limit)
    self.WorkArea = self:GetAreaByPosition(width, height)
end

--- func desc
---@param width integer
---@param height integer
function Magnet:GetAreaByPosition(width, height)
    local left = self.Location.X - math.floor(width / 2)
    local top = self.Location.Y - math.floor(height / 2)
    local right = left + width
    local bottom = top + height

    left = math.min(WORLD_LIMITS.Width, math.max(0, left))
    top = math.min(WORLD_LIMITS.Height, math.max(0, top))
    right = math.min(WORLD_LIMITS.Width, math.max(0, right))
    bottom = math.min(WORLD_LIMITS.Height, math.max(0, bottom))

    return Area.new(left, top, right, bottom)
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
    Logging.LogDebug('OnFlightComplete')
    local flyingId = flyingObject.Id
    if (not ModObject.IsValidObjectUID(flyingId)) then
        return
    end

    local storageId = flyingObject.TagerId or -1
    if (storageId == -1) then
        return
    end

   AddItemToStorage(storageId, flyingId)
end