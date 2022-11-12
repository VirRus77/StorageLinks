--- Serialize table.
---@param val table
---@param name? any
---@param skipnewlines? any
---@param depth? any
function serializeTable (val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local indent = string.rep(" ", depth)
    local tmp = indent .. ""

    if name then
        tmp = tmp .. name .. " = "
    end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            local skip = (type(k) == "string" and k == "__index")
            if(not skip) then
                tmp =  tmp .. serializeTable (v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
            end
        end

        tmp = tmp .. indent .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    tmp = tmp .. " :" .. type(val)

    return tmp
end