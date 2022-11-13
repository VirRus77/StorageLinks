--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Point #
---@field X integer
---@field Y integer
Point = {
    X = 0,
    Y = 0,
    [0] = 0,
    [1] = 0
}
---@type Point|Object
Point = Object:extend(Point)

--- func desc
---@param x? integer
---@param y? integer
---@return Point
function Point.new(x, y)
    ---@type Point
    local newInstance = Point:make(x,y)
    return newInstance
end

function Point:initialize(x, y)
    self.X = x
    self.Y = y
    self[0] = x
    self[1] = y
end

function Point:__tostring()
    return string.format("%d:%d", self.X, self.Y)
end