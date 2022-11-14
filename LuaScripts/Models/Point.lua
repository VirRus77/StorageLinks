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

--- Rotate the coordinate point clockwise by 90 degrees.
---@param point Point
---@param countRotate? integer # Count rotation by 90 degrees. Default 1.
function Point.Rotate(point, countRotate)
    if (countRotate == nil) then
        countRotate = 1
    end
    if (countRotate < 0) then
        error("Point.Rotate countRotate < 0", 666)
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