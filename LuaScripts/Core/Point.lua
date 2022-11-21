--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Point :Object #
---@field X integer
---@field Y integer
Point = {
    X = 0,
    Y = 0,
    [1] = 0,
    [2] = 0
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
    self[1] = x
    self[2] = y
end

--- Rotate the coordinate point clockwise by 90 degrees. 
--- Negative values - counterclockwise.
---@param point Point
---@param countRotate? integer|nil # Count rotation by 90 degrees. Default 1.
function Point.Rotate(point, countRotate)
    if (countRotate == nil) then
        countRotate = 1
    end

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

function Point:__tostring()
    return string.format("%d:%d", self.X, self.Y)
end

--- func desc
---@param point Point
function Point:Equals(point)
    return self.X == point.X and self.Y == point.Y
end