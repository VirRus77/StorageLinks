--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class VirtualNetwor :Object # 
---@field _index integer #
---@field Providers table<string, Provider> #
---@field Consumers table<string, Consumer> #
---@field HashTables table #
VirtualNetwor = { }

---@type VirtualNetwor
VirtualNetwor = Object:extend(VirtualNetwor)

--- func desc
---@return VirtualNetwor
function VirtualNetwor.new()
    local instance = VirtualNetwor:make()
    return instance
end

function VirtualNetwor:initialize()
    self._index = 1
    self.Providers = { }
    self.Consumers = { }
    self.HashTables = { }
end

--- func desc
---@param provider Provider #
---@return string # ProviderId
function VirtualNetwor:AddProvider(provider)
    local key = tostring(self._index)
    self._index = self._index + 1
    self.Providers[key] = provider
    return key
end

--- func desc
---@param consumer Consumer #
---@return string # ProviderId
function VirtualNetwor:AddConsumer(consumer)
    local key = tostring(self._index)
    self._index = self._index + 1
    self.Consumers[key] = consumer
    return key
end

--- func desc
---@param providerId string #
function VirtualNetwor:RemoveProvider(providerId)
    if (self.Providers[providerId] == nil) then
       Logging.LogError("VirtualNetwor:RemoveProvider Not found provider %s\n", providerId, self.Providers)
       return
    end
    self.Providers[providerId] = nil
end

--- func desc
---@param consumerId string #
function VirtualNetwor:RemoveConsumer(consumerId)
    if (self.Consumers[consumerId] == nil) then
       Logging.LogError("VirtualNetwor:RemoveProvider Not found consumer %s\n", consumerId, self.Consumers)
       return
    end
    self.Consumers[consumerId] = nil
end

