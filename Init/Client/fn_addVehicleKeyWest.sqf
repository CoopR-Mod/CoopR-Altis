
#include "..\constants.hpp"

params ["_target", "_caller"];

_caller addItem "ACE_key_west";
_target commandChat localize "str.dpl.init.action.keys";

[format ["%1 has requested a vehicle key", name _caller], DEBUG_CTX, DEBUG_CFG] call CBA_fnc_debug;
