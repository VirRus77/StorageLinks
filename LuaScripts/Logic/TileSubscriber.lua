--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class TileSubscriber :Object #
---@field _inspectingsLocation string[] #
---@field Id integer #
---@field Location Point #
---@field Callback fun(values :{ InspectingType :string, Values : any }) #
TileSubscriber = {
}
---@type TileSubscriber
TileSubscriber = Object:extend(TileSubscriber)

--- func desc
---@alias TileController_CallbackArgs { Point :Point, Storage :ChangesItem|nil, Buildings :ChangesItem|nil }
---@param id integer
---@param location Point
---@param inspectingTypes string[]
---@param action fun(values :TileController_CallbackArgs)
---@return TileSubscriber
function TileSubscriber.new(id, location, inspectingTypes, action)
    local instance = TileSubscriber:make(id, location, inspectingTypes, action)
    return instance
end

function TileSubscriber:initialize(id, location, inspectingTypes, action)
    self._inspectingsLocation = inspectingTypes
    self.Id = id
    self.Location = location
    self.Callback = action
end

--- func desc
---@param inspectings string[]
function TileSubscriber:AddInspections(inspectings)
    self._inspectingsLocation = Linq.Concat(self._inspectingsLocation, inspectings)
    ---@type string[]
    local values = Linq.DistinctValue(self._inspectingsLocation, function (key, value) return value end)
    self._inspectingsLocation = values
end

--- func desc
---@param inspectings string[]|nil
function TileSubscriber:RemoveInspection(inspectings)
    if(inspectings == nil) then
        self._inspectingsLocation = { }
        return
    end
    self._inspectingsLocation = Linq.Where(
        self._inspectingsLocation,
        function (existValue)
            return not Linq.Contains(
                inspectings,
                function (key, removeValue)
                    return removeValue
                end,
                existValue
            )
        end
    )
end

function TileSubscriber:GetInspectings()
    return self._inspectingsLocation
end