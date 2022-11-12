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
    AcceptLogLevel = {
        TRC = 1,
        DBG = 2,
        INF = 3,
        WRN = 4,
        ERR = 5,
        FTL = 6,
    }
}

--- Set minimal level write log.
---@param logLevel LoggingLevel #
function Logging.SetMinimalLevel (logLevel)
    Logging._minimalLevel = Logging.AcceptLogLevel[logLevel]
end

--- func desc
---@param ... any
function Logging.Log(...)
    ModDebug.Log(os.date("%d.%m.%Y %X"), ...)
end

function Logging.LogTrace (...)
    Logging.LogLevel(LogLevel.Trace, ...)
end

--- 
---@param formatString string
---@param ... any
function Logging.LogDebug (formatString, ...)
    Logging.LogLevel(LogLevel.Debug, string.format(formatString, ...))
end

function Logging.LogInformation (formatString, ...)
    Logging.LogLevel(LogLevel.Information, string.format(formatString, ...))
end

function Logging.LogWarning (formatString, ...)
    Logging.LogLevel(LogLevel.Warning, string.format(formatString, ...))
end

function Logging.LogError (formatString, ...)
    Logging.LogLevel(LogLevel.Error, string.format(formatString, ...))
end

function Logging.LogFatal (formatString, ...)
    Logging.LogLevel(LogLevel.Fatal, string.format(formatString, ...))
end

--- func desc
---@param logLevel LoggingLevel
---@param ... any
function Logging.LogLevel(logLevel, ...)
    local show = Logging._minimalLevel <= Logging.AcceptLogLevel[logLevel]
    if (not show) then
        return
    end
    Logging.Log(string.format(" [%s] ", logLevel), ...)
end