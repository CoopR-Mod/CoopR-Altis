#include "script_component.hpp"

class CfgPatches {
    class coopr_init
    {
        // Meta information for editor
        name = "CoopR Mod";
        author = "xetra11";
        url = "https://github.com/CoopR-Mod/CoopR-Altis";

        requiredVersion = 1.80;
        requiredAddons[] = {
            "coopr_core",
        };
        // List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content unlocking.
        units[] = {
            "CoopR_ModuleSetupCommander"
        };
        // List of weapons (CfgWeapons classes) contained in the addon.
        weapons[] = {};
    };
}

#include "CfgFunctions.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
