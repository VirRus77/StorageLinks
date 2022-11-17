--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@class Animation :Object
---@field Id integer # Assocciate object Id
Animation = { }
---@type Animation
Animation = Object:extend(Animation)

--- func desc
---@param id integer
function Animation.new(id)
    local instance = Animation:make(id)
end

function Animation:initialize(id)
    self.Id = id
end