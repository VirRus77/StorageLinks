--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


StringFormat = { }

--- func desc
---@param stringFormat string
---@param ... any
---@return string
function StringFormat.UnpackStringFormat(stringFormat, ...)
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

    local error = StringFormat.ValidateSringFormat(stringFormat, table.unpack(cahngedParamsStringFormat))
    if (error ~= nil) then
        return error
    end

    return string.format(stringFormat, table.unpack(cahngedParamsStringFormat))
end

--- func desc
---@param stringFormat string
---@param ... any
---@return string|nil
function StringFormat.ValidateSringFormat(stringFormat, ...)
    local findPatterns = StringFindPattern.new("%%.")
        :AfterFind(function (found) return string.sub(found, 2) end)
    local patterns = findPatterns:Find(stringFormat)
    local argsCount = select("#", ...)
    if (patterns == nil) then
        -- if (argsCount ~= 0 or argsCount ~= nil) then
        --     error(string.format("Error string format count arguments argsCount: %s \'%s\'", ToTypedString(argsCount), stringFormat), 666)
        -- end
        return nil
    end
    if (#patterns ~= argsCount) then
        return string.format("Error string format count arguments patterns: %s argsCount: %s \'%s\'", ToTypedString(#patterns), ToTypedString(argsCount), stringFormat)
    end

    for i = 1, argsCount, 1 do
        local value = select(i, ...)
        local type = type(value)
        if(patterns[i] == "s" and type ~= "string") then
            return string.format("Error string format. %d[%%s] have type(%s)", i, type) .. " argument \'" .. stringFormat .. "\'"
        elseif(patterns[i] == "d" and type ~= "number") then
            return string.format("Error number format. %d[%%d] have type(%s)", i, type) .. " argument \'" .. stringFormat .. "\'"
        elseif(patterns[i] == "f" and type ~= "number") then
            return string.format("Error number format. %d[%%f] have type(%s)", i, type) .. " argument \'" .. stringFormat .. "\'"
        end
    end
    return nil
end