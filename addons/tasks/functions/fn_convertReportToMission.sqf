#include "script_component.hpp"
/*
 * Author: xetra11
 *
 * Converts all recon reports to a CoopR mission.

 * Arguments:
 * 0: _reconEntries <ARRAY> - All recon entries given by a unit/player
 *
 * Return Value:
 * None
 *
 * Example:
 * Trivial
 *
 * Public: No
 *
 * Scope: Server
 */
params [["_reconEntries", []]];

if (_reconEntries isEqualTo []) exitWith { ERROR("_reconEntries was not defined") };

if (isServer) then {
    DEBUG2("recon entries to be converted: %1", count _reconEntries);
    private _reportID = (player getVariable [COOPR_KEY_CHARACTER_ID, -1]) call coopr_fnc_getReportIdForCharacterLocal;
    private _scannedStrengths = [_reportID] call coopr_fnc_getReconAreaActivity;

    {
        DEBUG("parsing recon reports");
        private _entry = _x;
        private _owner = [_entry, COOPR_KEY_RECON_ENTRY_OWNER] call CBA_fnc_hashGet;
        private _type = [_entry, COOPR_KEY_RECON_ENTRY_TYPE] call CBA_fnc_hashGet;
        private _strength = [_entry, COOPR_KEY_RECON_ENTRY_STRENGTH] call CBA_fnc_hashGet;
        private _behaviour = [_entry, COOPR_KEY_RECON_ENTRY_BEHAVIOUR] call CBA_fnc_hashGet;
        private _serializedMarkers = [_entry, COOPR_KEY_RECON_ENTRY_MARKER] call CBA_fnc_hashGet;
        private _time = [_entry, COOPR_KEY_RECON_ENTRY_TIME] call CBA_fnc_hashGet;


        { deleteMarker (_x select 0) } forEach _serializedMarkers;

        private _strengthListForType = [_scannedStrengths, _type] call CBA_fnc_hashGet;
        DEBUG2("strengthlist (before): %1", _strengthListForType);
        private _isValid = [_type, _strength, _strengthListForType] call coopr_fnc_validateReportEntry;
        //TODO: private _accuracy = code ...

        private _newCooprTask = EMPTY_HASH;

        if (_isValid) then {
            // remove element to shrink down strength list for upcoming validations
            _strengthListForType deleteAt (_strengthListForType find _strength);
            DEBUG2("strengthlist (after): %1", _strengthListForType);

            private _cooprTaskType = [_strength, _type, _behaviour] call coopr_fnc_determineTaskType;
            DEBUG2("evaluated task type: %1", _cooprTaskType);
            DEBUG("building coopr task hash");
            [_newCooprTask, COOPR_KEY_TASK_TYPE, _cooprTaskType] call CBA_fnc_hashSet;
            [_newCooprTask, COOPR_KEY_TASK_DESCRIPTION, ""] call CBA_fnc_hashSet; // inactive
            [_newCooprTask, COOPR_KEY_TASK_REPORT_TIME, _time] call CBA_fnc_hashSet;
            [_newCooprTask, COOPR_KEY_TASK_MARKER, _serializedMarkers] call CBA_fnc_hashSet;
            [_newCooprTask, COOPR_KEY_TASK_ACCURACY, 100] call CBA_fnc_hashSet;

            DEBUG2("defined task details: %1", _newCooprTask);
            [_newCooprTask] call coopr_fnc_pushTaskQueue;
            DEBUG2("coopr mission created");
        } else {
            INFO("skipping convertion - recon report entry was not valid ");
        }
    } forEach _reconEntries;

} else {
    SERVER_ONLY_ERROR;
};
