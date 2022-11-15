--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class StorageConsumer :Consumer # consumer потребитель
---@field _freeSpace integer #
StorageConsumer = {
}
---@type StorageConsumer
StorageConsumer = Consumer:extend(StorageConsumer)

--- func desc
---@param id integer # Provider Id. Ex. StorageId.
---@param type string|nil  # Items type
---@param bandwidth integer # Bandwidth
---@param hashTables? table # HashTables
---@return StorageConsumer
function StorageConsumer.new(id, type, bandwidth, hashTables)
    if (type == nil) then
        if (hashTables == nil) then
            type = type or AccessPoint.GetStorageInfo(id).TypeStores
        else
            local getValue = function () return AccessPoint.GetStorageInfo(id) end
            type = type or AccessPoint.GetOrAddValueByHashTableStatic(hashTables, "StorageInfo", id, getValue).TypeStores
        end
    end

    if (hashTables == nil) then
        type = type or UnpackStorageInfo(ModStorage.GetStorageInfo(id)).TypeStores
    end
    local instance = StorageConsumer:make(id, type, bandwidth, hashTables)
    instance._freeSpace = 0
    return instance
end

function StorageConsumer:GetRequire()
    return self._freeSpace
end

function StorageConsumer:Update()
    ---@type fun() :UnpackStorageInfo
    local getValue = function () return AccessPoint.GetStorageInfo(self.Id) end
    local storageInfo = self:GetOrAddValueByHashTable("StorageInfo", self.Id, getValue)
    if (storageInfo == nil or (not storageInfo.Successfully)) then
        self._freeSpace = 0
        Logging.LogWarning("StorageConsumer:Update StorageInfo not readed %d", self.Id)
        self._updated = true
        return
    end
    if(self.Type ~= storageInfo.TypeStores) then
        Logging.LogWarning("StorageConsumer:Update change Type %s ==> %s", self.Type, storageInfo.TypeStores)
        self.Type = storageInfo.TypeStores
    end
    local getFreeSpace = function () return AccessPoint.GetStorageFreeSpace(self.Id, storageInfo) end
    local freeSpace = self:GetOrAddValueByHashTable("Storage.FreeSpace", self.Id, getFreeSpace)
    self._freeSpace = freeSpace or 0
    self._updated = true
end
