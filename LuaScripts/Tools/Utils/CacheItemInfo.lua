--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class CacheItemInfo :Object
---@field _cachedItems table<integer, CacheItemInfoItem>
CacheItemInfo = { }
---@type CacheItemInfo
CacheItemInfo = Object:extend(CacheItemInfo)

---@return CacheItemInfo
function CacheItemInfo.new()
    local instance = CacheItemInfo:make()
    return instance
end

function CacheItemInfo:initialize()
    self._cachedItems = { }
end

---@param id integer
---@return CacheItemInfoItem
function CacheItemInfo:GetInfo(id)
    return Tools.Dictionary.GetOrAddValueLazyVariable(self._cachedItems, id, CacheItemInfo.MakeCachItem)
end

function CacheItemInfo:Clear()
    self._cachedItems = { }
end

---@alias CacheItemInfoItem { Id :integer, Type :string, Category :string, Subcategory :SubCategoryValue }
---@param id integer
---@return CacheItemInfoItem
function CacheItemInfo.MakeCachItem(id)
    return {
        Id = id,
        Type = ModObject.GetObjectType(id),
        Category = ModObject.GetObjectCategory(id),
        Subcategory = ModObject.GetObjectSubcategory(id)
        --["Requires"] = Extensions.UnpackBuildingRequirements(ModBuilding.GetBuildingRequirements(id))
    }
end