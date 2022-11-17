--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class AccessPoint :Object # AccessPoint potrebitel`
---@field _bandwidth integer # Bandwidth
---@field _updated boolean # Bandwidth
---@field _getBuildingRequirements fun(id :integer) :UnpackBuildingRequirementsList
---@field _getStorageInfo fun(id :integer) :UnpackStorageInfo
---@field Id integer # Provider Id. Ex. StorageId.
---@field Type string # Items type
---@field Author integer # Author Id. Ex. Transmitter.
---@field HashTables table # Items type
AccessPoint = {
    _getBuildingRequirements = function (key) return Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(key)) end,
    _getStorageInfo  = function (key) return Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(key)) end
}
---@type AccessPoint
AccessPoint = Object:extend(AccessPoint)

---@enum
AccessPoint.HashTableGroups = {
    "StorageInfo",
    "Storage.FreeSpace",
    "ConverterProperties",
    "BuildingRequirements",
    "BuildingRequirements"
}

function AccessPoint:initialize(author, id, type, bandwidth, hashTables)
    self._bandwidth = bandwidth
    self._updated = false
    --self._getBuildingRequirements = function (key) return Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(key)) end
    self.Id = id
    self.Type = type
    self.Author = author
    self.HashTables = hashTables
end

function AccessPoint:BeginRead(hashTables)
    self.HashTables = hashTables
    self._updated = false
end

---@protected
function AccessPoint:Update()
    self._updated = true
end

--- func desc
---@param hashTable table
---@alias HashTableGroups "StorageInfo"|"Storage.FreeSpace"|"Storage.Amount"|"ConverterProperties"|"BuildingRequirements"
---@param hashTableGroup HashTableGroups
---@return table
function AccessPoint.GetHashGroup(hashTable, hashTableGroup)
    if (hashTable == nil) then
        Logging.LogFatal("AccessPoint.GetHashGroup hashTable == nil")
        error("AccessPoint.GetHashGroup hashTable == nil", 666)
    end
    return Tools.Dictionary.GetOrAddValue(hashTable, hashTableGroup, { })
end

---@param id integer|nil
---@return UnpackStorageInfo #
function AccessPoint:GetStorageInfoSelf(id)
    if (self.HashTables ~= nil) then
        local hashTable = AccessPoint.GetHashGroup(self.HashTables, "StorageInfo")
        return AccessPoint.GetStorageInfo(id or self.Id, hashTable)
    end
    return AccessPoint.GetStorageInfo(id or self.Id)
end

--- 
---@return UnpackBuildingRequirementsList #
function AccessPoint:GetBuildingRequirementsSelf()
    if (self.HashTables ~= nil) then
        local hashTable = AccessPoint.GetHashGroup(self.HashTables, "BuildingRequirements")
        return AccessPoint.GetBuildingRequirements(self.Id, hashTable)
    end
    return AccessPoint.GetBuildingRequirements(self.Id)
end

--- func desc
---@param storageInfo UnpackStorageInfo|nil
---@return integer
function AccessPoint:GetStorageAmountSelf(storageInfo)
    storageInfo = storageInfo or self:GetStorageInfoSelf()
    if (not storageInfo.Successfully) then
        Logging.LogWarning("AccessPoint:GetStorageFreeSpaceSelf ~storageInfo.Successfully")
        return 0
    end
    if (self.HashTables ~= nil) then
        local hashTable = AccessPoint.GetHashGroup(self.HashTables, "Storage.Amount")
        return AccessPoint.GetStorageAmount(self.Id, storageInfo, hashTable)
    end
    return AccessPoint.GetStorageAmount(self.Id, storageInfo)
end

--- func desc
---@param storageInfo UnpackStorageInfo|nil
---@return integer
function AccessPoint:GetStorageFreeSpaceSelf(storageInfo)
    storageInfo = storageInfo or self:GetStorageInfoSelf()
    if (not storageInfo.Successfully) then
        Logging.LogWarning("AccessPoint:GetStorageFreeSpaceSelf ~storageInfo.Successfully")
        return 0
    end
    if (self.HashTables ~= nil) then
        local hashTable = AccessPoint.GetHashGroup(self.HashTables, "Storage.FreeSpace")
        return AccessPoint.GetStorageFreeSpace(self.Id, storageInfo, hashTable)
    end
    return AccessPoint.GetStorageFreeSpace(self.Id, storageInfo)
end

--- func desc
---@param id integer
---@param hashTable table|nil
---@return UnpackStorageInfo #
function AccessPoint.GetStorageInfo(id, hashTable)
    if (hashTable == nil) then
        return AccessPoint._getStorageInfo(id)
    end
    return Tools.Dictionary.GetOrAddValueLazyVariable(hashTable, id, AccessPoint._getStorageInfo)
end

--- func desc
---@param id integer
---@param hashTable table|nil
---@return UnpackBuildingRequirementsList
function AccessPoint.GetBuildingRequirements(id, hashTable)
    if (hashTable == nil) then
        return Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(id))
    end
    return Tools.Dictionary.GetOrAddValueLazyVariable(hashTable, id, AccessPoint._getBuildingRequirements)
end

--- func desc
---@param id integer
---@param hashTable table|nil
---@return integer
function AccessPoint.GetStorageAmount(id, storageInfo, hashTable)
    if (hashTable == nil) then
        return StorageTools.GetAmount(id, storageInfo, OBJECTS_IN_FLIGHT)
    end
    local getValue = function () return StorageTools.GetAmount(id, storageInfo, OBJECTS_IN_FLIGHT) end
    return Tools.Dictionary.GetOrAddValueLazy(hashTable, id, getValue)
end

--- func desc
---@param id integer
---@param hashTable table|nil
---@return integer
function AccessPoint.GetStorageFreeSpace(id, storageInfo, hashTable)
    if (hashTable == nil) then
        return StorageTools.GetFreeSpace(id, storageInfo, OBJECTS_IN_FLIGHT)
    end
    local getValue = function () return StorageTools.GetFreeSpace(id, storageInfo, OBJECTS_IN_FLIGHT) end
    return Tools.Dictionary.GetOrAddValueLazy(hashTable, id, getValue)
end