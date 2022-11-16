--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class BuildingConsumer :Consumer # consumer потребитель
---@field _freeSpace integer #
BuildingConsumer = {
}
---@type BuildingConsumer
BuildingConsumer = Consumer:extend(BuildingConsumer)

--- func desc
---@param id integer # Provider Id. Ex. StorageId.
---@param bandwidth integer # Bandwidth
---@param hashTables? table # HashTables
---@return BuildingConsumer
function BuildingConsumer.new(id, bandwidth, hashTables)
    -- Logging.LogDebug("BuildingConsumer.new id: %d, bandwidth: %s", id, tostring(bandwidth))
    local instance = BuildingConsumer:make(id, bandwidth, hashTables)
    instance._freeSpace = 0
    return instance
end

function BuildingConsumer:GetRequire()
    return self._freeSpace
end

function BuildingConsumer:Update()
    ---@type RequireItem[] #
    local requires = { }
    local bandwidth = ReferenceValue.new(self._bandwidth)
    -- Logging.LogDebug("BuildingConsumer:Update _bandwidth: %d bandwidth:\n%s", self._bandwidth, bandwidth)
    self._requires = requires
    local buildingRequirements = self:GetBuildingRequirementsSelf()
    if (buildingRequirements.Successfully) then
        -- Logging.LogDebug("BuildingConsumer:Update buildingRequirements: %s", buildingRequirements)
        ---@type RequireItem[]
        local requirements = BuildingConsumer.MakeRequirements(self.Id, buildingRequirements.Fuel, "Fuel", bandwidth)
        Tools.TableConcat(requires, requirements)
        -- if(buildingRequirements.Fuel ~= nil) then
        --     Logging.LogDebug("BuildingConsumer:Update\nbuildingRequirements.Fuel = %s\nrequirements = %s", buildingRequirements.Fuel,requirements)
        -- end

        requirements = BuildingConsumer.MakeRequirements(self.Id, buildingRequirements.Water, "Water", bandwidth)
        Tools.TableConcat(requires, requirements)

        requirements = BuildingConsumer.MakeRequirements(self.Id, buildingRequirements.Heart, "Heart", bandwidth)
        Tools.TableConcat(requires, requirements)

        requirements = BuildingConsumer.MakeRequirements(self.Id, buildingRequirements.Ingredient, "Ingredient", bandwidth)
        Tools.TableConcat(requires, requirements)

        requirements = BuildingConsumer.MakeRequirements(self.Id, buildingRequirements.Hay, "Hay", bandwidth)
        Tools.TableConcat(requires, requirements)
    else
        Logging.LogWarning("BuildingConsumer:Update Not readed BuildingRequirements Id: %d", self.Id)
    end
    -- Logging.LogDebug("BuildingConsumer:Update requires: %s", requires)


    local isStorage = Tools.IsStorage(self.Id)
    -- Logging.LogDebug("BuildingConsumer:Update() isStorage: %s", isStorage)
    if (not isStorage) then
        return requires
    end

    local storageInfo = self:GetStorageInfoSelf()
    if (not storageInfo.Successfully) then
        Logging.LogWarning("BuildingConsumer:Update() ~storageInfo.Successfully")
        return requires
    end
    local freeSpace = AccessPoint:GetStorageFreeSpaceSelf(storageInfo)
    if (freeSpace > 0) then
        ---@type RequireItem
        requires[#requires + 1] = { Id = self.Id, Type = storageInfo.TypeStores, Requires = ReferenceValue.new(freeSpace), Bandwidth = bandwidth, RequirementType = "Storage" }
    end

    return requires
end

--- func desc
---@param list UnpackBuildingRequirementsItem[]
---@param requireType RequirementType
---@param bandwidth ReferenceValue
---@param sortToBig boolean|nil
---@param takeFirst integer|nil
---@return RequireItem[]
function BuildingConsumer.MakeRequirements(id, list, requireType, bandwidth, sortToBig, takeFirst)
    ---@type RequireItem[]
    local result = { }
    if(list == nil) then
        return result
    end
    if(sortToBig ~= nil) then
        table.sort(list, function (a, b)
            if (sortToBig) then
                return a.Capacity < b.Capacity
            else
                return a.Capacity > b.Capacity
            end
            --((sortToBig and ()) or ((not sortToBig) and (a.Capacity > b.Capacity)));
        end)
    end
    --- func desc
    ---@param item UnpackBuildingRequirementsItem
    ---@return RequireItem|nil
    local addElement = function (item)
        if (item == nil) then
            return nil
        end
        local require = math.floor(item.Capacity - item.Amount)
        if (require > 0) then
            ---@type RequireItem
            return { Id = id, RequirementType = requireType, Requires = ReferenceValue.new(require), Type = item.Type, Bandwidth = bandwidth }
        end
    end
    if (takeFirst) then
        for i = 1, takeFirst, 1 do
            local value = list[i]
            if (value == nil) then
                break
            end
            local item = addElement(value)
            if(item ~= nil)then
                result[#result + 1] = item
            end
        end
    else
        for _, value in pairs(list) do
            local item = addElement(value)
            if (item ~= nil) then
                result[#result + 1] = item
            end
        end
    end

    return result
end
