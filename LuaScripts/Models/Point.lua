--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Point #
---@field X integer
---@field Y integer
Point = {
    X = 0,
    Y = 0
}
Point.__index = Point

--- func desc
---@param x? integer
---@param y? integer
---@return Point
function Point.new(x, y)
    ---@type Point2
    local newInstance = { }

    newInstance.X = x or Point.X
    newInstance.Y = y or Point.Y
    --- Old style
    newInstance[1] = newInstance.X
    newInstance[2] = newInstance.Y

    setmetatable(newInstance, Point)
    newInstance.__index = Point
    return newInstance
end

function Point:__tostring()
    return string.format("%d:%d", self.X, self.Y)
end