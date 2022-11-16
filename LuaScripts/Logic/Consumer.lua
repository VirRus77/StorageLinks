--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Consumer :AccessPoint # consumer
---@field _requires RequireItem[]
---@field _bandwidth integer
Consumer = { }
---@type Consumer
Consumer = AccessPoint:extend(Consumer)

--- func desc
---@param id integer # Provider Id. Ex. StorageId.
-- ---@param type string  # Items type
---@param bandwidth integer # Bandwidth
---@param hashTables? table # HashTables
function Consumer.new(id, bandwidth, hashTables)
    local instance = Consumer:make(id, bandwidth, hashTables)
    return instance
end

function Consumer:initialize(id, bandwidth, hashTables)
    self._bandwidth = bandwidth
    self._updated = false
    self._requires = { }
    self.Id = id
    --self.Type = type
    self.HashTables = hashTables
end

-- --- func desc
-- ---@public
-- ---@return integer
-- function Consumer:Require()
--     if (not self._updated) then
--         self:Update()
--     end
--     return math.min(self._bandwidth, self:GetRequire())
-- end

-- --- Can provide
-- ---@public
-- ---@return integer #
-- function Consumer:FullRequire()
--     if (not self._updated) then
--         self:Update()
--     end
--     return self:GetRequire()
-- end

-- --- func desc
-- ---@protected
-- ---@return integer
-- function Consumer:GetRequire()
--     return 0
-- end

--- func desc
---@return RequireItem[] #
function Consumer:Requires()
    if (not self._updated) then
        self:Update()
    end
    return self._requires
end

-- --- func desc
-- ---@param a Consumer
-- ---@param b Consumer
-- function Consumer.ComparerToSmall(a, b)
--     return Tools.Compare(a:Require(), b:Require(), true)
-- end
-- 
-- --- func desc
-- ---@param a Consumer
-- ---@param b Consumer
-- function Consumer.ComparerToBig(a, b)
--     return Tools.Compare(a:Require(), b:Require())
-- end

--- Aggregate Require
---@param requireItems RequireItem[]
---@return RequireItem[]
function Consumer.Aggregate(requireItems)
    Logging.LogDebug("Consumer.Aggregate requireItems: %d", #requireItems)
    if (#requireItems <= 1) then
        return requireItems
    end
    ---@type RequireItem[]
    local list = { }

    ---@param v RequireItem
    ---@type table<integer, RequireItem[]>
    local groupId = Tools.GroupBy(requireItems, function (v) return v.Id end)
    -- Logging.LogDebug("Consumer.Aggregate groupId: %d", #groupId)
    for _, groupValues in pairs(groupId) do
        if (#groupValues == 1) then
            list[#list + 1] = groupValues[1]
        else
            -- Logging.LogDebug("Consumer.Aggregate (a) groupValues:\n%s", groupValues)
            ---@type table<ReferenceValue, RequireItem[]>
            ---@param v RequireItem
            local bandwidths = Tools.SelectDistinctValues(groupValues, function (v) return v.Bandwidth end)
            -- Logging.LogDebug("Consumer.Aggregate bandwidths: %d", #bandwidths)
            local bandwidthAll = ReferenceValue.new(0)
            -- Logging.LogDebug("Consumer.Aggregate (b) bandwidths:\n%s", bandwidths)
            for key, _ in pairs(bandwidths) do
                bandwidthAll.Value = bandwidthAll.Value + key.Value
            end
            for _, provider in pairs(groupValues) do
                provider.Bandwidth = bandwidthAll
            end
            ---@type table<string, RequireItem>
            local typeGroup = Tools.GroupBy(groupValues, function (v) return v.Type end)
            for _, value in pairs(typeGroup) do
                list[#list + 1] = value[1]
            end
        end
    end

    -- Logging.LogDebug("Consumer.Aggregate (end) \n%s\n%s", requireItems, list)
    Logging.LogDebug("Consumer.Aggregate (end) #requireItems: %d #list: %d", #requireItems, #list)
    return list
end