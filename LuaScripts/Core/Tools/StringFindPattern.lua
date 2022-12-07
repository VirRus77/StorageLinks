--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class StringFindPattern :Object
---@field _childrens StringFindPattern[]
---@field _beforeFunctions (fun(value :string) :string)[]
---@field _afterFunctions (fun(value :string) :string)[]
---@field FindPattern string
StringFindPattern = {}
---@type StringFindPattern
StringFindPattern = Object:extend(StringFindPattern)

--- Constructor
---@param findPattern string
---@return StringFindPattern
function StringFindPattern.new(findPattern)
    local instance = StringFindPattern:make(findPattern)
    return instance
end

function StringFindPattern:initialize(findPattern)
    self.FindPattern = findPattern
    self._childrens = { }
    self._beforeFunctions = { }
    self._afterFunctions = { }
end

--- func desc
---@param value string #
---@param countEntry integer|nil #
---@return string[]|nil #
function StringFindPattern:Find(value, countEntry)
    local value = self:BeforeAppend(value)
    local list = { }
    local startPos = 1
    while true do
        if (countEntry ~= nil and #list == countEntry) then
            break
        end
        local startFound, endFound = string.find(value, self.FindPattern, startPos)
        if (startFound == nil or endFound == nil) then
            if (#list == 0) then
                return nil
            else
                break
            end
        end
        local subString = string.sub(value, startFound --[[@as integer]], endFound --[[@as integer]])
        startPos = endFound + 1
        local foundValue = self:AfterAppend(subString)
        list[#list + 1] = foundValue
    end
    if (#list == 0) then
        return nil
    end

    if (#self._childrens == 0) then
        return list
    end

    local listChildsValue = { }
    for _, foundValue in pairs(list) do
        for _, child in pairs(self._childrens) do
            local childsValue = child:Find(foundValue)
            if (childsValue == nil) then
                return nil
            end
            Tools.TableConcat(listChildsValue, childsValue)
        end
    end
    return listChildsValue
end

--- func desc
---@param functionValue fun(string) :string #
---@return StringFindPattern
function StringFindPattern:BeforeFind(functionValue)
    self._beforeFunctions[#self._beforeFunctions + 1] = functionValue
    return self
end

--- func desc
---@param functionValue fun(string) :string #
---@return StringFindPattern
function StringFindPattern:AfterFind(functionValue)
    self._afterFunctions[#self._afterFunctions + 1] = functionValue
    return self
end

--- func desc
---@param findPattern string|StringFindPattern
---@return StringFindPattern
function StringFindPattern:AddChild(findPattern)
    ---@type StringFindPattern
    local pattern
    if (type(findPattern) == "string")then
        pattern = StringFindPattern.new(findPattern)
    else
        pattern = findPattern
    end

    self._childrens[#self._childrens + 1] = pattern
    return pattern
end

--- func desc
---@param findPatterns string[]|StringFindPattern[]
---@return StringFindPattern[]
function StringFindPattern:AddChilds(findPatterns)
    local list = { }
    for _, findPattern in pairs(findPatterns) do
        list[#list + 1] = self:AddChild(findPattern)
    end
    return list
end

--- func desc
---@param value string
---@return string
function StringFindPattern:BeforeAppend(value)
    for _, applyFunction in pairs(self._beforeFunctions) do
        value = applyFunction(value)
    end
    return value
end

--- func desc
---@param value string
---@return string
function StringFindPattern:AfterAppend(value)
    for _, applyFunction in pairs(self._afterFunctions) do
        value = applyFunction(value)
    end
    return value
end