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
    if (self.Providers[providerId] ~= nil) then
       Logging.LogError("VirtualNetwor:RemoveProvider Not found provider %s", providerId)
       return
    end
    self.Providers[providerId] = nil
end

--- func desc
---@param consumerId string #
function VirtualNetwor:RemoveConsumer(consumerId)
    if (self.Consumers[consumerId] ~= nil) then
       Logging.LogError("VirtualNetwor:RemoveProvider Not found provider %s", consumerId)
       return
    end
    self.Consumers[consumerId] = nil
end

function VirtualNetwor:TimeCallback()
    ---@alias AggregateConsumerProvider table< string, AggregateConsumerProviderItem >
    ---@alias AggregateConsumerProviderItem { Consumers : table<integer, Consumer[]>, Providers :Provider<integer, Provider[]> }
    ---@type AggregateConsumerProvider
    local aggregateHash = { }
    self:ClearHashTables()

    local consumersCount = 0
    -- local consumersByType = {}
    for _, consumer in pairs(self.Consumers) do
        consumer:BeginRead(self.HashTables)
        if (consumer:Require() > 0) then
            consumersCount = consumersCount + 1
            -- local consumerGroup = Tools.Dictionary.GetOrAddValue(consumersByType, consumer.Type, { })
            -- consumerGroup[#consumerGroup + 1] = consumer
            local aggregateConsumerType = Tools.Dictionary.GetOrAddValue(aggregateHash, consumer.Type, { })
            local aggregateConsumers = Tools.Dictionary.GetOrAddValue(aggregateConsumerType, "Consumers", { })
            local aggregateConsumersId = Tools.Dictionary.GetOrAddValue(aggregateConsumers, consumer.Id, { })
            aggregateConsumersId[#aggregateConsumersId + 1] = consumer
        end
    end
    Logging.LogDebug("VirtualNetwor:TimeCallback consumersCount: %d", consumersCount)
    if (consumersCount == 0) then
        return
    end

    local providersCount = 0
    for key, _ in pairs(aggregateHash) do
        for _, provider in pairs(self.Providers) do
            provider:BeginRead(self.HashTables)
            --Logging.LogDebug("provider %d T:%s Amount:%d\n%s", provider.Id, provider.Type ,provider:Amount(), provider)
            if(provider:Amount() > 0) then
                providersCount = providersCount + 1
                -- local providerGroup = Tools.Dictionary.GetOrAddValue(providersByType, provider.Type, { })
                -- providerGroup[#providerGroup + 1] = provider
                local aggregateConsumerType = aggregateHash[provider.Type]
                --Logging.LogDebug("aggregateConsumerType %s", aggregateConsumerType)
                if(aggregateConsumerType ~= nil) then
                     local aggregateProviders = Tools.Dictionary.GetOrAddValue(aggregateConsumerType, "Providers", { })
                     local aggregateProvidersId = Tools.Dictionary.GetOrAddValue(aggregateProviders, provider.Id, { })
                     aggregateProvidersId[#aggregateProvidersId + 1] = provider
                end
            end
        end
    end
    Logging.LogDebug("VirtualNetwor:TimeCallback providersCount: %d", providersCount)
    if (providersCount == 0) then
        return
    end

    local chains = self.MakeChain(aggregateHash)
    Logging.LogDebug("VirtualNetwor:TimeCallback chainsCount: %d", #chains)
    self.ExecuteChains(chains)
end

function VirtualNetwor:ClearHashTables()
    self.HashTables = { }
end

---@param aggregateHash AggregateConsumerProvider
---@return { ItemType :string, Chains :ChainItem }[]
function VirtualNetwor.MakeChain(aggregateHash)
    Logging.LogDebug("VirtualNetwor.MakeChain\naggregateHash = %s", aggregateHash)
    ---@type { ItemType :string, Chains :ChainItem[] }[]
    local chainList = { }
    for itemType, aggregateValue in pairs(aggregateHash) do
        if (aggregateValue.Providers ~= nil) then
            local chains =  VirtualNetwor.SumChain(aggregateValue.Consumers, aggregateValue.Providers)
            chainList[#chainList + 1] = { ItemType = itemType, Chains = chains }
        end
        -- for _, value in pairs(aggregateValue) do
        --     Logging.LogDebug("VirtualNetwor.MakeChain\n%s", value)
        --     if (value.Providers ~= nil) then
        --         local chains =  VirtualNetwor.SumChain(value.Consumers, value.Providers)
        --         chainList[#chainList + 1] = { ItemType = itemType, Chains = chains }
        --     end
        -- end
    end
    return chainList
end

--- func desc
---@param consumers table<integer, Consumer[]>
---@param providers table<integer, Provider[]>
---@return { SourceId :integer, DestinationId :integer, Count :integer}[]
function VirtualNetwor.SumChain(consumers, providers)
    Logging.LogDebug("VirtualNetwor.SumChain\n%s\n%s", consumers, providers)
    ---@type { Id :integer, Require: integer }[]
    local sumConsumers = { }
    for id, consumerGroup in pairs(consumers) do
        --sumConsumers[id] = Consumer.Aggregate(consumerGroup)
        sumConsumers[#sumConsumers + 1] = { Id = id, Require = Consumer.Aggregate(consumerGroup)}
    end
    Logging.LogDebug("VirtualNetwor.SumChain sumConsumers = \n%s", sumConsumers)

    ---@type { Id :integer, Amount: integer }[]
    local sumProviders = { }
    for id, providerGroup in pairs(providers) do
        --sumProviders[id] = Provider.Aggregate(providerGroup)
        sumProviders[#sumProviders + 1] = { Id = id, Amount = Provider.Aggregate(providerGroup)}
    end
    Logging.LogDebug("VirtualNetwor.SumChain sumProviders = \n%s", sumProviders)

    table.sort(sumConsumers, function (a, b) return a < b end)
    table.sort(sumProviders, function (a, b) return a > b end)
    -----@type { Key :integer, Value :integer }[]
    --local sortedSumConsumers = Tools.TableSort(sumConsumers, function (a, b) return Tools.Compare(a, b) end)
    --table.sort(sumConsumers, function (a, b) return Tools.Compare(a, b, true) end) or error("VirtualNetwor.SumChain table sort", 666) or { }
    -----@type { Key :integer, Value :integer }[]
    --local sortedSumProviders = Tools.TableSort(sumProviders, function (a, b) return Tools.Compare(a, b, true) end)
    --local sortedSumProviders = table.sort(sumProviders, function (a, b) return Tools.Compare(a, b, true) end) or error("VirtualNetwor.SumChain table sort", 666) or { }
    return VirtualNetwor.ZipChain(sumConsumers, sumProviders)
end

--- func desc
---@param consumers { Id :integer, Require: integer }[]
---@param providers { Id :integer, Amount: integer }[]
---@return { SourceId :integer, DestinationId :integer, Count :integer}[]
function VirtualNetwor.ZipChain(consumers, providers)
    ---@alias ChainItem { SourceId :integer, DestinationId :integer, Count :integer }
    ---@type ChainItem[]
    local chains = { }
    for _, consumerValue in pairs(consumers) do
        local consumerId = consumerValue.Id
        local required = consumerValue.Require
        ---@type ChainItem
        local chain = { DestinationId = consumerId }
        for providerIndex, providerValue in pairs(providers) do
            if(consumerId ~= providerValue.Id and providerValue.Amount > 0) then
                chain.SourceId = providerValue.Id
                chain.Count = math.min(required, providerValue.Amount)
                required = required - chain.Count
                providers[providerIndex].Amount = providerValue.Amount - chain.Count
                chains[#chains + 1] = chain
                if (required == 0) then
                    break
                end
            end
        end
    end
    return chains
end

--- func desc
---@param chains { ItemType :string, Chains :ChainItem[] }[]
function VirtualNetwor.ExecuteChains(chains)
    for _, chainItems in pairs(chains) do
        for _, value in pairs(chainItems.Chains) do
            StorageTools.TransferItems(
                chainItems.ItemType,
                value.SourceId,
                AccessPoint.GetStorageInfo(value.SourceId),
                value.DestinationId,
                AccessPoint.GetStorageInfo(value.DestinationId),
                value.Count
            )
        end
    end
end

-- --- func desc
-- ---@param a Consumer[]
-- ---@param b Consumer[]
-- function VirtualNetwor.SortConsumersToBig(a, b)
--     return Tools.Compare(Consumer.Aggregate(a), Consumer.Aggregate(b))
-- end

-- --- func desc
-- ---@param a Provider[]
-- ---@param b Provider[]
-- function VirtualNetwor.SortProvidersToSmall(a, b)
--     return Tools.Compare(Provider.Aggregate(a), Provider.Aggregate(b))
-- end
