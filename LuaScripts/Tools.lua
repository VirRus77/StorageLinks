function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
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

-- http://lua-users.org/wiki/TableSerialization
--function table_print (tt, indent, done)
--    done = done or {}
--    indent = indent or 0
--    if type(tt) == "table" then
--      local sb = {}
--      for key, value in pairs (tt) do
--        table.insert(sb, string.rep (" ", indent)) -- indent it
--        if type (value) == "table" and not done [value] then
--          done [value] = true
--          table.insert(sb, key .. " = {\n");
--          table.insert(sb, table_print (value, indent + 2, done))
--          table.insert(sb, string.rep (" ", indent)) -- indent it
--          table.insert(sb, "}\n");
--        elseif "number" == type(key) then
--          table.insert(sb, string.format("\"%s\"\n", tostring(value)))
--        else
--          table.insert(sb, string.format(
--              "%s = \"%s\"\n", tostring (key), tostring(value)))
--         end
--      end
--      return table.concat(sb)
--    else
--      return tt .. "\n"
--    end
--  end
--
--  function to_string( tbl )
--      if  "nil"       == type( tbl ) then
--          return tostring(nil)
--      elseif  "table" == type( tbl ) then
--          return table_print(tbl)
--      elseif  "string" == type( tbl ) then
--          return tbl
--      else
--          return tostring(tbl)
--      end
--  end