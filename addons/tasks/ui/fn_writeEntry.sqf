#include "script_component.hpp"

private _ctrl = _this select 0;

private _typeSel = _ctrl getVariable ["_typeSelection", objNull];
private _strengthSel = _ctrl getVariable ["_strengthSelection", objNull];
private _behaviourSel = _ctrl getVariable ["_behaviourSelection", objNull];
private _markerNameEdit = _ctrl getVariable ["_markerNameEdit", objNull];

private _entryRemoveCombo = _ctrl getVariable ["_entryRemoveCombo", objNull];
private _entriesTextbox = _ctrl getVariable ["_entriesTextbox", objNull];
private _reconEntries = player getVariable [COOPR_KEY_RECON_ENTRIES, []];

if (_typeSel isEqualTo objNull) exitWith { ERROR("_typeSel was objNull") };
if (_strengthSel isEqualTo objNull) exitWith { ERROR("_strengthSel was objNull") };
if (_behaviourSel isEqualTo objNull) exitWith { ERROR("_behaviourSel was objNull") };
if (_markerNameEdit isEqualTo objNull) exitWith { ERROR("_markerNameEdit was objNull") };
if (_entriesTextbox isEqualTo objNull) exitWith { ERROR("_entriesTextbox was objNull") };
if (_entryRemoveCombo isEqualTo objNull) exitWith { ERROR("_entryRemoveCombo was objNull") };

// get select box values
private _type = _typeSel lbData (lbCurSel _typeSel);
private _strength = _strengthSel lbData (lbCurSel _strengthSel);
private _behaviour = _behaviourSel lbData (lbCurSel _behaviourSel);
private _markerText = ctrlText _markerNameEdit;
private _checkAreaMarker = [];

if (_markerText isEqualTo "") exitWith {
   [[COOPR_LOGO_SMALL], ["Recon Reports:", 1.3, COOPR_BRAND_COLOR], ["No marker name given"]] call CBA_fnc_notify;
};

switch (_behaviour) do {
    case COOPR_TASK_BEHAVIOUR_COMBAT: { [[COOPR_LOGO_SMALL], ["Recon Reports:", 1.3, COOPR_BRAND_COLOR], ["This behaviour type is not yet implemented"]] call CBA_fnc_notify };
    case COOPR_TASK_BEHAVIOUR_PATROL: { _checkAreaMarker = [_markerText] call coopr_fnc_createPatrolAreaMarker };
    case COOPR_TASK_BEHAVIOUR_DEFENSIVE: { _checkAreaMarker pushBack ([_markerText] call coopr_fnc_createDefensiveAreaMarker) };
};

if (count _checkAreaMarker isEqualTo 0) exitWith { DEBUG("no marker was created"); };

    private _reportAccuracy = [_markerPosition, _strength, _type, _behaviour] call coopr_fnc_validateReport;
// build hash for entry
private _entryHash = EMPTY_HASH;
[_entryHash, COOPR_KEY_RECON_ENTRY_TYPE, _type] call CBA_fnc_hashSet;
[_entryHash, COOPR_KEY_RECON_ENTRY_STRENGTH, _strength] call CBA_fnc_hashSet;
[_entryHash, COOPR_KEY_RECON_ENTRY_BEHAVIOUR, _behaviour] call CBA_fnc_hashSet;
[_entryHash, COOPR_KEY_RECON_ENTRY_MARKER, _checkAreaMarker] call CBA_fnc_hashSet;
[_entryHash, COOPR_KEY_RECON_ENTRY_TIME, call coopr_fnc_currentGameTime] call CBA_fnc_hashSet;
[_entryHash, COOPR_KEY_RECON_ENTRY_VALID, false] call CBA_fnc_hashSet;

_reconEntries pushBack _entryHash;
playSound "coopr_sound_pencil_draw";

// update remove combobox
lbClear _entryRemoveCombo;
{ _entryRemoveCombo lbAdd str (_forEachIndex + 1); _entryRemoveCombo lbSetData [_forEachIndex, str _forEachIndex] } forEach _reconEntries;

player setVariable [COOPR_KEY_RECON_ENTRIES, _reconEntries];

[_entriesTextbox, _reconEntries] call coopr_fnc_updateReconReportEntries;
