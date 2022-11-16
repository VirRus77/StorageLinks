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
function StorageConsumer.new(id, bandwidth, hashTables)
    local type = AccessPoint.GetStorageInfo(id).TypeStores
    local instance = StorageConsumer:make(id, bandwidth, hashTables)
    instance.type = type
    return instance
end

function StorageConsumer:GetRequire()
    return self._freeSpace
end

function StorageConsumer:Update()
    ---@type RequireItem[]
    self._requires = { }
    ---@type UnpackStorageInfo
    local storageInfo = self:GetStorageInfoSelf()
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
    local freeSpace = self:GetStorageFreeSpaceSelf(storageInfo)
    freeSpace = freeSpace or 0
    self._freeSpace = freeSpace
    local require = { }
    require.Id = self.Id
    require.Requires = freeSpace
    require.Type = storageInfo.TypeStores
    require.Bandwidth = ReferenceValue.new(self._bandwidth)
    require.RequirementType = "Storage"

    self._requires[1] = require
    self._updated = true
end
