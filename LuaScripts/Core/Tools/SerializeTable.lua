--- Serialize table.
---@param val table
---@param name? any
---@param skipnewlines? any
---@param depth? any
---@param parentTables? table<table, boolean>
function SerializeTable (val, name, skipnewlines, depth, parentTables)
    -- ModDebug.Log("serializeTable")
    skipnewlines = skipnewlines or false
    depth = depth or 0
    parentTables = parentTables or { }

    local indent = string.rep(" ", depth)
    local tmp = indent .. ""

    if name then
        tmp = tmp .. name .. " = "
    end

    local typeValue = type(val)
    if (typeValue == "table") then
        if (parentTables[val] ~= nil) then
            tmp = tmp .. "--== RECURSIVE ==--"
            return tmp
        end

        parentTables[val] = true
        -- ModDebug.Log("serializeTable table")
        -- Add table Id
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            local skip = (type(k) == "string" and k == "__index")
            if (not skip) then
                tmp =  tmp .. SerializeTable (v, k, skipnewlines, depth + 1, parentTables) .. "," .. (not skipnewlines and "\n" or "")
            end
        end
        parentTables[val] = nil

        tmp = tmp .. indent .. "}"
        -- If exist __tostring, don`t get refernece.
        -- tmp = tmp .. "[" .. tostring(val) .. "]" .. " "
    elseif (typeValue == "number") then
        -- ModDebug.Log("serializeTable number")
        tmp = tmp .. tostring(val)
    elseif (typeValue == "string") then
        -- ModDebug.Log("serializeTable string")
        tmp = tmp .. string.format("%q", val)
    elseif (typeValue == "boolean") then
        -- ModDebug.Log("serializeTable boolean")
        tmp = tmp .. (val and "true" or "false")
    elseif (typeValue == "nil") then
        -- ModDebug.Log("serializeTable boolean")
        tmp = tmp .. "nil"
    else
        -- ModDebug.Log("serializeTable inserializeable")
        tmp = tmp .. "\"[inserializeable datatype:" .. typeValue .. "]\""
    end

    tmp = tmp .. " :" .. typeValue

    return tmp
end