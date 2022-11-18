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
---@param author integer # Author Id. Ex. Transmitter.
---@param id integer # Provider Id. Ex. StorageId.
---@param type string|nil  # Items type
---@param bandwidth integer # Bandwidth
---@param hashTables? table # HashTables
---@return StorageProvider
function StorageProvider.new(author, id, type, bandwidth, hashTables)
    if (type == nil) then
        -- if (hashTables == nil) then
            -- type = type or AccessPoint.GetStorageInfo(id).TypeStores
        -- else
            -- local getValue = function () return AccessPoint.GetStorageInfo(id) end
            -- type = type or AccessPoint.GetOrAddValueByHashTable(hashTables, "StorageInfo", id, getValue).TypeStores
        -- end
        type = type or AccessPoint.GetStorageInfo(id).TypeStores
    end

    local instance = StorageProvider:make(author, id, type, bandwidth)
    instance._amount = 0
    return instance
end

function StorageProvider:GetAmount()
    return self._amount
end

function StorageProvider:Update()
    self._provider = nil

    ---@type UnpackStorageInfo|nil
    local storageInfo = self:GetStorageInfoSelf()
    if (storageInfo == nil or (not storageInfo.Successfully)) then
        self._amount = 0
        Logging.LogWarning("StorageProvider:Update StorageInfo not readed %d", self.Id)
        self._updated = true
        return
    end
    if(self.Type ~= storageInfo.TypeStores) then
        Logging.LogWarning("StorageProvider:Update change Type %s ==> %s", self.Type, storageInfo.TypeStores)
        self.Type = storageInfo.TypeStores
    end
    self._amount = storageInfo.AmountStored
    self._updated = true

    self._provider = {
        Author = self.Author,
        Id = self.Id,
        Type = self.Type,
        Bandwidth = ReferenceValue.new(self._bandwidth),
        FullAmount = ReferenceValue.new(self._amount),
        RequirementType = "Storage"
    }
end