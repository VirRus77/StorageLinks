--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class StorageProvider :Provider #  provider поставщик
---@field _amount integer #
StorageProvider = {
}
---@type StorageProvider
StorageProvider = Provider:extend(StorageProvider)


--- func desc
---@param id integer # Provider Id. Ex. StorageId.
---@param type string|nil  # Items type
---@param bandwidth integer # Bandwidth
---@param hashTables? table # HashTables
---@return StorageProvider
function StorageProvider.new(id, type, bandwidth, hashTables)
    if(type == nil)then
        if (hashTables == nil) then
            type = type or AccessPoint.GetStorageInfo(id).TypeStores
        else
            local getValue = function () return AccessPoint.GetStorageInfo(id) end
            type = type or AccessPoint.GetOrAddValueByHashTableStatic(hashTables, "StorageInfo", id, getValue).TypeStores
        end
    end

    local instance = StorageProvider:make(id, type, bandwidth)
    instance._amount = 0
    return instance
end

function StorageProvider:GetAmount()
    return self._amount
end

function StorageProvider:Update()
    ---@type fun() :UnpackStorageInfo
    local getValue = function () return AccessPoint.GetStorageInfo(self.Id) end
    ---@type UnpackStorageInfo|nil
    local storageInfo = self:GetOrAddValueByHashTable("StorageInfo", self.Id, getValue)
    if (storageInfo == nil or (not storageInfo.Successfully)) then
        self._amount = 0
        Logging.LogWarning("StorageConsumer:Update StorageInfo not readed %d", self.Id)
        self._updated = true
        return
    end
    if(self.Type ~= storageInfo.TypeStores) then
        Logging.LogWarning("StorageConsumer:Update change Type %s ==> %s", self.Type, storageInfo.TypeStores)
        self.Type = storageInfo.TypeStores
    end
    self._amount = storageInfo.AmountStored
    self._updated = true
end