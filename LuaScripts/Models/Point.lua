---@class Point #
---@field X integer
---@field Y integer
Point = { }

--- func desc
---@param x integer
---@param y integer
function Point.new(x, y)
    ---@type Point2
    local newInstance = {
        X = x,
        Y = y
    }

    setmetatable(newInstance, Point)
    newInstance.__index = Point
    return newInstance
end