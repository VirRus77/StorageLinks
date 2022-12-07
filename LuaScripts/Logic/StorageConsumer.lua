--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class StorageConsumer :Consumer # consumer потребитель
StorageConsumer = {
}
---@type StorageConsumer
StorageConsumer = Consumer:extend(StorageConsumer)

--- func desc
---@param author integer # Author. Ex. Trnsmitter.
---@param id integer # Provider Id. Ex. StorageId.
---@param bandwidth integer # Bandwidth
---@param hashTables? table # HashTables
---@return StorageConsumer
function StorageConsumer.new(author, id, bandwidth, hashTables)
    local type = AccessPoint.GetStorageInfo(id).TypeStores
    local instance = StorageConsumer:make(author, id, bandwidth, hashTables)
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
    if (self.Type ~= storageInfo.TypeStores) then
        Logging.LogWarning("StorageConsumer:Update change Type %s ==> %s", self.Type, storageInfo.TypeStores)
        self.Type = storageInfo.TypeStores
    end
    local freeSpace = self:GetStorageFreeSpaceSelf(storageInfo)
    ---@type RequireItem
    local require = { }
    require.Id = self.Id
    require.Amount = self:GetStorageAmountSelf(storageInfo)
    require.Requires = ReferenceValue.new(freeSpace)
    require.Type = storageInfo.TypeStores
    require.Bandwidth = ReferenceValue.new(self._bandwidth)
    require.RequirementType = "Storage"

    self._requires[1] = require
    self._updated = true
end
