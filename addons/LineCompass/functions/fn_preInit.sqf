#include "macros.hpp"
/*
    Line Compass

    Author: NetFusion

    Description:
    Client init point of compass ui scripts.

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(lineMarkers) = createLocation ["fakeTown", [-2000, -2000, -2000], 0, 0];
GVAR(lineMarkerIDs) = [];

// Use pools to store the controls for the markers
GVAR(lineMarkerControlPool) = [];
GVAR(iconMarkerControlPool) = [];

// Caches for alpha values
GVAR(lineAlphaCache) = [];
GVAR(lineAlphaCache) resize 109;
GVAR(bearingAlphaCache) = [];
GVAR(bearingAlphaCache) resize 37;

// Function to determine alpha value dependent on position
// Parameter: xPosition <Number>
// Return: alphaValue <Number>
FUNC(getAlphaFromX) = {
    (3 - (abs (_this - 92.5) / 30)) max 0
};

GVAR(CompassShown) = false;

// Function to show the compass
FUNC(showCompass) = {
    // Reset the cache
    GVAR(lineAlphaCache) = GVAR(lineAlphaCache) apply {1};
    GVAR(bearingAlphaCache) = GVAR(bearingAlphaCache) apply {1};
    GVAR(CompassShown) = true;
    // Show the compass and make sure it is not shown if the map is open
    ([QGVAR(Compass)] call BIS_fnc_rscLayer) cutRsc [QGVAR(Compass), "PLAIN", 0, false];
};

FUNC(hideCompass) = {
    ([QGVAR(Compass)] call BIS_fnc_rscLayer) cutFadeOut 0;
    GVAR(CompassShown) = false;
};

GVAR(nearUnitsCache) = [0, []];
FUNC(getNearUnits) = {
    params [
        ["_postion", [0, 0, 0], [[], objNull], [2, 3]],
        ["_radius", 0, [0]]
    ];
    if ((GVAR(nearUnitsCache) select 0) - time >= 2) then {
        GVAR(nearUnitsCache) select 1;
    } else {
        private _nearObjects = _postion nearObjects _radius;

        private _return = _nearObjects select {
            _x isKindOf "CAManBase"
        };

        private _vehicles = _nearObjects select {
            _x isKindOf "Car"
            || { _x isKindOf "Air" }
            || { _x isKindOf "Motorcycle" }
            || { _x isKindOf "StaticWeapon" }
            || { _x isKindOf "Tank" }
            || { _x isKindOf "Ship" }
        };

        {
            _return append (crew _x);
            nil
        } count _vehicles;
        GVAR(nearUnitsCache) = [time, _return];
        _return
    };
};

GVAR(customWaypointPosition) = customWaypointPosition;

if (isNil QGVAR(UnitDistance)) then {
    GVAR(UnitDistance) = 31;
};

GVAR(GroupColor) = [0, 0.87, 0, 1];
GVAR(SideColor) = [0, 0.4, 0.8, 1];
GVAR(WaypointColor) = [0.9, 0.66, 0.01, 1];
GVAR(CompassAvailableShown) = false;
GVAR(DrawBearing) = 2;
[] spawn {
    if (isClass (configFile >> "CfgPatches" >> "CBA_Settings")) then {
        [QGVAR(CompassAvailableShown),  "CHECKBOX", "Show Only When Compass is Available", "Line Compass", GVAR(CompassAvailableShown), 1, {}, true] call CBA_fnc_addSetting;
        [QGVAR(GroupColor), "COLOR", "Group Color", "Line Compass", GVAR(GroupColor)] call CBA_fnc_addSetting;
        [QGVAR(SideColor), "COLOR", "Side Color", "Line Compass", GVAR(SideColor)] call CBA_fnc_addSetting;
        [QGVAR(WaypointColor), "COLOR", "Waypoint Color", "Line Compass", GVAR(WaypointColor), nil, {
            params ["_value"];
            if !(customWaypointPosition isEqualTo []) then {
                ["MOVE", _value, customWaypointPosition] call FUNC(addLineMarker);
            };
        }] call CBA_fnc_addSetting;
        [QGVAR(DrawBearing), "LIST", "Directions Drawn", "Line Compass", [[0, 1, 2], ["None", "Bearing", "All"], 2]] call CBA_fnc_addSetting;

        GVAR(fingerTime) = time;
        ["ace_finger_fingered", {
            params ["_player", "_pos", "_dir"];
            ["Fingering", GVAR(WaypointColor), _pos] call FUNC(addLineMarker);
            GVAR(fingerTime) = time + 2.5;
        }] call CBA_fnc_addEventhandler;
    };
};
