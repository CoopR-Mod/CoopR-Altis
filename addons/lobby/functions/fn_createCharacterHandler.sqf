#include "script_component.hpp"

LSTART("CREATE CHAR");
private _ctrl = _this select 0;
private _nameTextEdit = _ctrl getVariable ["_nameTextEdit", objNull];
private _infoText = _ctrl getVariable ["_infoText", objNull];
private _specCombobox = _ctrl getVariable ["_specCombobox", objNull];
private _classesHash = _ctrl getVariable ["_classesHash", objNull];
private _slot = _ctrl getVariable ["_slot", -1];

private _uid = getPlayerUID player;
private _name = ctrlText _nameTextEdit;
private _index = lbCurSel _specCombobox;
private _className = _specCombobox lbText _index;
private _classId = [_classesHash, _className] call CBA_fnc_hashGet;
private _loadOut = _classId call coopr_fnc_getLoadoutForClass;

FFLOG("creating new profile for %1 at slot %1", _uid, _slot);

private _character = [_uid, _slot, _name, _classId, 0, 500, false, 0] call coopr_fnc_createCharacterState;
[_character, KEY_LOADOUT, _loadOut] call CBA_fnc_hashSet;

if(_name == "" or _className == "") exitWith {
    _infoText ctrlSetStructuredText parseText format["<t size='1' color='#ff0000'>%1</t>", localize "str.coopr.profiles.validator"];
};

[SERVER, "coopr_fnc_updateCharacter", [_uid, _character, _slot], //request-related
    [_pairs], {
        params ["_args", "_result"];
        closeDialog 1;
        LEND("CREATE CHAR");
    }
] call Promise_Create;
