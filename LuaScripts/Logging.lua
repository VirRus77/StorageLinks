Logging = { }

--- func desc
---@param ... any
function Logging.Log(...)
    ModDebug.Log(os.date("%d.%m.%Y %X"), ": ", ...)
end