-- Magnets
function discoverUnknownMagnets()
    locateMagnets(BuildingLevels.Crude)
    locateMagnets(BuildingLevels.Good)
    locateMagnets(BuildingLevels.Super)
end

--- func desc
---@param buildingLevel BuildingLevels
function locateMagnets(buildingLevel)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug("locateMagnets ", serializeTable({
            buildingLevel = buildingLevel
            })
        )
    end

    ---@type string[]
    local buildingTypes = {}
    if (buildingLevel == BuildingLevels.Crude) then
        buildingTypes = { Buildings.MagnetCrude.Type }
    end
    if (buildingLevel == BuildingLevels.Good) then
        buildingTypes = { Buildings.MagnetGood.Type }
    end
    if (buildingLevel == BuildingLevels.Super) then
        buildingTypes = { Buildings.MagnetSuper.Type }
    end

    -- Create EVENT to catch when new ones are added
    if ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION) then
        if ModBase.ClassAndMethodExist('ModBuilding', 'RegisterForBuildingTypeSpawnedCallback') then
            for _, value in ipairs(buildingTypes) do
                ModBuilding.RegisterForBuildingTypeSpawnedCallback(value, OnMagnetSpawn)
            end
        end
    end

    -- Find all Magnets
    --local magnetUIDs = ModBuilding.GetBuildingUIDsOfType(buildingLevel .. ' Magnet (SL)', 0, 0, WORLD_LIMITS[1]-1, WORLD_LIMITS[2]-1)
    local magnetUIDs = GetUidsByTypesOnMap(buildingTypes)

    -- quit if none
    if magnetUIDs == nil or magnetUIDs[1] == nil then
        return
    end

    -- List the magnets if in debug mode
    if (Settings.DebugMode.Value) then
        Logging.LogDebug("locateMagnets:", serializeTable({
            magnetUIDs = magnetUIDs
        }))
    end

    -- handle each magnet
    for _, uid in ipairs(magnetUIDs)
    do
        if LINK_UIDS[uid] == nil then
            locateStorageForMagnet(uid)
        end
    end

end

--- Spawn new magnet.
---@param buildingUID number
---@param buildingType string
---@param isBlueprint boolean
---@param isDragging boolean
function OnMagnetSpawn(buildingUID, buildingType, isBlueprint, isDragging)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug("onMagnetSpawn ", serializeTable({
            BuildingUID = buildingUID,
            BuildingType = buildingType,
            IsBlueprint = isBlueprint,
            IsDragging = isDragging
        }))
    end

    if isDragging then
        return
    end

    if isBlueprint then
        return
    end

    locateStorageForMagnet(buildingUID)
end

--- func desc
---@param magnetUID number
function locateStorageForMagnet(magnetUID)
    local storageUID, dir
    local magStorage = {}

    if (Settings.DebugMode.Value) then
        Logging.LogDebug(string.format("locateStorageForMagnet(magnetUID = %d )", magnetUID) )
    end

    local properties = UnpackObjectProperties( ModObject.GetObjectProperties(magnetUID) )
    if (not properties.Successfully) then
        Logging.LogWarning(string.format("locateStorageForMagnet(magUID = %d). Properties not readed.", magnetUID))
        return
    end

    if (Settings.DebugMode.Value) then
        Logging.LogDebug(string.format("locateStorageForMagnet(magUID = %d). Properties readed.", magnetUID))
        Logging.LogTrace(string.format("locateStorageForMagnet(magUID = %d).\n", magnetUID), serializeTable(properties, "properties"))
    end

    -- Cache the Link
    local buildingLevel = Buildings.GetMagnetLevel (properties.Type)

    -- the only place for detecting rotation of magnet.
    ---@type NESW #
    local direction = "n"
    if properties.Rotation == 270 then direction = 'n' end
    if properties.Rotation == 0   then direction = 'e' end
    if properties.Rotation == 90  then direction = 's' end
    if properties.Rotation == 180 then direction = 'w' end

    local x, y = tileXYFromDir(Point.new(properties.TileX, properties.TileY), direction)
    LINK_UIDS[magnetUID] = {
        bType         = properties.Type,
        tileX         = properties.TileX,
        tileY         = properties.TileY,
        rotation      = properties.Rotation,
        name          = properties.Name,
        buildingLevel = buildingLevel,
        connectToXY   = { x, y }
    }

    if (Settings.DebugMode.Value) then
        Logging.LogTrace(string.format("locateStorageForMagnet(magUID = %d).\n", magnetUID), serializeTable ( LINK_UIDS[magnetUID],  "LINK_UIDS[magUID]"))
    end

    -- !!! NOT IMPLIMENTED !!!
    -- if ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION) then
    --     -- Make sure we have a callback for when magnet is renamed
    --     if ModBase.ClassAndMethodExist('ModBuilding', 'RegisterForBuildingRenamedCallback') then
    --         ModBuilding.RegisterForBuildingRenamedCallback(magnetUID, magnetNameUpdated)
    --         Logging.LogDebug("call ModBuilding.RegisterForBuildingRenamedCallback(", magnetUID, ")")
    --     end
    --     -- Make sure we have a callback for when a magnet is moved / rotated
    --     if ModBase.ClassAndMethodExist('ModBuilding', 'RegisterForBuildingRepositionedCallback') then
    --         ModBuilding.RegisterForBuildingRepositionedCallback(magnetUID, magnetRepositioned)
    --         Logging.LogDebug("call ModBuilding.RegisterForBuildingRepositionedCallback(", magnetUID, ")")
    --     end
    --     -- And if the magnet is destroyed?
    --     if ModBase.ClassAndMethodExist('ModBuilding', 'RegisterForBuildingDestroyedCallback') then
    --         ModBuilding.RegisterForBuildingDestroyedCallback(magnetUID, linkDestroyed)
    --         Logging.LogDebug("call ModBuilding.RegisterForBuildingDestroyedCallback(", magnetUID, ")")
    --     end
    -- end

    addStorageForMagnet(magnetUID)
