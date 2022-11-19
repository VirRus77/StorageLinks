--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


-- ---@class BuildingItem
-- ---@field Type ReferenceValue<string>
-- ---@field Name string
-- ---@field Ingridients string[]
-- ---@field IngridientsAmount integer[]
-- ---@field ModelName string
-- ---@field Area Area
-- ---@field AccessPoint Point2 | nil
-- ---@field Scale? number
-- ---@field Rotation? Point3
-- ---@field Walkable? boolean
-- ---@field CustomModel :boolean
-- BuildingItem = { }
-- ---@type BuildingItem
-- BuildingItem = Object:extend(BuildingItem)

-- ---@param uniqType string
-- ---@param ingridients string[]
-- ---@param ingridientsAmount integer[]
-- ---@param modelName string
-- ---@param area Area
-- ---@param accessPoint Point | nil
-- ---@param scale? number
-- ---@param rotation? Point3
-- ---@param walkable? boolean
-- ---@param customModel? boolean # Default - true
-- function BuildingItem.new(uniqType, ingridients, ingridientsAmount, modelName, area, accessPoint, scale, rotation, walkable, customModel)
-- end

-- function BuildingItem:initialize(uniqType, ingridients, ingridientsAmount, modelName, area, accessPoint, scale, rotation, walkable, customModel)
--     self.UniqType = ReferenceValue.new(uniqType)
--     self.Ingridients = ingridients
--     self.IngridientsAmount = ingridientsAmount
--     self.ModelName = modelName
--     self.Area = area
--     self.AccessPoint = accessPoint
--     self.Scale = scale
--     self.Rotation = rotation
--     self.Walkable = walkable
--     self.CustomModel = customModel or true
-- end

---Type :string, Name :string, Ingridients :string[], IngridientsAmount :integer[], ModelName :string, TopLeft :Point2, BottomRigth :Point2, AccessPoint :Point2 | nil, Scale? :number, Rotation? :Point3, Walkable? :boolean, CustomModel :boolean