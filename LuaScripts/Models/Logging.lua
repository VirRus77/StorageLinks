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
    ---@type table<string, number>
    ---@private
    _logLevelToOrder = { }
}

function Logging.FillOrder()
    Logging._logLevelToOrder = { }
    Logging._logLevelToOrder[LogLevel.Trace]       = 1
    Logging._logLevelToOrder[LogLevel.Debug]       = 2
    Logging._logLevelToOrder[LogLevel.Information] = 3
    Logging._logLevelToOrder[LogLevel.Warning]     = 4
    Logging._logLevelToOrder[LogLevel.Error]       = 5
    Logging._logLevelToOrder[LogLevel.Fatal]       = 6
end
Logging.FillOrder()

--- Set minimal level write log.
---@param logLevel LoggingLevel #
function Logging.SetMinimalLevel (logLevel)
    Logging._minimalLevel = Logging._logLevelToOrder[logLevel]
end

--- func desc
---@param ... any
---@private
function Logging.Log(...)
    ModDebug.Log(os.date("%d.%m.%Y %X"), ...)
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
    
    local cahngedParamsStringFormat = { }
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if (type(value) == "boolean") then
            cahngedParamsStringFormat[i] = tostring(value)
        elseif (type(value) == "nil") then
            cahngedParamsStringFormat[i] = "nil"
        elseif (type(value) == "function") then
            cahngedParamsStringFormat[i] = string.format("[%s]", tostring(value))
        elseif (type(value) == "table") then
            if(value.__tostring ~= nil) then
                cahngedParamsStringFormat[i] = value:__tostring()
            else
                cahngedParamsStringFormat[i] = serializeTable(value)
            end
        else
            cahngedParamsStringFormat[i] = value
        end
    end
    Logging.Log(string.format(" [%s] %s", logLevel, string.format(formatString, table.unpack(cahngedParamsStringFormat))))
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