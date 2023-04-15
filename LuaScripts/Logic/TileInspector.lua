--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class TileInspector :Object
---@field _callbacks table<integer, fun(location :Point)> #
---@field _inspectings table<string, fun(location :Point) :any> #
---@field Location Point
TileInspector = {
}
---@type TileInspector
TileInspector = Object:extend(TileInspector)

--- func desc
---@param location Point
---@return TileInspector
function TileInspector.new(location)
    local instance = TileInspector:make(location)
    return instance
end

function TileInspector:initialize(location)
    self._callbacks = { }
    self._callbacks = { }
    self.Location = location
end

--- func desc
---@param name string # Inspecting name
---@param fun fun(location :Point) :any
function TileInspector:AddInspecting(name, fun)
    Tools.Dictionary.GetOrAddValueLazy(self._inspectings, name, fun)
end

--- func desc
---@param name string # Inspecting name
function TileInspector:RemoveInspecting(name)
    self._inspectings[name] = nil
end

--- func desc
---@param id any
---@param fun fun()
function AddCallback(id, fun)
    
end