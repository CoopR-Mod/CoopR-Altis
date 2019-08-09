#include "script_component.hpp"
/*
 * Author: xetra11
 *
 * This function will return true if the given mission tracker has valid tracking values for a tracked mission.
 * This implies all situation like leaving a base, entering a target/mission destination area and leaving it etc.
 * Also this will check if the time delta between those time stamps is reasonable. If a mission is like 10 miles away
 * from the headquarters it is like impossible to have timestamp deltas less than a minute. The tracker should avoid
 * exploitation or cheating by teleporting etc.
 *
 * Arguments:
 * 0: _missionTracker <CBA_HASH> - tracker to evaluate
 *
 * Return Value:
 * Boolean - if mission tracking was valid
 *
 * Example:
 * [_traskTracker] call coopr_fnc_alive_checkMissionTracking;
 *
 * Public: No
 *
 * Scope: Server
 */

params [["_missionTracker", []]];

if (_missionTracker isEqualTo []) exitWith { ERROR("_missionTracker was objNull") };

if (isServer) then {
    DEBUG("mission tracker check:");
    private _valid = true;

    private _taskStart = [_taskTracker, COOPR_KEY_TASK_TRACKER_TASK_START] call CBA_fnc_hashGet;
    private _visitedTaskArea = [_taskTracker, COOPR_KEY_TASK_TRACKER_VISITED_TASK_AREA] call CBA_fnc_hashGet;

    if (_visitedTaskArea isEqualTo false) then {
        DEBUG("failed - was not in target area");
        [[COOPR_LOGO_SMALL], ["Tasks:", 1.3, COOPR_BRAND_COLOR], ["Squad did not visited the task area"]] call CBA_fnc_notify;
         _valid = false;
    };

    private _currentGameTime = call coopr_fnc_currentGameTime;
    private _missionTime = _currentGameTime - _taskStart;
    DEBUG2("mission time was %1", _missionTime);

    if (_missionTime < COOPR_TASK_MIN_TASK_TIME) then {
        DEBUG("failed - mission time was too short to be logical");
        [[COOPR_LOGO_SMALL], ["Tasks:", 1.3, COOPR_BRAND_COLOR], ["Squad returned too fast from mission"]] call CBA_fnc_notify;
        _valid = false;
    };

    _valid; // return value

} else {
    SERVER_ONLY_ERROR(__FILE__);
}

