--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class AccessPoint :Object # AccessPoint potrebitel`
---@field _bandwidth integer # Bandwidth
---@field _updated boolean # Bandwidth
---@field Id integer # Provider Id. Ex. StorageId.
---@field Type string # Items type
---@field HashTables table # Items type
AccessPoint = { }
---@type AccessPoint
AccessPoint = Object:extend(AccessPoint)

function AccessPoint:initialize(id, type, bandwidth, hashTables)
    self._bandwidth = bandwidth
    self._updated = false
    self.Id = id
    self.Type = type
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
---@param hashtableName "StorageInfo"|"Storage.FreeSpace"
---@param key any
---@param getValue fun() :any|nil
function AccessPoint:GetOrAddValueByHashTable(hashtableName, key, getValue)
    return AccessPoint.GetOrAddValueByHashTableStatic(self.HashTables, hashtableName, key, getValue)
end

--- func desc
---@param hashtableName "StorageInfo"|"Storage.FreeSpace"
---@param key any
---@param getValue fun() :any|nil
function AccessPoint.GetOrAddValueByHashTableStatic(hashTables,hashtableName, key, getValue)
    return Tools.Dictionary.GetOrAddValueByHashTables(hashTables, hashtableName, key, getValue)
end

--- func desc
---@param id integer
function AccessPoint.GetStorageInfo(id)
    return Extensions.UnpackStorageInfo(ModStorage.GetStorageInfo(id))
end

--- func desc
---@param id integer
function AccessPoint.GetStorageFreeSpace(id, storageInfo)
    return StorageTools.GetFreeSpace(id, storageInfo, OBJECTS_IN_FLIGHT)
end