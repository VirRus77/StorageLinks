--- @type 
Settings = {
    ---@type { Name :string, Value :any, Callback :function }
    EnableDebugMode = {
        Name = "Enable Debug Mode",
        Value = false,
    },
    ---@type { Name :string, Value :any, Callback :function }
    ReplaceOldBuildings = {
        Name = "Replace Old Buildings",
        Value = false,
    },
    ---@type { Name :string, Value :any, Callback :function }
    DebugMove = {
        Name = "Debug: Move",
        Value = 8,
    },
}

function Settings.ExposedVariableCallback(value, name)
    Settings:ExposedVariableCallbackSelf(value, name)
end

function Settings:ExposedVariableCallbackSelf(value, name)
    -- Logging.Log("ExposedVariableCallbackSelf", serializeTable({
    --     value = value,
    --     name = name,
    --     Settings = self
    -- }))
    if(self.EnableDebugMode.Name == name) then
        self.EnableDebugMode.Value = value
        DEBUG_ENABLED = value
    end
    if (self.ReplaceOldBuildings.Name == name) then
        self.ReplaceOldBuildings.Value = value
    end
end

function Settings.ExposedKeyCallback(name)
    Settings:ExposedKeyCallbackSelf(name)
end

--- func desc
---@param name string
function Settings:ExposedKeyCallbackSelf(name)
    if ModBase.GetGameState() ~= 'Normal' then
        return
    end
    if (name == self.DebugMove.Name) then
        locateLinks(BuildingLevels.Crude)
        locateLinks(BuildingLevels.Good)
        locateLinks(BuildingLevels.Super)
    end
end