--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Provider :AccessPoint #  provider
---@field _bandwidth integer # Bandwidth
---@field Id integer # Provider Id. Ex. StorageId.
---@field Type string # Items type
Provider = { }
---@type Provider
Provider = AccessPoint:extend(Provider)

--- func desc
---@param id integer # Provider Id. Ex. StorageId.
---@param type string  # Items type
---@param bandwidth integer # Bandwidth
---@param hashTables? table # HashTables
function Provider.new(id, type, bandwidth, hashTables)
    local instance = Consumer:make(id, type, bandwidth, hashTables)
    return instance
end

function Provider:initialize(id, type, bandwidth, hashTables)
    self._bandwidth = bandwidth
    self._updated = false
    self.Id = id
    self.Type = type
    self.HashTables = hashTables
end

--- Can provide
---@public
---@return integer #
function Provider:Amount()
    if (not self._updated) then
        self:Update()
    end
    return math.min(self._bandwidth, self:GetAmount())
end

--- Can provide
---@public
---@return integer #
function Provider:FullAmount()
    if (not self._updated) then
        self:Update()
    end
    return self:GetAmount()
end

--- func desc
---@protected
---@return integer #
function Provider:GetAmount()
    return 0
end

--- func desc
---@param a Provider
---@param b Provider
function Provider.ComparerToBig(a, b)
    return Tools.Compare(a:Amount(), b:Amount())
end

--- func desc
---@param a Provider
---@param b Provider
function Provider.ComparerToSmall(a, b)
    return Tools.Compare(a:Amount(), b:Amount(), true)
end

--- func desc
---@param providers Provider[]
function Provider.Aggregate(providers)
    local amount = 0
    local id = providers[1].Id
    for _, provider in pairs(providers) do
        if(provider.Id ~= id)then
            error("Consumer.Aggregate Id not equals.", 666)
        end
        amount = amount + provider:Amount()
    end
    return math.min(amount, providers[1]:FullAmount())
end