#include "script_component.hpp"

if(player getVariable [COOPR_KEY_STATE, COOPR_STATE_OK] isEqualTo COOPR_STATE_OK) then {
    call coopr_fnc_wounded;
    [EXEC_SERVER, "coopr_fnc_updateCharacter", [player call coopr_fnc_serializeCoopR], //request-related
        [], {
        sleep 5;
        call coopr_fnc_spawnInLobby;
        createDialog COOPR_LOGIN_NEW;
        call coopr_fnc_showLoginDialog;
        }
    ] call Promise_Create;
}
