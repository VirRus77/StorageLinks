Logging.SetMinimalLevel(LogLevel.Error)

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
BUILDING_CONTROLLER = BuildingController.new(TIMERS_STACK, FIRE_WALL)

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
