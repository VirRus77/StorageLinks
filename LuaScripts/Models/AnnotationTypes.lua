---@class RequireItem
---@field Author integer #
---@field Id integer # BuildingId
---@field Type string #
---@field Requires ReferenceValue #
---@field Amount integer #
---@field Bandwidth ReferenceValue #
---@field RequirementType RequirementType|"Storage" #
RequireItem = { }

---@class ProviderItem
---@field Author integer #
---@field Id integer #
---@field Type string #
---@field Bandwidth ReferenceValue #
---@field FullAmount ReferenceValue #
---@field RequirementType ProviderRequirementType #
ProviderItem = { }

---@class ChainItem
---@field Type string #
---@field SourceId integer #
---@field DestinationId integer #
---@field Count integer #
---@field SourceRequireType ProviderRequirementType #
---@field DestinationRequireType ProviderRequirementType #
ChainItem = { }