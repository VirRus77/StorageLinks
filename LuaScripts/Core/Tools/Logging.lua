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

    Logging.ValidateSringFormat(formatString, table.unpack(cahngedParamsStringFormat))

    Logging.Log(string.format(" [%s] %s", logLevel, string.format(formatString, table.unpack(cahngedParamsStringFormat))))
end

--- func desc
---@param stringFormat string
---@param ... any
function Logging.ValidateSringFormat(stringFormat, ...)
    local findPatterns = StringFindPattern.new("%%.")
        :AfterFind(function (found) return string.sub(found, 2) end)
    local patterns = findPatterns:Find(stringFormat)
    local argsCount = select("#", ...)
    if (patterns == nil) then
        -- if (argsCount ~= 0 or argsCount ~= nil) then
        --     error(string.format("Error string format count arguments argsCount: %s \'%s\'", ToTypedString(argsCount), stringFormat), 666)
        -- end
        return
    end
    if (#patterns ~= argsCount) then
        error(string.format("Error string format count arguments patterns: %s argsCount: %s \'%s\'", ToTypedString(#patterns), ToTypedString(argsCount), stringFormat), 666)
    end

    for i = 1, argsCount, 1 do
        local value = select(i, ...)
        local type = type(value)
        if(patterns[i] == "s" and type ~= "string") then
            error("Error string format count arguments \'" .. stringFormat .. "\'", 666)
        elseif(patterns[i] == "d" and type ~= "number") then
            error("Error string format count arguments \'" .. stringFormat .. "\'", 666)
        elseif(patterns[i] == "f" and type ~= "number") then
            error("Error string format count arguments \'" .. stringFormat .. "\'", 666)
        end
    end
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