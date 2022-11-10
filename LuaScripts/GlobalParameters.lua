-- Static
FRAMES_BETWEEN_CHECK = 10
LAST_TIME_DELTA = 0
WORLD_LIMITS = {1, 1}
VERSION_WITH_CLASSMETHODCHECK_FUNCTION = "137.15" -- dev version. Update before uploading to steam!!

-- Internal Databases
OBJECTS_IN_FLIGHT = {}
SWITCHES_TURNED_OFF = {} -- key = '>some name'. use pairs().
TIMEOUT_DB = {}

-- Internal Caching
LINK_UIDS = {}
STORAGE_UIDS = {}

-- Multiple Types
BALANCER_TYPES = {
    'Balancer (SL)',
    'Balancer Long (SL)'
}
PUMP_TYPES = {
    'Pump (SL)',
    'Pump Long (SL)'
}
OVERFLOW_TYPES = {
    'Overflow Pump (SL)',
    'Overflow Pump Long (SL)'
}
RECEIVER_TYPES = {
    'Receiver (SL)'
}
TRANSMITTER_TYPES = {
    'Transmitter (SL)'
}

-- Unlock a level when this is built
GOOD_UNLOCK_BUILDINGS = {
    'MortarMixerCrude',
    'MortarMixerGood'
}
SUPER_UNLOCK_BUILDINGS = {
    'MetalWorkbench'
}
SECONDS_BETWEEN_UNLOCK_CHECKS = 5
UNLOCK_TIMER_SECOND = 0

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