-- Magnets
function discoverUnknownMagnets()
    locateMagnets(BuildingLevels.Crude)
    locateMagnets(BuildingLevels.Good)
    locateMagnets(BuildingLevels.Super)
end

--- func desc
---@param buildingLevel BuildingLevels
function locateMagnets(buildingLevel)
    if (DEBUG_ENABLED) then
        Logging.Log("locateMagnets ", serializeTable({
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
    local magnetUIDs = GetUidsByTypes(buildingTypes)

    -- -- Legacy
    -- if buildingLevel == 'Super' then
    --     local oldMagnetUIDs = ModBuilding.GetBuildingUIDsOfType('Storage Magnet (SL)', 0, 0, WORLD_LIMITS[1]-1, WORLD_LIMITS[2]-1)
    --     if oldMagnetUIDs ~= nil and oldMagnetUIDs[1] ~= -1 and oldMagnetUIDs[1] ~= nil then
    --         for _, uid in ipairs(oldMagnetUIDs) do
    --             magnetUIDs[#magnetUIDs + 1] = uid
    --         end
    --     end
    -- end
    -- -- END Legacy

    -- quit if none
    if magnetUIDs == nil or magnetUIDs[1] == nil then
        return
    end

    -- List the magnets if in debug mode
    if DEBUG_ENABLED then
        Logging.Log("locateMagnets:", serializeTable({
            magnetUIDs = magnetUIDs
        }))
    end

    -- if reset == nil then
    --     reset = false
    -- end

    -- handle each magnet
    for _, uid in ipairs(magnetUIDs)
    do
        if LINK_UIDS[uid] == nil then
            locateStorageForMagnet(uid)
        end
    end

end

--- func desc
---@param buildingUID number
---@param buildingType string
---@param isBlueprint boolean
---@param isDragging boolean
function OnMagnetSpawn(buildingUID, buildingType, isBlueprint, isDragging)
    if (DEBUG_ENABLED) then
        Logging.Log ("onMagnetSpawn ", serializeTable({
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
---@param magUID number
function locateStorageForMagnet(magUID)
    local storageUID, dir
    local magStorage = {}

    if DEBUG_ENABLED then
        Logging.Log("locateStorageForMagnet", " ", serializeTable({MagUID = magUID}) )
    end

    local properties = UnpackObjectProperties( ModObject.GetObjectProperties(magUID) )
    if (not properties.Successfully) then
        Logging.LogWarning(string.format("locateStorageForMagnet(magUID = %d). Properties not readed.", magUID))
        return
    end

    if (DEBUG_ENABLED) then
        Logging.LogDebug(string.format("locateStorageForMagnet(magUID = %d). Properties readed.", magUID))
        Logging.LogTrace(string.format("locateStorageForMagnet(magUID = %d).\n", magUID), serializeTable(properties, "properties"))    
    end

    -- Cache the Link
    local buildingLevel = Buildings.GetMagnetLevel (properties.Type)
     
    -- the only place for detecting rotation of magnet.
    local direction = "n"
    if properties.Rotation == 270 then direction = 'n' end
    if properties.Rotation == 0   then direction = 'e' end
    if properties.Rotation == 90  then direction = 's' end
    if properties.Rotation == 180 then direction = 'w' end

    local x, y = tileXYFromDir({ properties.TileX, properties.TileY }, direction)
    LINK_UIDS[magUID] = {
        bType         = properties.Type,
        tileX         = properties.TileX,
        tileY         = properties.TileY,
        rotation      = properties.Rotation,
        name          = properties.Name,
        buildingLevel = buildingLevel,
        connectToXY   = { x, y }
    }

    if (DEBUG_ENABLED) then
        Logging.LogTrace(string.format("locateStorageForMagnet(magUID = %d).\n", magUID), serializeTable ( LINK_UIDS[magUID],  "LINK_UIDS[magUID]"))
    end

    if ModBase.IsGameVersionGreaterThanEqualTo(VERSION_WITH_CLASSMETHODCHECK_FUNCTION) then
        -- Make sure we have a callback for when magnet is renamed
        if ModBase.ClassAndMethodExist('ModBuilding', 'RegisterForBuildingRenamedCallback') then
            ModBuilding.RegisterForBuildingRenamedCallback(magUID, magnetNameUpdated)
            ModDebug.Log("call ModBuilding.RegisterForBuildingRenamedCallback(", magUID, ")")
        end
        -- Make sure we have a callback for when a magnet is moved / rotated
        if ModBase.ClassAndMethodExist('ModBuilding', 'RegisterForBuildingRepositionedCallback') then
            ModBuilding.RegisterForBuildingRepositionedCallback(magUID, magnetRepositioned)
            ModDebug.Log("call ModBuilding.RegisterForBuildingRepositionedCallback(", magUID, ")")
        end
        -- And if the magnet is destroyed?
        if ModBase.ClassAndMethodExist('ModBuilding', 'RegisterForBuildingDestroyedCallback') then
            ModBuilding.RegisterForBuildingDestroyedCallback(magUID, linkDestroyed)
            ModDebug.Log("call ModBuilding.RegisterForBuildingDestroyedCallback(", magUID, ")")
        end
    end

    addStorageForMagnet(magUID)
end

--- func desc
---@param magUID integer
function addStorageForMagnet (magUID)
    if DEBUG_ENABLED then
        Logging.LogDebug(string.format('addStorageForMagnet (magUID = %d)', magUID))
    end
    local storageUID = storageUidOnTileWithCallbacks(LINK_UIDS[magUID].connectToXY[1], LINK_UIDS[magUID].connectToXY[2])

    if storageUID == nil then
        return false
    end -- no storage there.

    addStorageToMagnet(magUID, storageUID)
end

function addStorageToMagnet(magUID, storageUID)
    if DEBUG_ENABLED then
        Logging.Log('addStorageToMagnet: ', serializeTable({magUID = magUID, storageUID = storageUID}))
    end

    local sProps = ModStorage.GetStorageInfo(storageUID)

    -- if sProps[2] == nil then return false end -- Was not actually a storage.

    -- Cache the storageUID
    local properties = UnpackObjectProperties (ModObject.GetObjectProperties(storageUID))
    if (not properties.Successfully) then
        Logging.LogWarning(string.format("addStorageToMagnet(magUID = %d, storageUID = %d). Properties not readed.", magUID, storageUID))
        return
    end

    -- Create if needed
    if (STORAGE_UIDS[storageUID] == nil) then
        STORAGE_UIDS[storageUID] = { linkUIDs = {} }
    end

    -- Set properties
    STORAGE_UIDS[storageUID].bType 		= properties.Type
    STORAGE_UIDS[storageUID].tileX 		= properties.TileX
    STORAGE_UIDS[storageUID].tileY 		= properties.TileY
    STORAGE_UIDS[storageUID].rotation 	= properties.Rotation
    STORAGE_UIDS[storageUID].name 		= properties.Name
    STORAGE_UIDS[storageUID].sType 		= sProps[1] -- type stored or NIL if no type yet...
    STORAGE_UIDS[storageUID].linkUIDs	= addToTableIfDoesNotExist(STORAGE_UIDS[storageUID].linkUIDs, magUID) -- each storage might have multiple links of any kind

    -- Put storage UID in magnets cache.
    LINK_UIDS[magUID].storageUID = storageUID
    magnetNameUpdated(magUID, LINK_UIDS[magUID].name) -- this sets up the area

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
        Logging.LogDebug(' locateStorageForMagnet: sProps[1] ', sProps[1], ' of ', storageUID)
    end
end

--- func desc
---@param magUID integer
---@param objName string
function magnetNameUpdated(magUID, objName)
    if (Settings.DebugMode.Value) then
        Logging.LogDebug('magnetNameUpdated: ', serializeTable({magUID = magUID, objName = objName}))
    end
    -- Does the magnet exist in the tracker?
    if LINK_UIDS[magUID] == nil then return false end

    -- Update in tracker
    LINK_UIDS[magUID].name = objName -- '40x40'

    -- Does storageUID exist for magnet?
    if LINK_UIDS[magUID].storageUID == nil then return false end

    -- Update area for storage UID!
    -- {left = left, top = top, right = right, bottom = bottom}
    LINK_UIDS[magUID].area = getAreaForMagnetStorage(LINK_UIDS[magUID], STORAGE_UIDS[LINK_UIDS[magUID].storageUID])
    
    if DEBUG_ENABLED then
        Logging.Log('magnetNameUpdated end: ', serializeTable( LINK_UIDS[magUID] ))
    end
end

function magnetRepositioned(MagnetUID, BuildingType, Rotation, TileX, TileY, IsBlueprint, IsDragging)
    if DEBUG_ENABLED then
        Logging.Log('magnetRepositioned: ', serializeTable({MagnetUID = MagnetUID, BuildingType= BuildingType, Rotation = Rotation, TileX = TileX, TileY = TileY, IsBlueprint = IsBlueprint, IsDragging = IsDragging}))
    end

    if IsDragging then
        return false
    end
    if IsBlueprint then
        return false
    end
    if DEBUG_ENABLED then
        Logging.Log(' magnetRepositioned: MagnetUID ', MagnetUID)
    end
    resetCachedLink(MagnetUID)
end

function fireAllMagnets(buildingLevel)
    if DEBUG_ENABLED then
        Logging.Log('fireAllMagnets: buildingLevel: ', buildingLevel)
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

    -- loop over cached magnets
    for uid, props in pairs(LINK_UIDS) do
        for index, value in ipairs(buildingTypes) do
            if (props.bType == value) then
                if props.storageUID ~= nil then
                    -- Is there now a storage there?
                end
                fireMagnetByUID(uid, buildingLevel)
            end
        end
    end
end

function fireMagnetByUID(magnetUID, buildingLevel)
    if DEBUG_ENABLED then
        ModDebug.Log(' fireMagnetByUID: (a) ', magnetUID)
    end
    -- looking in area for items that can be picked up.
    if USE_EVENT_STYLE == false then
        updateLinkPropsAsNeeded(magnetUID)
        -- Does it still exist?
        if LINK_UIDS[magnetUID] == nil then return end
        if DEBUG_ENABLED then ModDebug.Log(' fireMagnetByUID: (b) ', magnetUID) end
        -- no more storage attached?
        if LINK_UIDS[magnetUID].storageUID == nil then
            addStorageForMagnet(magnetUID)
        end -- Heavy calcs here...
        -- Still no storage? then we quit.
        if LINK_UIDS[magnetUID].storageUID == nil then return end
        if DEBUG_ENABLED then ModDebug.Log(' fireMagnetByUID: (c) ', magnetUID) end
        -- What if the storage itself moved?
        updateStoragePropsAsNeeded(LINK_UIDS[magnetUID].storageUID)
        if DEBUG_ENABLED then ModDebug.Log(' fireMagnetByUID: (d) ', magnetUID) end
    end
    -- If there are no storages here, exit!
    if LINK_UIDS[magnetUID].storageUID == nil then return end
    -- How many can we put in crate?
    local maxQty = getQtyToGrabForMagnet(magnetUID)
    -- Get them
    findAndCollectHoldablesIntoMagneticStorage(magnetUID, maxQty)
    if DEBUG_ENABLED then ModDebug.Log(' fireMagnetByUID: (g) ', magnetUID) end
end

function getQtyToGrabForMagnet(magnetUID)
    -- LINK_UIDS[magnetUID] = {bType=bType, tileX=tileX, tileY=tileY, rotation=rotation, name=name, levelPrefix=levelPrefix, area={top,left,bottom,right}, storageUID}

    -- Figure out how many are already moving through the air, and if that is greater than allowed by the level, then return 0;
    local alreadyFlyingForStorage = listInFlightWithProp('storageUID', LINK_UIDS[magnetUID].storageUID, true)
    local alreadyFlyingQty
    if alreadyFlyingForStorage == nil or alreadyFlyingForStorage[1] == nil then
        alreadyFlyingQty = 0
    else
        alreadyFlyingQty = #alreadyFlyingForStorage
    end

    -- query storage for min/max
    local sProps = ModStorage.GetStorageInfo(LINK_UIDS[magnetUID].storageUID)	-- [1]=type-stored, [2] = on-hand, [3] = max-qty, [4] = storage container type

    if sProps == nil or sProps == -1 then
        return 0
    end
    if sProps[2] == nil then
        return 0
    end
    if sProps[3] == nil then
        return 0
    end

    -- if crate is full, return 0
    if sProps[2] >= sProps[3] then
        return 0
    end

    -- Adjust max to be "how many could actually fit into crate"
    local maxQtyToCollect = sProps[3] - sProps[2] - alreadyFlyingQty

    -- if qty flying will fill up crate, return 0
    if maxQtyToCollect <= 0 then
        return 0
    end

    -- Adjust based on level prefix
    if LINK_UIDS[magnetUID].buildingLevel == BuildingLevels.Crude then
        maxQtyToCollect = 1
    elseif LINK_UIDS[magnetUID].buildingLevel == BuildingLevels.Good then
        maxQtyToCollect = 5
    end

    return maxQtyToCollect
end

--- func desc
---@param magnetName string
---@param posX integer
---@param posY integer
---@return { left :integer, top :integer, right :integer, bottom :integer } #
function getMagnetArea(magnetName, posX, posY)
    if DEBUG_ENABLED then
        ModDebug.Log(os.date(),": ", "getMagnetArea: ", serializeTable({magnetName = magnetName, posX = posX, posY = posY }))
    end

    -- Calculate AREA or SIZE from the name. default to 10x10
    local w1, w2 = string.find(magnetName,'%d+x')
    local h1, h2 = string.find(magnetName,'x%d+')
    ---@type number?
    local width  = 10 -- default height
    ---@type number?
    local height = 10 -- default width

    if (DEBUG_ENABLED) then
        ModDebug.Log(' getMagnetArea: w1 w2: ', w1, ' ', w2 )
        ModDebug.Log(' getMagnetArea: h1 h2: ', h1, ' ', h2 )
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
    if DEBUG_ENABLED then
        ModDebug.Log(' getMagnetArea: ', serializeTable( result ) )
    end

    return result
end

function getAreaForMagnetStorage(magProps, storProps)
    if DEBUG_ENABLED then
        ModDebug.Log(' getAreaForMagnetStorage: ', serializeTable({magProps = magProps, storProps = storProps}) )
    end

    local result = getMagnetArea( magProps.name, storProps.tileX, storProps.tileY )
    if DEBUG_ENABLED then
        ModDebug.Log(' getAreaForMagnetStorage: area: ', serializeTable( result ) )
    end

    return result
end

function findAndCollectHoldablesIntoMagneticStorage(magnetUID, maxQty)
    if DEBUG_ENABLED then ModDebug.Log(' findAndCollectHoldablesIntoMagneticStorage: (a)', table.show(LINK_UIDS[magnetUID].area) ) end
    if LINK_UIDS[magnetUID] == nil then return end
    if STORAGE_UIDS[LINK_UIDS[magnetUID].storageUID] == nil then return end

    -- Get all items of sType in area
    --local holdables = ModTiles.GetObjectsOfTypeInAreaUIDs(
    local holdables = ModTiles.GetObjectUIDsOfType(
        STORAGE_UIDS[LINK_UIDS[magnetUID].storageUID].sType,
        LINK_UIDS[magnetUID].area.left,
        LINK_UIDS[magnetUID].area.top,
        LINK_UIDS[magnetUID].area.right,
        LINK_UIDS[magnetUID].area.bottom
    )
    if DEBUG_ENABLED then ModDebug.Log(' findAndCollectHoldablesIntoMagneticStorage: holdables ', holdables ) end
    if DEBUG_ENABLED then ModDebug.Log(' findAndCollectHoldablesIntoMagneticStorage: holdables ', table.show(holdables) ) end
    if holdables == nil or holdables[1] == -1 or #holdables == 0 then
        return false
    end
    if DEBUG_ENABLED then
        ModDebug.Log(' findAndCollectHoldablesIntoMagneticStorage: #holdables ', #holdables )
    end
    if maxQty == 0 then
        if DEBUG_ENABLED then ModDebug.Log(' findAndCollectHoldablesIntoMagneticStorage: 0 max qty??? ') end
        return false
    end

    local s = STORAGE_UIDS[LINK_UIDS[magnetUID].storageUID]
    for _, uid in ipairs(holdables)
    do
        if _ > maxQty then return false end -- already requested max Qty
        if OBJECTS_IN_FLIGHT[uid] ~= nil then return false end -- already flying
        if uid ~= -1 then -- Is a valid UID
            ModObject.StartMoveTo(uid, s.tileX, s.tileY, 15, 10)
            OBJECTS_IN_FLIGHT[uid] = { arch=true, wobble=false, storageUID = LINK_UIDS[magnetUID].storageUID, onFlightComplete = onFlightCompleteForMagnets }
            --ModObject.SetObjectActive(uid, false)
            if DEBUG_ENABLED then ModDebug.Log(' findAndCollectHoldablesIntoMagneticStorage: moving! uid:', uid ) end
        end
    end

end

function calcQtyToGrabForMagneticStorage(magStorage, buildingLevel)
    -- {storageUID = storageUID, magUID = magUID, linkProps = linkProps, storageProps = storageProps}
    -- storageProps [1]=type-stored, [2] = on-hand, [3] = max-qty, [4] = storage container type
    local alreadyFlyingForStorage = listInFlightWithProp('storageUID', magStorage.storageUID, true)
    local alreadyFlyingQty
    if alreadyFlyingForStorage == nil or alreadyFlyingForStorage[1] == nil then
        alreadyFlyingQty = 0
    else
        alreadyFlyingQty = #alreadyFlyingForStorage
    end
    local maxQtyToCollect = magStorage.storageProps[3] - magStorage.storageProps[2] - alreadyFlyingQty

    -- If this is "Crude" or "Good" level
    if (buildingLevel == BuildingLevels.Crude) then
        maxQtyToCollect = 1
    elseif (buildingLevel == BuildingLevels.Good) then
        maxQtyToCollect = 5
    end

    if maxQtyToCollect == 0 then return
        false
    end

    calcAreaForMagneticStorage(magStorage, maxQtyToCollect, alreadyFlyingForStorage)
end

function calcAreaForMagneticStorage(magStorage, maxQtyToCollect, alreadyFlyingForStorage)
    local stXY = ModObject.GetObjectTileCoord(magStorage.storageUID)

    if DEBUG_ENABLED then
        ModDebug.Log(' calcQtyToGrabForMagneticStorage: magnet Name: "', magStorage.magProps[5], '"' )
    end

    local result = getMagnetArea(magStorage.magProps[5], stXY[1], stXY[2])
    if DEBUG_ENABLED then
        ModDebug.Log(' calcAreaForMagneticStorage: area: ', serializeTable( result ) )
    end

    collectGoodsIntoMagneticStorage(magStorage, maxQtyToCollect, stXY, result, alreadyFlyingForStorage)
end

function collectGoodsIntoMagneticStorage(magStorage, maxQtyToCollect, stXY, area, alreadyFlyingForStorage)
    if DEBUG_ENABLED then
        ModDebug.Log(' collectGoodsIntoMagneticStorage: (a)' )
    end

    -- Clip to max area on map
    local pickables = ModTiles.GetObjectUIDsOfType(magStorage.storageProps[1], area.left, area.top, area.right, area.bottom)
    if pickables == nil or pickables[1] == -1 or #pickables == 0 then return false end
    if DEBUG_ENABLED then ModDebug.Log(' collectGoodsIntoMagneticStorage: #pickables ', #pickables ) end

    for _, uid in ipairs(pickables)
    do
        if _ > maxQtyToCollect then return false end -- done requestiong.
        if hasValue(alreadyFlyingForStorage, uid) == false and uid ~= -1 then -- Not already in flight for area
            ModObject.StartMoveTo(uid, stXY[1], stXY[2], 15, 10)
            OBJECTS_IN_FLIGHT[uid] = { arch=true, wobble=false, storageUID = magStorage.storageUID, onFlightComplete = onFlightCompleteForMagnets }
            if DEBUG_ENABLED then ModDebug.Log(' collectGoodsIntoMagneticStorage: moving! uid:', uid ) end
        end
    end
end

function onFlightCompleteForMagnets(flyingUID, ob)
    -- ob has arrived!
    if ModObject.IsValidObjectUID(flyingUID) and ModObject.IsValidObjectUID(ob.storageUID) then -- both UID and storageUID are valid
        -- Use 'AddToStorage' only if it has durability.
        local maxUsage = ModVariable.GetVariableForObjectAsInt(ModObject.GetObjectType(flyingUID), 'MaxUsage')
        if maxUsage == nil or maxUsage == 0 then -- No durability, just up storage qty
            local sProps = ModStorage.GetStorageInfo(ob.storageUID) -- [2] = current amount, [3] = max
            if sProps ~= nil and sProps[1] ~= -1 and sProps[2] ~= nil then
                if sProps[2] < 0 then
                    sProps[2] = 0
                    ModStorage.SetStorageQuantityStored(ob.storageUID, 0)
                end
                ModStorage.SetStorageQuantityStored(ob.storageUID, sProps[2] + 1)
            end
        else-- Durability present, use their method.
            ModStorage.AddToStorage(ob.storageUID, flyingUID)
        end
    end
    -- still valid?
    if ModObject.IsValidObjectUID(flyingUID) then
        ModObject.DestroyObject(flyingUID)
    end -- make sure!
end