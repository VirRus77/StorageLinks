--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


Linq = { }

--- func desc
---@generic TKey :integer
---@generic TValue :any|table
---@param table1 table<TKey, TValue>
---@param table2 table<TKey, TValue>
---@return table<TKey, TValue> # Concat in table1 values
function Linq.Concat(table1, table2)
    if (table1 == nil or table2 == nil) then
        Logging.LogError("Linq.Concat table1: %s\ntable2: %s", table1, table2)
        error("Linq.Concat table1 == nil or table2 == nil")
    end

    for _, value in pairs(table2) do
        table1[#table1 + 1] = value
    end
    return table1
end

--- func desc
---@generic TKey :any|table
---@generic TValue :any|table
---@param table1 table<TKey, TValue>
---@param table2 table<TKey, TValue>
---@return table<TKey, TValue> # Concat in table1 values
function Linq.ConcatTable(table1, table2)
    for key, value in pairs(table2) do
        table1[key] = value
    end
    return table1
end

--- func desc
---@generic TKey :any
---@generic TValue :any
---@generic TSelectKey :any
---@param table table<TKey, TValue>
---@param keySelector fun(key: TKey, value :TValue) :TSelectKey
---@param keyValue TSelectKey
---@return boolean
function Linq.Contains(table, keySelector, keyValue)
    for key, value in pairs(table) do
        if (keySelector(key, value) == keyValue) then
            return true
        end
    end
    return false
end

--- func desc
---@generic T :any
---@param table table<integer, T>
---@param fun fun(key :integer, value :T) :boolean
---@return table<integer, T>
function Linq.Where(table, fun)
    local list = { }
    for key, value in pairs(table) do
        if (fun(key, value)) then
            list[#list + 1] = value
        end
    end
    return list
end

--- func desc
---@generic TKey :any
---@generic TValue :any
---@generic TSelectKey :any
---@param table table<TKey, TValue>
---@param keySelector fun(key: TKey, value :TValue) :boolean
---@return table table<TKey, TValue>
function Linq.WhereTable(table, keySelector)
    local list = { }
    for key, value in pairs(table) do
        if (keySelector(key, value)) then
            list[key] = value
        end
    end
    return list
end

--- func desc
---@generic TKey :any
---@generic TValue :any
---@generic TDistinctKey :any
---@param table table<TKey, TValue>
---@param keySelector fun(key: TKey, value :TValue) :TDistinctKey
---@return TDistinctKey[]
function Linq.DistinctValue(table, keySelector)
    local list = { }
    for key, value in pairs(table) do
        local keySelect = keySelector(key, value)
        list[keySelect] = keySelect
    end
    local newTable = { }
    for _, value in pairs(list) do
        newTable[#newTable + 1] = value
    end
    return newTable
end

--- func desc
---@generic TKey :any|table
---@generic TValue :any|table
---@generic TDistinctKey :any|table
---@param table table<TKey, TValue>
---@param keySelector fun(key: TKey, value :TValue) :TDistinctKey
---@return TDistinctKey[]
function Linq.Select(table, keySelector)
    local list = { }
    for key, value in pairs(table) do
        local keySelect = keySelector(key, value)
        list[#list + 1] = keySelect
    end
    return list
end

--- func desc
---@generic TKey :any|table
---@generic TValue :any|table
---@param table table<TKey, TValue>
---@param action fun(key: TKey, value :TValue)
function Linq.ForEach(table, action)
    for key, value in pairs(table) do
        action(key, value)
    end
end