end

--- func desc
---@param magnetId integer
function addStorageForMagnet(magnetId)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug(string.format('addStorageForMagnet (magUID = %d)', magnetId))
    end
    local storageUID = storageUidOnTileWithCallbacks(LINK_UIDS[magnetId].connectToXY[1], LINK_UIDS[magnetId].connectToXY[2])

    if storageUID == nil then
        return false
    end -- no storage there.

    addStorageToMagnet(magnetId, storageUID)
end

--- func desc
---@param magnetId integer
---@param storageId integer
function addStorageToMagnet(magnetId, storageId)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug('addStorageToMagnet( magUID = %d, storageUID = %d )\n', magnetId, storageId)
    end

    local storageInfo = UnpackStorageInfo(ModStorage.GetStorageInfo(storageId))

    if (not storageInfo.Successfully) then
        Logging.LogWarning('addStorageToMagnet( magUID = %d, storageUID = %d ) %s', magnetId, storageId, "Not found storage info.")
        return
    end

    -- if sProps[2] == nil then return false end -- Was not actually a storage.

    -- Cache the storageUID
    local properties = UnpackObjectProperties (ModObject.GetObjectProperties(storageId))
    if (not properties.Successfully) then
        Logging.LogWarning(string.format("addStorageToMagnet(magUID = %d, storageUID = %d). Properties not readed.", magnetId, storageId))
        return
    end

    -- Create if needed
    if (STORAGE_UIDS[storageId] == nil) then
        STORAGE_UIDS[storageId] = { linkUIDs = {} }
    end

    -- Set properties
    STORAGE_UIDS[storageId].bType     = properties.Type
    STORAGE_UIDS[storageId].tileX     = properties.TileX
    STORAGE_UIDS[storageId].tileY     = properties.TileY
    STORAGE_UIDS[storageId].rotation  = properties.Rotation
    STORAGE_UIDS[storageId].name      = properties.Name
    STORAGE_UIDS[storageId].sType     = storageInfo.TypeStores -- type stored or NIL if no type yet...
    STORAGE_UIDS[storageId].linkUIDs  = AddIfNotExist(STORAGE_UIDS[storageId].linkUIDs, magnetId) -- each storage might have multiple links of any kind

    -- Put storage UID in magnets cache.
    LINK_UIDS[magnetId].storageUID = storageId
    magnetNameUpdated(magnetId, LINK_UIDS[magnetId].name) -- this sets up the area

    -- -- Make sure we have a callback for when the storage is moved/rotated/destroyed
    -- if ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION) then
    --     if ModBase.ClassAndMethodExist('ModBuilding','RegisterForBuildingRepositionedCallback') then
    --         ModBuilding.RegisterForBuildingRepositionedCallback(storageUID, storageRepositioned)
    --     end
    --     if ModBase.ClassAndMethodExist('ModBuilding','RegisterForBuildingDestroyedCallback') then
    --         ModBuilding.RegisterForBuildingDestroyedCallback(storageUID, storageDestroyed)
    --     end
    --     if ModBase.ClassAndMethodExist('ModBuilding','RegisterForStorageItemChangedCallback') then
    --         ModBuilding.RegisterForStorageItemChangedCallback(storageUID, storageItemChanged)
    --     end
    -- end

    if (Settings.DebugMode.Value) then
        Logging.LogDebug(string.format(' locateStorageForMagnet: storageInfo.TypeStores %s of $d', storageInfo.TypeStores, storageId))
    end
