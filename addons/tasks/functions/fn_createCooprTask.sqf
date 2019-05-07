#include "script_component.hpp"
/*
 * Author: xetra11
 *
 * Creates a CoopR task that is applied to the whole group of a given unit
 *
 * Arguments:
 * 0: _unit <OBJECT> - unit this task is assigned to
 * 1: _cooprTaskInfo <ARRAY/CBA_HASH> - coopr task containing all infos needed to create a task
 *
 * Return Value:
 * Boolean - if task was created successfully
 *
 * Example:
 * [_unit, _cooprTaskInfo] call coopr_fnc_createCooprTask;
 *
 * Public: No
 *
 * Scope: Server
 */

params [["_unit", objNull],
        ["_cooprTaskInfo", []]];

if (_unit isEqualTo objNull) exitWith { ERROR("_unit was objNull") };
if (_cooprTaskInfo isEqualTo []) exitWith { ERROR("_cooprTaskInfo was []") };

if (isServer) then {
    private _taskType = [_cooprTaskInfo, COOPR_KEY_TASK_TYPE] call CBA_fnc_hashGet;
    private _description = [_cooprTaskInfo, COOPR_KEY_TASK_DESCRIPTION] call CBA_fnc_hashGet;
    private _serializedMarkers = [_cooprTaskInfo, COOPR_KEY_TASK_MARKER] call CBA_fnc_hashGet;
    DEBUG3("assigning %1 to unit %2", _taskType, _unit);
    private _taskCount = [COOPR_COUNTER_TASKS, _taskType] call CBA_fnc_hashGet;
    private _taskId = format ["%1_%2", _taskType, _taskCount];
    private _cooprTaskId = [_unit, _taskId , _taskType, objNull, 1, 2, true] call BIS_fnc_taskCreate;

    if !(isNil "_cooprTaskId") then {
        [_unit, _taskType] call coopr_fnc_initTaskTracker;
        DEBUG2("%1 assigned", _cooprTaskId);
        [_taskType] call coopr_fnc_countTask;
        // TODO: need to be shifted to group/squads
        _unit setVariable [COOPR_KEY_ACTIVE_TASK, _taskId, true];
        private _newMarkerName = _taskId + "_recon" + "_marker_";
        { [_x, _newMarkerName + (str _forEachIndex)] call coopr_fnc_deserializeMarker } forEach _serializedMarkers;
        // get the position of the first marker of the task
        private _deserializedMarkerPos = getMarkerPos (_newMarkerName + "0");
        [_deserializedMarkerPos, _taskId, "INVISIBLE"] call coopr_fnc_createTaskMarker;
        _cooprTaskId;
    } else {
        ERROR("could not assign task.");
        false;
    };

} else {
    SERVER_ONLY_ERROR;
};