function VirtualNetwor:TimeCallback()
    self:ChainProcess()

    -- local consumersCount = 0
    -- ---@type table<integer, RequireItem[]>
    -- local consumersById = { }
    -- for _, consumer in pairs(self.Consumers) do
    --     consumer:BeginRead(self.HashTables)
    --     local requires = consumer:Requires()
    --     local aggregateConsumersById = Tools.Dictionary.GetOrAddValue(consumersById, consumer.Id, { })
    --     Tools.TableConcat(aggregateConsumersById, requires)
    --     consumersCount = consumersCount + #requires
    -- end
    -- Logging.LogDebug("VirtualNetwor:TimeCallback consumersCount: %d", consumersCount)
    -- if(consumersCount == 0)then
    --     return
    -- end

    -- for id, value in pairs(consumersById) do
    --    local consumerAggreagated = Consumer.Aggregate(value)
    --    for key, value in pairs(consumerAggreagated) do
    --        local consumersGroupItemType = Tools.Dictionary.GetOrAddValue(aggregateHash, value.Type, { })
    --        local consumersGroup = Tools.Dictionary.GetOrAddValue(consumersGroupItemType, "Consumers", { })
    --        local consumersGroupById = Tools.Dictionary.GetOrAddValue(consumersGroup, value.Id, { })
    --        consumersGroupById[#consumersGroupById + 1] = value
    --    end
    -- end

    -- local providersCount = 0
    -- for _, provider in pairs(self.Providers) do
    --     provider:BeginRead(self.HashTables)
    --     local aggregateConsumerType = aggregateHash[provider.Type]
    --     if(aggregateConsumerType == nil)then
    --         return
    --     end
    --     if(provider:Amount() > 0) then
    --         providersCount = providersCount + 1
    --         local aggregateProviders = Tools.Dictionary.GetOrAddValue(aggregateConsumerType, "Providers", { })
    --         local aggregateProvidersId = Tools.Dictionary.GetOrAddValue(aggregateProviders, provider.Id, { })
    --         aggregateProvidersId[#aggregateProvidersId + 1] = provider
    --     end
    -- end

    -- Logging.LogDebug("VirtualNetwor:TimeCallback providersCount: %d", providersCount)
    -- if (providersCount == 0) then
    --     return
    -- end

    -- local chains = self.MakeChain(aggregateHash)
    -- Logging.LogDebug("VirtualNetwor:TimeCallback chainsCount: %d", #chains)
    -- self.ExecuteChains(chains)
end

function VirtualNetwor:ClearHashTables()
    self.HashTables = { }
end

-- -----@param aggregateHash AggregateConsumerProvider
-- ---@return { ItemType :string, Chains :ChainItem }[]
-- function VirtualNetwor.MakeChain(aggregateHash)
    -- -- Logging.LogDebug("VirtualNetwor.MakeChain\naggregateHash = %s", aggregateHash)
    -- ---@type { ItemType :string, Chains :ChainItem[] }[]
    -- local chainList = { }
    -- for itemType, aggregateValue in pairs(aggregateHash) do
        -- if (aggregateValue.Providers ~= nil) then
            -- local chains =  VirtualNetwor.SumChain(aggregateValue.Consumers, aggregateValue.Providers)
            -- chainList[#chainList + 1] = { ItemType = itemType, Chains = chains }
        -- end
    -- end
    -- return chainList
-- end

-- --- func desc
-- ---@param consumers { Id :integer, Require: integer }[]
-- ---@param providers { Id :integer, Amount: integer }[]
-- ---@return { SourceId :integer, DestinationId :integer, Count :integer}[]
-- function VirtualNetwor.ZipChain(consumers, providers)
--     ---@type ChainItem[]
--     local chains = { }
--     for _, consumerValue in pairs(consumers) do
--         local consumerId = consumerValue.Id
--         local required = consumerValue.Require
--         ---@type ChainItem
--         local chain = { DestinationId = consumerId }
--         for providerIndex, providerValue in pairs(providers) do
--             if(consumerId ~= providerValue.Id and providerValue.Amount > 0) then
--                 chain.SourceId = providerValue.Id
--                 chain.Count = math.min(required, providerValue.Amount)
--                 required = required - chain.Count
--                 providers[providerIndex].Amount = providerValue.Amount - chain.Count
--                 chains[#chains + 1] = chain
--                 if (required == 0) then
--                     break
--                 end
--             end
--         end
--     end
--     return chains
-- end

function VirtualNetwor:ChainProcess()
    self:ClearHashTables()
    ---@type RequireItem[]
    local requires = { }

    for _, consumer in pairs(self.Consumers) do
        consumer:BeginRead(self.HashTables)
        Tools.TableConcat(requires, consumer:Requires())
    end
    Logging.LogDebug("VirtualNetwor:ChainProcess countRequires: %d\n%s", #requires, requires)
    Logging.LogDebug("VirtualNetwor:ChainProcess self.HashTables: \n%s", self.HashTables)
    if (#requires == 0) then
        return
    end

    -- local groupIdRequires = Tools.GroupBy(requires, function (a) return a.Id end)
    -- Logging.LogDebug("VirtualNetwor:ChainProcess groupId=\n%s", groupIdRequires)
    requires = Consumer.Aggregate(requires)
    -- for _, value in pairs(groupIdRequires) do
    --     Tools.TableConcat(requires, )
    -- end

    ---@type ProviderItem[]
    local providers = { }
    -- Providers
    for _, provider in pairs(self.Providers) do
        provider:BeginRead(self.HashTables)
        local providerItem = provider:Amount()
        if (providerItem.FullAmount.Value > 0) then
            providers[#providers + 1] = providerItem
        end
    end
    providers = Provider.Aggregate(providers)
    Logging.LogDebug("VirtualNetwor:ChainProcess providers: %d\n%s", #providers, providers)
    if (#providers == 0) then
        return
    end
    Logging.LogDebug("VirtualNetwor:ChainProcess (end) requires: %d\n%s", #requires, requires)
    Logging.LogDebug("VirtualNetwor:ChainProcess (end) self.HashTables: \n%s", self.HashTables)
    local chains = VirtualNetwor.MakeChain(requires, providers)
    Logging.LogDebug("VirtualNetwor:ChainProcess (end) self.HashTables: \n%s", self.HashTables)
    VirtualNetwor.ExecuteChains(chains, self.HashTables)
end

--- func desc
---@param requires RequireItem[]
---@param provider ProviderItem[]
---@return ChainItem[]
function VirtualNetwor.MakeChain(requires, provider)
    Logging.LogDebug("VirtualNetwor.MakeChain requires: %d provider: %d", #requires, #provider)
    ---@type ChainItem
    local chains = { }
    ---@type table<string, RequireItem[]>
    local requiresByRequiredType = Tools.GroupBy(requires, function (v) return v.RequirementType end)
    ---@type table<string,ProviderItem[]>
    local providersGroupType = Tools.GroupBy(provider, function (v) return v.Type end)

    for key, _ in pairs(OrderRequireType) do
        -- Logging.LogDebug("VirtualNetwor.MakeChain OrderRequireType.key: %s", key)
        local requiresByReqType = requiresByRequiredType[key]
        if (requiresByReqType ~= nil) then
            if (key == "Fuel") then
                table.sort(requiresByReqType, function (a, b) return (OrderFuel[a.Type] or 999) < (OrderFuel[b.Type] or 999) end)
            else
                table.sort(requiresByReqType, function (a, b) return a.Requires.Value < b.Requires.Value end)
            end
            for _, consumer in pairs(requiresByRequiredType[key]) do
                local providersByType = providersGroupType[consumer.Type]
                -- if (key == "Storage")then
                --     Logging.LogDebug("VirtualNetwor.MakeChain require: %s providersByType: %s", require, providersByType)
                -- end
                --Logging.LogDebug("require.Requires: %s", require.Requires)
                if (providersByType ~= nil and (consumer.Requires.Value > 0) and (consumer.Bandwidth.Value > 0)) then
                    for _, provider in pairs(providersByType) do
                        if (provider.FullAmount.Value > 0 and provider.Bandwidth.Value > 0 and provider.Id ~= consumer.Id) then
                            ---@type ChainItem
                            local chain = {
                                Type = consumer.Type,
                                SourceId = provider.Id,
                                DestinationId = consumer.Id,
                                Count = math.min(provider.FullAmount.Value, provider.Bandwidth.Value, consumer.Requires.Value, consumer.Bandwidth.Value),
                                SourceRequireType = provider.RequirementType,
                                DestinationRequireType = consumer.RequirementType
                            }
                            consumer.Bandwidth.Value = consumer.Bandwidth.Value - chain.Count
                            consumer.Requires.Value = consumer.Requires.Value - chain.Count
                            provider.FullAmount.Value = provider.FullAmount.Value - chain.Count
                            provider.Bandwidth.Value = provider.Bandwidth.Value - chain.Count
                            chains[#chains + 1]  = chain
                        end
                    end
                end
            end
        end
    end

    Logging.LogDebug("VirtualNetwor.MakeChain (end) chains: %d", #chains)
    return chains
end

--- func desc
---@param chains ChainItem[]
function VirtualNetwor.ExecuteChains(chains, hashTable)
    Logging.LogDebug("VirtualNetwor:ExecuteChains chains: %s", chains)
    local storageInfoGroup = AccessPoint.GetHashGroup(hashTable, "StorageInfo")
    for _, chain in pairs(chains) do
        if(chain.SourceRequireType == "Storage" and chain.DestinationRequireType == "Storage") then
            StorageTools.TransferItems(
                chain.Type,
                chain.SourceId,
                AccessPoint.GetStorageInfo(chain.SourceId, storageInfoGroup),
                chain.DestinationId,
                AccessPoint.GetStorageInfo(chain.DestinationId, storageInfoGroup),
                chain.Count
            )
        end
    end
    -- for _, chainItems in pairs(chains) do
        -- for _, value in pairs(chainItems.Chains) do
            -- StorageTools.TransferItems(
                -- chainItems.ItemType,
                -- value.SourceId,
                -- AccessPoint.GetStorageInfo(value.SourceId),
                -- value.DestinationId,
                -- AccessPoint.GetStorageInfo(value.DestinationId),
                -- value.Count
            -- )
        -- end
    -- end
end

-- --- func desc
-- ---@param consumers table<integer, RequireItem[]>
-- ---@param providers table<integer, Provider[]>
-- ---@return { SourceId :integer, DestinationId :integer, Count :integer}[]
-- function VirtualNetwor.SumChain(consumers, providers)
--     -- Logging.LogDebug("VirtualNetwor.SumChain\n%s\n%s", consumers, providers)
--     ---@type { Id :integer, Require: integer }[]
--     local sumConsumers = { }
--     -- for id, consumerGroup in pairs(consumers) do
--     --     --sumConsumers[id] = Consumer.Aggregate(consumerGroup)
--     --     sumConsumers[#sumConsumers + 1] = { Id = id, Require = Consumer.Aggregate(consumerGroup)}
--     -- end
--     -- Logging.LogDebug("VirtualNetwor.SumChain sumConsumers = \n%s", sumConsumers)
-- 
--     ---@type { Id :integer, Amount: integer }[]
--     local sumProviders = { }
--     for id, providerGroup in pairs(providers) do
--         --sumProviders[id] = Provider.Aggregate(providerGroup)
--         sumProviders[#sumProviders + 1] = { Id = id, Amount = Provider.Aggregate(providerGroup)}
--     end
--     -- Logging.LogDebug("VirtualNetwor.SumChain sumProviders = \n%s", sumProviders)
-- 
--     table.sort(sumConsumers, function (a, b) return a < b end)
--     table.sort(sumProviders, function (a, b) return a > b end)
-- 
--     return VirtualNetwor.ZipChain(sumConsumers, sumProviders)
-- end

