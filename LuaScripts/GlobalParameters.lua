Logging.SetMinimalLevel(LogLevel.Warning)

VERSION_WITH_CLASSMETHODCHECK_FUNCTION = "137.15" -- dev version. Update before uploading to steam!!

--  -- Internal Databases
--  ---@alias OBJECTS_IN_FLIGHT_Item { arch :boolean, wobble :boolean, storageUID :integer, onFlightComplete :fun( id :integer, objectInFlight :OBJECTS_IN_FLIGHT_Item) }
--  ---@type OBJECTS_IN_FLIGHT_Item[] #
--  OBJECTS_IN_FLIGHT = {}


---@type boolean
BUILDINGS_INITIALIZED = false
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
---@type WorldLimits
WORLD_LIMITS = WorldLimits.new()

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
function HASH_TABLES:Clear()
    --- HashTable Durability
    ---@type table<string, integer>
    self.Durability = { }

    --- HashTable Fuel
    ---@type table<string, integer>
    self.Fuel = { }

    --- HashTable Water
    ---@type table<string, integer>
    self.Water = { }
end