end

--- func desc
---@param magnetId integer
---@param objectName string
function magnetNameUpdated(magnetId, objectName)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug('magnetNameUpdated ( magnetId = %d, objectName = %s ) ', magnetId, objectName)
    end

    -- Does the magnet exist in the tracker?
    if LINK_UIDS[magnetId] == nil then
        return false
    end

    -- Update in tracker
    LINK_UIDS[magnetId].name = objectName -- '40x40'

    -- Does storageUID exist for magnet?
    if LINK_UIDS[magnetId].storageUID == nil then
        return false
    end

    -- Update area for storage UID!
    -- {left = left, top = top, right = right, bottom = bottom}
    LINK_UIDS[magnetId].area = getAreaForMagnetStorage(LINK_UIDS[magnetId], STORAGE_UIDS[LINK_UIDS[magnetId].storageUID])

    if (Settings.DebugMode.Value) then
        Logging.LogDebug('magnetNameUpdated end: ', serializeTable( LINK_UIDS[magnetId] ))
    end
end

-- function MagnetRepositioned(magnetId, BuildingType, Rotation, TileX, TileY, IsBlueprint, IsDragging)
--     if (Settings.DebugMode.Value) then
--         Logging.LogDebug('magnetRepositioned( MagnetUID = $d, BuildingType = %s, Rotation = %d, TileX = %d, TileY = %d, IsBlueprint = %s, IsDragging = %s)', magnetId, BuildingType, Rotation, TileX, TileY, IsBlueprint, IsDragging)
--     end
-- 
--     if IsDragging then
--         return false
--     end
--     if IsBlueprint then
--         return false
--     end
--     if (Settings.DebugMode.Value) then
--         Logging.LogDebug(' magnetRepositioned (%d) ', magnetId)
--     end
--     resetCachedLink(magnetId)
-- end

function fireAllMagnets(buildingLevel)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug('fireAllMagnets( buildingLevel = %s )', buildingLevel)
    end

    ---@type string[]
    local magnetType = {}
    if (buildingLevel == BuildingLevels.Crude) then
        magnetType = { Buildings.MagnetCrude.Type }
    end
    if (buildingLevel == BuildingLevels.Good) then
        magnetType = { Buildings.MagnetGood.Type }
    end
    if (buildingLevel == BuildingLevels.Super) then
        magnetType = { Buildings.MagnetSuper.Type }
    end

    local magnetSettings = Buildings.GetMagnetSettings(buildingLevel)
    -- loop over cached magnets
    for _, magnetType in ipairs(magnetType) do
        for uid, props in pairs(LINK_UIDS) do
            if (props.bType == magnetType) then
                if props.storageUID ~= nil then
                    -- Is there now a storage there?
                end
                fireMagnetById(uid, magnetSettings)
            end
        end
    end
end

--- func desc
---@param magnetId integer
---@param magnetSettings MagnetSettingsItem
function fireMagnetById(magnetId, magnetSettings)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug('fireMagnetByUID ( magnetId = %d ) (a)', magnetId)
    end
    -- looking in area for items that can be picked up.
    if USE_EVENT_STYLE == false then
        updateLinkPropsAsNeeded(magnetId)
        -- Does it still exist?
        if LINK_UIDS[magnetId] == nil then
            return
        end
        if (Settings.DebugMode.Value) then
            Logging.LogDebug(' fireMagnetByUID: (b) ', magnetId)
        end
        -- no more storage attached?
        if LINK_UIDS[magnetId].storageUID == nil then
            addStorageForMagnet(magnetId)
        end -- Heavy calcs here...
        -- Still no storage? then we quit.
        if LINK_UIDS[magnetId].storageUID == nil then return end
        if (Settings.DebugMode.Value) then
            Logging.LogDebug(' fireMagnetByUID: (c) ', magnetId)
        end
        -- What if the storage itself moved?
        updateStoragePropsAsNeeded(LINK_UIDS[magnetId].storageUID)
        if (Settings.DebugMode.Value) then
            Logging.LogDebug(' fireMagnetByUID: (d) ', magnetId)
        end
    end

    -- If there are no storages here, exit!
    if LINK_UIDS[magnetId].storageUID == nil then
        return
    end

    -- How many can we put in crate?
    local maxQuantity = QuantityToGrabForMagnet(magnetId, magnetSettings)
    if (maxQuantity == 0) then
        return
    end
    -- Get them
    findAndCollectHoldablesIntoMagneticStorage(magnetId, maxQuantity, magnetSettings)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug(' fireMagnetByUID: (g) ', magnetId)
    end
