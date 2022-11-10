--- Serialize table.
---@param val table
---@param name? any
---@param skipnewlines? any
---@param depth? any
function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then
        tmp = tmp .. name .. " = "
    end

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

--- Get count elements.
---@param tableValue table|any[]
function GetTableLength(tableValue)
    local count = 0
    if (tableValue == nil) then
        return count
    end
    for _ in pairs(tableValue) do
        count = count + 1
    end
    return count
end

--- Switch type exist object.
---@param oldName string # Old type.
---@param newName string # New type.
local function swapOldNameToNew(oldName, newName)
    local oldB = ModTiles.GetObjectsOfTypeInAreaUIDs(oldName, 0, 0, WORLD_LIMITS[1]-1, WORLD_LIMITS[2]-1)
    if oldB == nil or oldB == -1 or oldB[1] == nil or oldB[1] == -1 then
        return false
    end
    local props, newUID, rot
    for _, uid in ipairs(oldB) do
        props = ModObject.GetObjectProperties(uid) -- Properties [1]=Type, [2]=TileX, [3]=TileY, [4]=Rotation, [5]=Name,
        rot = ModBuilding.GetRotation(uid)
        if ModObject.DestroyObject(uid)	then
            newUID = ModBase.SpawnItem(newName, props[2], props[3], false, true, false)
            if newUID == -1 or newUID == nil then
                ModDebug.Log('Could not re-create the ', props[1], ' @ ', props[2], ':', props[3])
            else
                ModBuilding.SetRotation(newUID, rot)
                ModBuilding.SetBuildingNam(newUID, props[5])
            end

        end -- of if object destroyed
    end -- of oldB loop
end