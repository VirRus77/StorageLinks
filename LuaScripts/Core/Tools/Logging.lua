--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@alias LoggingLevel "TRC"|"DBG"|"INF"|"WRN"|"ERR"|"FTL"
---@enum LogLevel
LogLevel = {
    Trace       = "TRC",
    Debug       = "DBG",
    Information = "INF",
    Warning     = "WRN",
    Error       = "ERR",
    Fatal       = "FTL",
}

Logging = {
    ---@type number #
    ---@private
    _minimalLevel = 3,
    --- List show log levels.
    ---@private
    ---@type table<string, number>
    _logLevelToOrder = {
        [LogLevel.Trace]       = 1,
        [LogLevel.Debug]       = 2,
        [LogLevel.Information] = 3,
        [LogLevel.Warning]     = 4,
        [LogLevel.Error]       = 5,
        [LogLevel.Fatal]       = 6,
    }
}

--- Set minimal level write log.
---@param logLevel LoggingLevel #
function Logging.SetMinimalLevel (logLevel)
    Logging._minimalLevel = Logging._logLevelToOrder[logLevel]
end

--- func desc
---@param ... any
---@private
function Logging.Log(...)
    local a, b = math.modf(os.clock())
    local ms = "000"
    if (b ~= 0) then
        ms = tostring(b):sub(3,5)
    end
    ModDebug.Log(os.date("%d.%m.%Y %X") .. "." .. ms, ...)
end

--- func desc
---@param logLevel LoggingLevel
---@param formatString string
---@param ... any
---@private
function Logging.LogLevel(logLevel, formatString, ...)
    local show = Logging._minimalLevel <= Logging._logLevelToOrder[logLevel]
    if (not show) then
        return
    end

    Logging.Log(string.format(" [%s] %s", logLevel, StringFormat.UnpackStringFormat(formatString, ...)))
end

--- 
---@param formatString string
---@param ... any
function Logging.LogTrace (formatString, ...)
    Logging.LogLevel(LogLevel.Trace, formatString, ...)
end

--- 
---@param formatString string
---@param ... any
function Logging.LogDebug (formatString, ...)
    Logging.LogLevel(LogLevel.Debug, formatString, ...)
end

---@param formatString string
---@param ... any
function Logging.LogInformation (formatString, ...)
    Logging.LogLevel(LogLevel.Information, formatString, ...)
end

---@param formatString string
---@param ... any
function Logging.LogWarning (formatString, ...)
    Logging.LogLevel(LogLevel.Warning, formatString, ...)
end

---@param formatString string
---@param ... any
function Logging.LogError (formatString, ...)
    Logging.LogLevel(LogLevel.Error, formatString, ...)
end

---@param formatString string
---@param ... any
function Logging.LogFatal (formatString, ...)
    Logging.LogLevel(LogLevel.Fatal, formatString, ...)
end

---@param value any
---@return string
function Logging.ValueType(value)
    return tostring(value) .. " :" .. type(value)
end