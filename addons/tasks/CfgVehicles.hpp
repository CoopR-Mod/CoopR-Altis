class CfgVehicles
{
    class Logic;
    class Module_F: Logic
    {
        class ArgumentsBaseUnits
        {
            class Default;
            class Combo; // Default combo box (i.e., drop-down menu)
            class ModuleDescription;
        };
        // Description base classes, for more information see below
        class ModuleDescription
        {
            class AnyBrain;
        };
    };
    class CoopR_TasksModule: Module_F
    {
        scope = 2;
        displayName = "CoopR Tasks";
        //icon = "\myTag_addonName\data\iconNuke_ca.paa"; // Map icon. Delete this entry to use the default icon
        category = "CoopR_Setup";
        function = "coopr_fnc_setupTasksModule"; // initially called
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        isDisposable = 1;
        is3DEN = 0;

        class Arguments {
        // every addon needs to define a logging level argument. If not the logging will not be enabled for this addon
              class Logging {
                  displayName = "Logging Level";
                  description = "The Logging level to use for this module";
                  typeName = "NUMBER";
                  class Values {
                      class opt_1 {name = "None"; value = 0;};
                      class opt_2 {name = "Info"; value = 1; default = 1;};
                      class opt_3 {name = "Debug"; value = 2;};
                  }
              }
              class TaskSystem {
                  displayName = "Task System";
                  description = "Chose the task system you want to use (CoopR, ALiVE)";
                  typeName = "NUMBER";
                  class Values {
                      class opt_1 {name = "CoopR"; value = 0;};
                      class opt_2 {name = "ALiVE"; value = 1;};
                      class opt_3 {name = "Disable"; value = 2; default = 2};
                  }
              }
              class TaskRequestItems {
                  displayName = "Task Request Item";
                  description = "The items where the task request action should be applied to (example: ['doc1', 'doc2'])";
                    typeName = "ARRAY";
              }
        }
        class ModuleDescription: ModuleDescription
        {
          description = "Sync this module with an AI unit to make it the CoopR intelligence unit";
        };
    };
};
