-- Static
FRAMES_BETWEEN_CHECK = 10
LAST_TIME_DELTA = 0

VERSION_WITH_CLASSMETHODCHECK_FUNCTION = "137.15" -- dev version. Update before uploading to steam!!

-- Internal Databases
OBJECTS_IN_FLIGHT = {}
SWITCHES_TURNED_OFF = {} -- key = '>some name'. use pairs().
TIMEOUT_DB = {}

-- Internal Caching
LINK_UIDS = {}
STORAGE_UIDS = {}

-- Levels of speed
CRUDE_CHECKS_PER_SECOND = 0.25
GOOD_CHECKS_PER_SECOND = 1
SUPER_CHECKS_PER_SECOND = 1 -- but we transfer way more per check!

-- Tracking timers (these change with each OnUpdate() call)
CRUDE_TIMER_SECOND = 0
GOOD_TIMER_SECOND = 0
SUPER_TIMER_SECOND = 0
FIVE_SECOND_TIMER = 0


-- Variables that can change
FRAME_COUNTER = 0
DEBUG_ENABLED = false
USE_EVENT_STYLE = false