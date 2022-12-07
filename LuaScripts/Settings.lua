--- @type { Name :string, Value :any, Callback :function }[]
Settings = {
    ---@type { Name :string, Value :any, Callback :function }
    DebugMode = {
        Name = "Debug Mode",
        Value = false,
    },
    ---@type { Name :string, Value :any, Callback :function }
    ReplaceOldBuildings = {
        Name = "Replace Old Buildings",
        Value = false,
    },
    ---@type { Name :string, Value :any, Callback :function }
    DebugMove = {
        Name = "Key Debug Move",
        Value = 8,
    },
}

function Settings.ExposedVariableCallback(value, name)
    Settings:ExposedVariableCallbackSelf(value, name)
end

function Settings:ExposedVariableCallbackSelf(value, name)
    -- Logging.LogDebug("ExposedVariableCallbackSelf", serializeTable({
    --     value = value,
    --     name = name,
    --     Settings = self
    -- }))
    if (self.DebugMode.Name == name) then
        self.DebugMode.Value = value
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
        TIMERS_STACK:Immediately()
    end
end