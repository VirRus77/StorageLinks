--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class VirtualNetwor :Object # 
---@field _index integer #
---@field Providers table<string, Provider> #
---@field Consumers table<string, Consumer> #
---@field HashTables table #
---@field FireWall FireWall|nil #
VirtualNetwor = { }

---@type VirtualNetwor
VirtualNetwor = Object:extend(VirtualNetwor)

--- func desc
---@param fireWall FireWall|nil
---@return VirtualNetwor
function VirtualNetwor.new(fireWall)
    local instance = VirtualNetwor:make(fireWall)
    return instance
end

---@private
function VirtualNetwor:initialize(fireWall)
    self._index = 1
    self.Providers = { }
    self.Consumers = { }
    self.HashTables = { }
    self.FireWall = fireWall
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
       Logging.LogError("VirtualNetwor:RemoveProvider Not found provider %s\n%s", providerId, self.Providers)
       return
    end
    self.Providers[providerId] = nil
end

--- func desc
---@param consumerId string #
function VirtualNetwor:RemoveConsumer(consumerId)
    if (self.Consumers[consumerId] == nil) then
       Logging.LogError("VirtualNetwor:RemoveProvider Not found consumer %s\n%s", consumerId, self.Consumers)
       return
    end
    self.Consumers[consumerId] = nil
end

function VirtualNetwor:TimeCallback()
    local sw = Stopwatch.Start()
    self:ChainProcess()
    -- Logging.LogDebug("VirtualNetwor duration: %f", sw:Elapsed())
end

function VirtualNetwor:ClearHashTables()
    self.HashTables = { }
end

function VirtualNetwor:Clear()
    self:ClearHashTables()
    self._index = 1
    self.Providers = { }
    self.Consumers = { }
    self.HashTables = { }
end

