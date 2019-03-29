#include "script_component.hpp"

if (INTEGRATE_ACE3) then {
    call coopr_fnc_ace3_addCharacterActions;
} else {
    private _hasReconEntries = (count (player getVariable [COOPR_KEY_RECON_ENTRIES, []])) > 0;
    _broadcastActionCondition = { _hasReconEntries };
    _reconReportActionCondition = { [player] call coopr_fnc_hasActiveTask };

    player addAction [localize "str.coopr.core.action.rep", { player call coopr_fnc_showReputation; } , [], 0.5, true, true, "", "true"];
    player addAction [localize "str.coopr.core.action.reports", { call coopr_fnc_initReconRepDialog; } , [], 0.5, true, true, "", _reconReportActionCondition call coopr_fnc_codeAsString];
    player addAction [localize "str.coopr.core.action.broadcast", { player call coopr_fnc_broadcastReconReports; } , [], 0.5, true, true, "", _broadcastActionCondition call coopr_fnc_codeAsString];
    player addAction ["<t color='#ff0000'>Logout</t>", {[] spawn { call coopr_fnc_logout; };} , [], 0.5, true, true, "", "true"];
};

INFO("player actions added");
