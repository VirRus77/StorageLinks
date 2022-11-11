-- Static
FRAMES_BETWEEN_CHECK = 10
LAST_TIME_DELTA = 0

VERSION_WITH_CLASSMETHODCHECK_FUNCTION = "137.15" -- dev version. Update before uploading to steam!!

-- Internal Databases
OBJECTS_IN_FLIGHT = {}
SWITCHES_TURNED_OFF = {} -- key = '>some name'. use pairs().

-- Internal Caching
LINK_UIDS = {}
STORAGE_UIDS = {}

--- func desc
---@param buildingLevel BuildingLevels #
---@return Timer[] # 
function MakeTimers (buildingLevel)
    local checkPeriod = 1
    if(buildingLevel == BuildingLevels.Crude) then
        checkPeriod = 1 / 4
    end

    return {
        -- Crude
        Timer.new(checkPeriod, function () locateSwitches (buildingLevel) end),
        Timer.new(checkPeriod, function () locatePumps (buildingLevel) end,                    Timer.MillisecondsToSeconds(150)),
        Timer.new(checkPeriod, function () locateOverflowPumps (buildingLevel) end,            Timer.MillisecondsToSeconds(300)),
        Timer.new(checkPeriod, function () locateBalancers (buildingLevel) end,                Timer.MillisecondsToSeconds(450)),
        Timer.new(checkPeriod, function () locateReceiversAndTransmitters (buildingLevel) end, Timer.MillisecondsToSeconds(600)),
        Timer.new(checkPeriod, function () fireAllMagnets (buildingLevel) end,                 Timer.MillisecondsToSeconds(750)),
    }
end

-- Variables that can change
FRAME_COUNTER = 0
DEBUG_ENABLED = false
USE_EVENT_STYLE = false