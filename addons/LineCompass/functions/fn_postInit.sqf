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
waitUntil {!isNull findDisplay 46};
call FUNC(showCompass);
// The draw3D event triggers on each frame if the client window has focus.
addMissionEventHandler ["Draw3D", {call FUNC(draw3D)}];