end

---@param magnetUID integer
---@param magnetSettings MagnetSettingsItem
function QuantityToGrabForMagnet(magnetUID, magnetSettings)
    local linkUid = LINK_UIDS[magnetUID]
    -- Figure out how many are already moving through the air, and if that is greater than allowed by the level, then return 0;
    local alreadyFlyingForStorage = OBJECTS_IN_FLIGHT:FlightObjectByTarget(linkUid.storageUID)
    local countByInitiator = 0
    for _, value in ipairs(alreadyFlyingForStorage) do
        if (value.InitiatorId == magnetUID) then
            countByInitiator = countByInitiator + 1
        end
    end
    local alreadyFlyingQty = #alreadyFlyingForStorage

    -- query storage for min/max
    local storageProperties = UnpackStorageInfo(ModStorage.GetStorageInfo(linkUid.storageUID))

    if (not storageProperties.Successfully) then
        return 0
    end

    if storageProperties.AmountStored == nil then
        return 0
    end
    if storageProperties.Capacity == nil then
        return 0
    end

    -- if crate is full, return 0
    if (storageProperties.AmountStored >= storageProperties.Capacity) then
        return 0
    end

    -- Adjust max to be "how many could actually fit into crate"
    local maxCanCollect = storageProperties.Capacity - storageProperties.AmountStored - alreadyFlyingQty

    -- if qty flying will fill up crate, return 0
    if maxCanCollect <= 0 then
        return 0
    end

    local countInOnetime = magnetSettings.CountOneTime
    maxCanCollect = math.max(0, math.min(countInOnetime, maxCanCollect, countInOnetime - countByInitiator))

    return maxCanCollect
end

--- func desc
---@param magnetName string
---@param posX integer
---@param posY integer
---@return { left :integer, top :integer, right :integer, bottom :integer } #
function getMagnetArea(magnetName, posX, posY)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug("getMagnetArea(magnetName = %s, posX = %d, posY = %d)", magnetName, posX, posY)
    end

    -- Calculate AREA or SIZE from the name. default to 10x10
    local w1, w2 = string.find(magnetName, '%d+x')
    local h1, h2 = string.find(magnetName, 'x%d+')
    ---@type number?
    local width  = 10 -- default height
    ---@type number?
    local height = 10 -- default width

    if (Settings.DebugMode.Value) then
        Logging.LogDebug('getMagnetArea: w1: %d w2: %d', w1, w2 )
        Logging.LogDebug('getMagnetArea: h1: %d h2: %d', h1, h2 )
    end

    if w1 ~= nil then
        width  = tonumber(string.sub(magnetName, w1    , w2 - 1))
    end
    if h1 ~= nil then
        height = tonumber(string.sub(magnetName, h1 + 1, h2    ))
    end

    ---@type integer
    local left = posX - math.floor(width / 2)
    ---@type integer
    local top = posY  - math.floor(height / 2)
    ---@type integer
    local right = left + width
    ---@type integer
    local bottom = top + height

    -- Limit to map limits!!
    left = math.max(left, 0)
    top = math.max(top, 0)
    right = math.min(right, WORLD_LIMITS.Width)
    bottom = math.min(bottom, WORLD_LIMITS.Height)

    local result = { left = left, top = top, right = right, bottom = bottom }
    if (Settings.DebugMode.Value) then
        Logging.LogDebug('getMagnetArea %s ', serializeTable( result ) )
    end

    return result
end

