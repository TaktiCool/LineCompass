#include "macros.hpp"
/*
    Line Compass

    Author: joko // Jonas

    Description:
    Remove a Position from the Compass

    Parameter(s):
    0: Marker ID <String>

    Returns:
    None
*/
params ["_id"];
GVAR(lineMarkerIDs) deleteAt (GVAR(lineMarkerIDs) find _id);
GVAR(lineMarkers) setVariable [_id, nil];
