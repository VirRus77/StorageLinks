Logging.SetMinimalLevel(LogLevel.Trace)

VERSION_WITH_CLASSMETHODCHECK_FUNCTION = "137.15" -- dev version. Update before uploading to steam!!

--  -- Internal Databases
--  ---@alias OBJECTS_IN_FLIGHT_Item { arch :boolean, wobble :boolean, storageUID :integer, onFlightComplete :fun( id :integer, objectInFlight :OBJECTS_IN_FLIGHT_Item) }
--  ---@type OBJECTS_IN_FLIGHT_Item[] #
--  OBJECTS_IN_FLIGHT = {}

---@type FireWall
FIRE_WALL = FireWall.new()
---@type VirtualNetwor
VIRTUAL_NETWORK = VirtualNetwor.new(FIRE_WALL)
---@type FlightObjectsList #
OBJECTS_IN_FLIGHT = FlightObjectsList.new()
---@type TimersStack
TIMERS_STACK = TimersStack.new()
---@type BuildingController
BUILDING_CONTROLLER = BuildingController.new(TIMERS_STACK)

HASH_TABLES = {
    --- HashTable Durability
    ---@type table<string, integer>
    Durability = { },
    --- HashTable Fuel
    ---@type table<string, integer>
    Fuel = { },
    --- HashTable Water
    ---@type table<string, integer>
    Water = { },
}


----- LEGACY -----

-- Static
FRAMES_BETWEEN_CHECK = 10
LAST_TIME_DELTA = 0


SWITCHES_TURNED_OFF = {} -- key = '>some name'. use pairs().

-- Internal Caching
---@alias LINK_UIDS_Item { bType :string, tileX :integer, tileY :integer, rotation: integer, name :string, linkUID? :integer, storageUIDs? :integer[], buildingLevel :BuildingLevels, connectToXY :integer[], storageUID? :integer, area :{ left :integer, top :integer, right :integer, bottom :integer } }
---@type LINK_UIDS_Item[] #
LINK_UIDS = {}
---@alias STORAGE_UIDS_Item { bType :string, tileX :integer, tileY :integer, rotation :integer, name :string, sType :string, linkUIDs? :integer[], linkUID? :integer }
---@type STORAGE_UIDS_Item[]
STORAGE_UIDS = {}



--- func desc
---@param buildingLevel BuildingLevels #
---@return Timer[] # 
---@obsolete
function MakeTimers (buildingLevel)
    local checkPeriod = 1
    if(buildingLevel == BuildingLevels.Crude) then
        checkPeriod = 5
    end
    if(buildingLevel == BuildingLevels.Good) then
        checkPeriod = 1
    end
    if(buildingLevel == BuildingLevels.Super) then
        checkPeriod = 1
    end

    return {
        -- Crude
        -- Timer.new(checkPeriod, function () locateSwitches (buildingLevel) end),
        -- Timer.new(checkPeriod, function () locatePumps (buildingLevel) end,                    Timer.MillisecondsToSeconds(150)),
        -- Timer.new(checkPeriod, function () locateOverflowPumps (buildingLevel) end,            Timer.MillisecondsToSeconds(300)),
        -- Timer.new(checkPeriod, function () locateBalancers (buildingLevel) end,                Timer.MillisecondsToSeconds(450)),
        -- Timer.new(checkPeriod, function () locateReceiversAndTransmitters (buildingLevel) end, Timer.MillisecondsToSeconds(600)),
        -- Timer.new(checkPeriod, function () fireAllMagnets (buildingLevel) end,                 Timer.MillisecondsToSeconds(750)),
    }
end

-- Variables that can change
FRAME_COUNTER = 0
---@obsolete
DEBUG_ENABLED = false
USE_EVENT_STYLE = false