--- func desc
---@param magProps LINK_UIDS_Item
---@param storProps STORAGE_UIDS_Item
---@return { left :integer, top :integer, right :integer, bottom :integer }
function getAreaForMagnetStorage(magProps, storProps)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug('getAreaForMagnetStorage:\n%s', serializeTable({magProps = magProps, storProps = storProps}) )
    end

    local result = getMagnetArea( magProps.name, storProps.tileX, storProps.tileY )
    if (Settings.DebugMode.Value) then
        Logging.LogDebug(' getAreaForMagnetStorage: area: ', serializeTable( result ) )
    end

    return result
end

--- func desc
---@param magnetId integer
---@param maxQty integer
---@param magnetSettings MagnetSettingsItem
function findAndCollectHoldablesIntoMagneticStorage(magnetId, maxQty, magnetSettings)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug('findAndCollectHoldablesIntoMagneticStorage(magnetUID = %d, maxQty = %d) (a)\n%s',magnetId, maxQty, table.show(LINK_UIDS[magnetId].area))
    end
    if LINK_UIDS[magnetId] == nil then
        Logging.LogDebug('LINK_UIDS[magnetUID] == nil')
        return
    end
    if STORAGE_UIDS[LINK_UIDS[magnetId].storageUID] == nil then
        Logging.LogDebug('STORAGE_UIDS[LINK_UIDS[magnetUID].storageUID] == nil')
        return
    end

    -- Get all items of sType in area
    --local holdables = ModTiles.GetObjectsOfTypeInAreaUIDs(
    local magnetArea = LINK_UIDS[magnetId].area
    local holdables = ModTiles.GetObjectUIDsOfType(
        STORAGE_UIDS[LINK_UIDS[magnetId].storageUID].sType,
        magnetArea.left,
        magnetArea.top,
        magnetArea.right,
        magnetArea.bottom
    )
    if (Settings.DebugMode.Value) then
        Logging.LogDebug(' findAndCollectHoldablesIntoMagneticStorage: holdables ', holdables )
    end
    if (Settings.DebugMode.Value) then
        Logging.LogDebug(' findAndCollectHoldablesIntoMagneticStorage: holdables ', table.show(holdables) )
    end
    Logging.LogTrace('holdables: ', #holdables)

    if holdables == nil or holdables[1] == -1 or #holdables == 0 then
        return false
    end
    if (Settings.DebugMode.Value) then
        Logging.LogDebug(' findAndCollectHoldablesIntoMagneticStorage: #holdables ', #holdables )
    end
    if maxQty <= 0 then
        if (Settings.DebugMode.Value) then
            Logging.LogDebug(' findAndCollectHoldablesIntoMagneticStorage: 0 max qty??? ')
        end
        return false
    end

    local storageId = LINK_UIDS[magnetId].storageUID
    local storageInfo = STORAGE_UIDS[storageId]
    local send = 0
    for _, uid in ipairs(holdables)
    do
        if (send >= maxQty) then
             return false
         end -- already requested max Qty

        if (not OBJECTS_IN_FLIGHT:Contains(uid)) then
            Logging.LogDebug(' Add object to fly ')
            --return false
         -- already flying
        -- if (OBJECTS_IN_FLIGHT[uid] ~= nil) then
        --     return false
        -- end -- already flying
            if uid ~= -1 then -- Is a valid UID
                local objectX, objectY = table.unpack(ModObject.GetObjectTileCoord(uid))
                local from = Point.new(objectX, objectY)
                local to = Point.new(storageInfo.tileX, storageInfo.tileY)
                local flightObject = FlightObject.new(
                    uid,
                    storageId,
                    magnetId,
                    from,
                    to,
                    OnFlightComplete
                )
                flightObject:Start(magnetSettings.Speed, 10)
                OBJECTS_IN_FLIGHT:Add(flightObject)
                send = send + 1
            end

        end
        -- if uid ~= -1 then -- Is a valid UID
        --     ModObject.StartMoveTo(uid, s.tileX, s.tileY, 15, 10)
        --     OBJECTS_IN_FLIGHT[uid] = {
        --         arch = true,
        --         wobble = false,
        --         storageUID = LINK_UIDS[magnetUID].storageUID, onFlightComplete = onFlightCompleteForMagnets
        --     }
        --     --ModObject.SetObjectActive(uid, false)
        --     if (Settings.DebugMode.Value) then Logging.LogDebug(' findAndCollectHoldablesIntoMagneticStorage: moving! uid:', uid ) end
        -- end
    end
end
