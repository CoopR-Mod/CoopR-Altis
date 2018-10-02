
#include "..\constants.hpp"

params ["_count"];

private _currentProgress = profileNamespace getVariable [KEY_INTEL_PROGRESS, 0];
private _progressAmount = _count * PROGRESS_PER_ITEM;
private _newProgress = _currentProgress + _progressAmount;

[format ["added %1 progress", _progressAmount],DEBUG_CTX, DEBUG_CFG] call CBA_fnc_debug;

profileNamespace setVariable [KEY_INTEL_PROGRESS, _newProgress];
saveProfileNamespace;
