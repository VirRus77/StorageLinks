--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class TranslateItem :Object
---@field UniqType ReferenceValue<string>
---@field Name string
---@field Description string
TranslateItem = { }
---@type Stopwatch
TranslateItem = Object:extend(TranslateItem)

--- func desc
---@param uniqType ReferenceValue<string>
---@param name string
---@param description string
---@return TranslateItem
function TranslateItem.new(uniqType, name, description)
    local instance = TranslateItem:make(uniqType, name, description)
    return instance
end

function TranslateItem:initialize(uniqType, name, description)
    self.UniqType = uniqType
    self.Name = name
    self.Description = description
end