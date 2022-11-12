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

    setmetatable(newInstance, Point)
    newInstance.__index = Point
    return newInstance
end