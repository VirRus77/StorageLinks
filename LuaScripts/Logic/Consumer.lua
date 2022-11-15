--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Consumer :AccessPoint # consumer
---@field FullRequire integer # Full require
Consumer = { }
---@type Consumer
Consumer = AccessPoint:extend(Consumer)

--- func desc
---@param id integer # Provider Id. Ex. StorageId.
---@param type string  # Items type
---@param bandwidth integer # Bandwidth
---@param hashTables? table # HashTables
function Consumer.new(id, type, bandwidth, hashTables)
    local instance = Consumer:make(id, type, bandwidth, hashTables)
    return instance
end

function Consumer:initialize(id, type, bandwidth, hashTables)
    self._bandwidth = bandwidth
    self._updated = false
    self.Id = id
    self.Type = type
    self.HashTables = hashTables
end

--- func desc
---@public
---@return integer
function Consumer:Require()
    if (not self._updated) then
        self:Update()
    end
    return math.min(self._bandwidth, self:GetRequire())
end

--- Can provide
---@public
---@return integer #
function Consumer:FullRequire()
    if (not self._updated) then
        self:Update()
    end
    return self:GetRequire()
end

--- func desc
---@protected
---@return integer
function Consumer:GetRequire()
    return 0
end

--- func desc
---@param a Consumer
---@param b Consumer
function Consumer.ComparerToSmall(a, b)
    return Tools.Compare(a:Require(), b:Require(), true)
end

--- func desc
---@param a Consumer
---@param b Consumer
function Consumer.ComparerToBig(a, b)
    return Tools.Compare(a:Require(), b:Require())
end

--- Aggregate Require
---@param consumers Consumer[]
---@return integer
function Consumer.Aggregate(consumers)
    local require = 0
    local id = consumers[1].Id
    for _, consumer in pairs(consumers) do
        if(consumer.Id ~= id)then
            error("Consumer.Aggregate Id not equals.", 666)
        end
        require = require + consumer:Require()
    end
    return math.min(require, consumers[1]:FullRequire())
end