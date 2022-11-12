--- func desc
---@param propName "storageUID" #
---@param propValue any #
---@return OBJECTS_IN_FLIGHT_Item[]
function listInFlightWithProp(propName, propValue)

    local listOfReturns = {}

    for id, objectInFlight in pairs(OBJECTS_IN_FLIGHT)
    do
        if objectInFlight[propName] ~= nil and objectInFlight[propName] == propValue then
            --listOfReturns[#listOfReturns + 1] = ob
            table.insert(listOfReturns, objectInFlight)
        end
    end
    return listOfReturns

    -- for UID, objectInFlight in pairs(OBJECTS_IN_FLIGHT)
    -- do
    --     if objectInFlight[propName] ~= nil and objectInFlight[propName] == propValue then
    --         --listOfReturns[#listOfReturns + 1] = UID
    --         table.insert(listOfReturns, UID)
    --     end
    -- end
-- 
    -- return listOfReturns
end