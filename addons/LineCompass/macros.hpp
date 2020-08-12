#define PREFIX LineCompass

#define QUOTE(var) #var
#define DOUBLE(var1,var2) var1##_##var2
#define TRIPLE(var1,var2,var3) DOUBLE(var1,DOUBLE(var2,var3))

#define GVAR(var) DOUBLE(PREFIX,var)
#define QGVAR(var) QUOTE(GVAR(var))

#define FUNC(var) TRIPLE(PREFIX,fnc,var)

// UI Based Macros
#define PYN 108
#define PX(X) ((X)/PYN*safeZoneH/(4/3))
#define PY(Y) ((Y)/PYN*safeZoneH)
