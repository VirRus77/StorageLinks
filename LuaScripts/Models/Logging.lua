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
    ---@type LoggingLevel #
    MinimalLevel = LogLevel.Information,

    --- List show log levels.
    ---@type LoggingLevel[]
    AcceptLogLevel = { 
        LogLevel.Information,
        LogLevel.Warning,
        LogLevel.Error,
        LogLevel.Fatal
    }
}

--- Set minimal level write log.
---@param logLevel LoggingLevel #
function Logging.SetMinimalLevel (logLevel)
    Logging.MinimalLevel = logLevel
    Logging.AcceptLogLevel = {}
    local append = false
    for _, value in ipairs(LogLevel) do
        append = append or (value == logLevel)
        if  (append) then
            table.insert (Logging.AcceptLogLevel, value)
        end
    end
end

--- func desc
---@param ... any
function Logging.Log(...)
    ModDebug.Log(os.date("%d.%m.%Y %X"), ...)
end

function Logging.LogTrace (...)
    Logging.LogLevel(LogLevel.Trace, ...)
end

function Logging.LogDebug (...)
    Logging.LogLevel(LogLevel.Debug, ...)
end

--- 
---@param formatString string
---@param ... any
function Logging.LogDebugFormat (formatString, ...)
    Logging.LogLevel(LogLevel.Debug, string.format(formatString, ...))
end

function Logging.LogInformation (...)
    Logging.LogLevel(LogLevel.Information, ...)
end

function Logging.LogWarning (...)
    Logging.LogLevel(LogLevel.Warning, ...)
end

function Logging.LogError (...)
    Logging.LogLevel(LogLevel.Error, ...)
end

function Logging.LogFatal (...)
    Logging.LogLevel(LogLevel.Fatal, ...)
end

--- func desc
---@param logLevel LoggingLevel
---@param ... any
function Logging.LogLevel(logLevel, ...)
    local show = Logging.MinimalLevel == logLevel
    if (not show) then
        for _, value in ipairs(Logging.AcceptLogLevel) do
            show = show or (logLevel == value)
            if (show) then
                break
            end
        end
    end

    if (not show) then
        return
    end

    Logging.Log(" ["..logLevel.."] ", ...)
end