function VirtualNetwor:ChainProcess()
    self:ClearHashTables()
    ---@type RequireItem[]
    local requires = { }

    ---@type table<string, boolean>
    local cashGroup = { }
    local getState = function (id)
        if (self.FireWall == nil) then
            return false
        end
        return self.FireWall:Skip(id)
    end
    --Logging.LogDebug("VirtualNetwor:ChainProcess self.FireWall: %s", self.FireWall)
    for _, consumer in pairs(self.Consumers) do
        local skip = Tools.Dictionary.GetOrAddValueLazyVariable(cashGroup, consumer.Author, getState)
        if (not skip) then
            consumer:BeginRead(self.HashTables)
            Tools.TableConcat(requires, consumer:Requires())
        else
            -- Logging.LogDebug("VirtualNetwor:ChainProcess skip %d", consumer.Author)
        end
    end
    if (#requires == 0) then
        Logging.LogDebug("VirtualNetwor:ChainProcess #requires 0. Exit.")
        return
    else
        -- Logging.LogDebug("VirtualNetwor:ChainProcess requires: %s", requires)
    end

    ---@type ProviderItem[]
    local providers = { }
    -- Providers
    for _, provider in pairs(self.Providers) do
        local skip = Tools.Dictionary.GetOrAddValueLazyVariable(cashGroup, provider.Author, getState)
        if (not skip) then
            provider:BeginRead(self.HashTables)
            local providerItem = provider:Amount()
            if (providerItem ~= nil and providerItem.FullAmount.Value > 0) then
                providers[#providers + 1] = providerItem
            end
        else
            -- Logging.LogDebug("VirtualNetwor:ChainProcess skip %d", provider.Author)
        end
    end
    if (#providers == 0) then
        Logging.LogDebug("VirtualNetwor:ChainProcess #providers 0. Exit.")
        return
    else
        -- Logging.LogDebug("VirtualNetwor:ChainProcess providers: %s", providers)
    end

    -- Aggregates
    -- Logging.LogDebug("VirtualNetwor:ChainProcess requires: %d", #requires)
    requires = Consumer.Aggregate(requires)
    -- Logging.LogDebug("VirtualNetwor:ChainProcess after Aggregate requires: %d", #requires)

    -- Logging.LogDebug("VirtualNetwor:ChainProcess providers: %d", #providers)
    providers = Provider.Aggregate(providers)
    -- Logging.LogDebug("VirtualNetwor:ChainProcess providers after Aggregate: %d", #providers)

    -- Logging.LogDebug("VirtualNetwor:ChainProcess (make) requires:%d providers:%d", #requires, #providers)
    local chains = VirtualNetwor.MakeChain(requires, providers)
    self:ExecuteChains(chains)
end

--- func desc
---@param requires RequireItem[]
---@param provider ProviderItem[]
---@return ChainItem[]
function VirtualNetwor.MakeChain(requires, provider)
    -- Logging.LogDebug("VirtualNetwor.MakeChain requires: %d provider: %d", #requires, #provider)
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
                -- Logging.LogDebug("VirtualNetwor.MakeChain before sort fuel:\n%s", requiresByReqType)
                table.sort(requiresByReqType, function (a, b) return (OrderFuel[a.Type] or 999) < (OrderFuel[b.Type] or 999) end)
                -- Logging.LogDebug("VirtualNetwor.MakeChain after sort fuel:\n%s", requiresByReqType)
            else
                -- Logging.LogDebug("VirtualNetwor.MakeChain before sort value:\n%s", requiresByReqType)
                table.sort(requiresByReqType,
                function (a, b)
                    return (a.Requires.Value < b.Requires.Value)
                end)
                -- Logging.LogDebug("VirtualNetwor.MakeChain after sort value:\n%s", requiresByReqType)
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

    -- Logging.LogDebug("VirtualNetwor.MakeChain (end) chains: %d", #chains)
    return chains
end

--- func desc
---@param chains ChainItem[]
function VirtualNetwor:ExecuteChains(chains)
    Logging.LogTrace("VirtualNetwor:ExecuteChains chains: %s", chains)
    local storageInfoGroup = AccessPoint.GetHashGroup(self.HashTables, "StorageInfo")
    for _, chain in pairs(chains) do
        if (chain.SourceRequireType ~= "Storage") then
            Logging.LogWarning("VirtualNetwor.ExecuteChains SourceRequireType ~= \"Storage\": %s", chain.SourceRequireType)
        elseif (chain.DestinationRequireType == "Fuel") then
            StorageTools.TransferFuel(
                chain.Type,
                chain.SourceId,
                AccessPoint.GetStorageInfo(chain.SourceId, storageInfoGroup),
                chain.DestinationId,
                --AccessPoint.GetStorageInfo(chain.DestinationId, storageInfoGroup),
                chain.Count
            )
        elseif (chain.DestinationRequireType == "Water") then
            StorageTools.TransferWater(
                chain.Type,
                chain.SourceId,
                AccessPoint.GetStorageInfo(chain.SourceId, storageInfoGroup),
                chain.DestinationId,
                --AccessPoint.GetStorageInfo(chain.DestinationId, storageInfoGroup),
                chain.Count
            )
        elseif (chain.DestinationRequireType == "Ingredient") then
            StorageTools.TransferIngredient(
                chain.Type,
                chain.SourceId,
                AccessPoint.GetStorageInfo(chain.SourceId, storageInfoGroup),
                chain.DestinationId,
                --AccessPoint.GetStorageInfo(chain.DestinationId, storageInfoGroup),
                chain.Count
            )
        elseif (chain.DestinationRequireType == "Storage") then
            StorageTools.TransferItems(
                chain.Type,
                chain.SourceId,
                AccessPoint.GetStorageInfo(chain.SourceId, storageInfoGroup),
                chain.DestinationId,
                AccessPoint.GetStorageInfo(chain.DestinationId, storageInfoGroup),
                chain.Count
            )
        elseif (chain.DestinationRequireType == "Heart") then
            StorageTools.TransferHeart(
                chain.Type,
                chain.SourceId,
                AccessPoint.GetStorageInfo(chain.SourceId, storageInfoGroup),
                chain.DestinationId,
                --AccessPoint.GetStorageInfo(chain.DestinationId, storageInfoGroup),
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

