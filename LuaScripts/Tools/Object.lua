-- https://github.com/luvit/luvit/blob/master/deps/core.lua#L78
--[[
This is the most basic object in Luvit. It provides simple prototypal
inheritance and inheritable constructors. All other objects inherit from this.
]]
---@class Object
---@function create
---@function make
---@function initialize(... vargs)
Object = {}
Object.meta = {__index = Object}

-- Create a new instance of this object
---@param initValues? table|nil
---@return Object
function Object:create()
    local meta = rawget(self, "meta")
    if not meta then error("Cannot inherit from instance object") end
    return setmetatable({}, meta)
end

--[[
Creates a new instance and calls `obj:initialize(...)` if it exists.
    local Rectangle = Object:extend()
    function Rectangle:initialize(w, h)
      self.w = w
      self.h = h
    end
    function Rectangle:getArea()
      return self.w * self.h
    end
    local rect = Rectangle:new(3, 4)
    p(rect:getArea())
]]
---@return Object|any
function Object:make(...)
  local instance = self:create()
  if type(instance.initialize) == "function" then
    instance:initialize(...)
  end
  return instance
end

--[[
Creates a new sub-class.
    local Square = Rectangle:extend()
    function Square:initialize(w)
      self.w = w
      self.h = h
    end
]]

--- func desc
---@param defaultValues table|nil
---@return Object|any
function Object:extend(defaultValues)
    local instance = self:create()
    local meta = {}
    -- move the meta methods defined in our ancestors meta into our own
    --to preserve expected behavior in children (like __tostring, __add, etc)
    for k, v in pairs(self.meta) do
        meta[k] = v
    end
    if (defaultValues ~= nil and type(defaultValues) == "table") then
        for key, value in pairs(defaultValues) do
            instance[key] = value
        end
    end
    meta.__index = instance
    meta.super = self
    instance.meta = meta

    return instance
end