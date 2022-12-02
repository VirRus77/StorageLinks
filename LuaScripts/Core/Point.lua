--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Point :Object #
---@operator add(Point): Point
---@field X integer
---@field Y integer
Point = {
    X = 0,
    Y = 0
}
---@type Point
Point = Object:extend(Point)

--- func desc
---@param x? integer|nil
---@param y? integer|nil
---@return Point
function Point.new(x, y)
    ---@type Point
    local newInstance = Point:make(x or 0, y or 0)
    return newInstance
end

function Point:initialize(x, y)
    self.X = x
    self.Y = y
    self.meta.__eq = Point.Equals
    self.meta.__tostring = Point.ToString
    self.meta.__add = Point.Add
end

--- Rotate the coordinate point clockwise by 90 degrees. 
--- Negative values - counterclockwise.
---@param point Point
---@param countRotate? integer|nil # Count rotation by 90 degrees. Default 1.
function Point.Rotate(point, countRotate)
    countRotate = countRotate or 1

    countRotate = countRotate % 4
    if (countRotate == 0) then
        return Point.new(point.X, point.Y)
    elseif (countRotate == 1) then
        return Point.new(-point.Y, point.X)
    elseif (countRotate == 2) then
        return Point.new(-point.X, -point.Y)
    elseif (countRotate == 3) then
        return Point.new(point.Y, -point.X)
    end
end

--- Unpack x, y
---@param point Point
---@return integer, integer # x, y
function Point.Unpack(point)
    return point.X, point.Y
end

--- func desc
---@param point1 Point
---@param point2 Point
---@return boolean
function Point.Equals(point1, point2)
    return point1.X == point2.X and point1.Y == point2.Y
end

--- func desc
---@param point1 Point
---@param point2 Point
---@return Point
function Point.Add(point1, point2)
    return Point.new(point1.X + point2.X, point1.Y + point2.Y)
end

--- func desc
---@alias PointString string
---@param point Point
---@return PointString
function Point.ToString(point)
    return string.format("%d, %d", point.X, point.Y)
end