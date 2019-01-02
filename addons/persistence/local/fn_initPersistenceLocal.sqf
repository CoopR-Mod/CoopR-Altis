#include "script_component.hpp"
/*
 * Author: xetra11
 *
 * This function will init the extDB3 local database
 *
 * Arguments:
 * 0: _dbName <STRING> - Name of Database config of extDB3 .ini file
 *
 * Example:
 * [Database] <- this
 * IP = 127.0.0.1
 * Port = 3306
 * Username = coopr
 * Password = coopr
 * Database = coopr_local
 *
 * Return Value:
 * None
 *
 * Example:
 * "Database" call coopr_fnc_initPersistenceLocal
 *
 * Public: No
 *
 * Scope: Server
 */

params[["_dbName", ""]];

if(isServer) then {
    if(_dbName isEqualTo "") exitWith { ERROR("_dbName was empty string") };

    INFO("initializing local persistence layer");
    private _protocolName = "coopr";
    private _createCharactersTable = "CREATE TABLE characters (
                                        id int NOT NULL AUTO_INCREMENT,
                                        character_0 TEXT,
                                        character_1 TEXT,
                                        character_2 TEXT,
                                        PRIMARY KEY (id));";

    private _createUsersTable = "CREATE TABLE users (
                                   steam_id varchar(255) NOT NULL,
                                   characters_id int,
                                   PRIMARY KEY (steam_id),
                                   FOREIGN KEY (characters_id) REFERENCES characters(id));";

    // test connection
    private _result = call compile ("extDB3" callExtension format["9:ADD_DATABASE:%1", _dbName]);
    private _returnCode = _result select 0;

    if(_returnCode isEqualTo 1) then {
        INFO("connection to database successful");
        _success = true;
    } else {
        ERROR("extDB3: error with database connection");
        _success = false;
    };

    // test connection with sql protocol
    _result = call compile ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:%1:SQL:%2", _dbName, _protocolName]);
    _returnCode = _result select 0;

    if(_returnCode isEqualTo 1) then {
        INFO("connection to database with protocol successful");
    } else {
        ERROR("extDB3: error creating users table. Maybe just an already existing table. Check extDB3 logs");
    };

    // init tables
    _createCharactersTable call coopr_fnc_extDB3sql;
    _createUsersTable call coopr_fnc_extDB3sql;
};