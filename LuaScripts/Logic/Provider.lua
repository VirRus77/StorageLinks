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
---@alias ProviderRequirementType RequirementType | "Storage"
---@return ProviderItem #
function Provider:Amount()
    if (not self._updated) then
        self:Update()
    end
    --return math.min(self._bandwidth, self:GetAmount())
    return { Id = self.Id, Type = self.Type, Bandwidth = ReferenceValue.new(self._bandwidth), FullAmount = ReferenceValue.new(self:FullAmount()), RequirementType = "Storage" }
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

-- --- func desc
-- ---@param providers Provider[]
-- function Provider.Aggregate(providers)
--     local amount = 0
--     local id = providers[1].Id
--     for _, provider in pairs(providers) do
--         if(provider.Id ~= id)then
--             error("Consumer.Aggregate Id not equals.", 666)
--         end
--         amount = amount + provider:Amount()
--     end
--     return math.min(amount, providers[1]:FullAmount())
-- end

--- func desc
---@param providerItems ProviderItem[]
function Provider.Aggregate(providerItems)
    Logging.LogDebug("Provider.Aggregate providerItems: %d", #providerItems)
    if (#providerItems <= 1) then
        return providerItems
    end
    ---@type ProviderItem[]
    local list = { }

    --- func desc
    ---@type table<integer, ProviderItem[]>
    local groupId = Tools.GroupBy(providerItems, function (v) return v.Id end)
    Logging.LogDebug("Provider.Aggregate groupId: %d", select("#", groupId))
    for _, groupValues in pairs(groupId) do
        if (#groupValues == 1) then
            list[#list + 1] = groupValues[1]
        else
            ---@type table<ReferenceValue, ProviderItem[]>
            ---@param v ProviderItem
            local bandwidths = Tools.SelectDistinctValues(groupValues, function (v) return v.Bandwidth end)
            local bandwidthAll = ReferenceValue.new(0)
            for key, _ in pairs(bandwidths) do
                bandwidthAll.Value = bandwidthAll.Value + key.Value
            end
            for _, provider in pairs(groupValues) do
                provider.Bandwidth = bandwidthAll
            end
            local typeGroup = Tools.GroupBy(groupValues, function (v) return v.Type end)
            for _, value in pairs(typeGroup) do
                list[#list + 1] = value[1]
            end
        end
    end
    Logging.LogDebug("Provider.Aggregate (end) list: %d", #list)
    return list
end