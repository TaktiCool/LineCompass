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
if (side player == sideLogic && {player isKindOf "VirtualSpectator_F"}) exitWith {};
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

// Function to show the compass
FUNC(showCompass) = {
    // Reset the cache
    GVAR(lineAlphaCache) = GVAR(lineAlphaCache) apply {1};
    GVAR(bearingAlphaCache) = GVAR(bearingAlphaCache) apply {1};

    // Show the compass and make sure it is not shown if the map is open
    ([QGVAR(Compass)] call BIS_fnc_rscLayer) cutRsc [QGVAR(Compass), "PLAIN", 0, false];
};

FUNC(hideCompass) = {
    ([QGVAR(Compass)] call BIS_fnc_rscLayer) cutFadeOut 0;
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
