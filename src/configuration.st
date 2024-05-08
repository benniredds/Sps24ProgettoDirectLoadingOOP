// USING udt;
// CONFIGURATION MyConfiguration
//     TASK Main(Interval := T#300ms, Priority := 1);
//     PROGRAM P1 WITH Main: MyProgram;

//     {S7.extern=ReadWrite}
//     {OpcUa=ReadWrite}
//     VAR_GLOBAL
//         start : BOOL;
//         tavolaRotante : interfacciaTavola;
//         braccioSx : interfacciaAsse;
//         braccioDx : interfacciaAsse;
//         fineCiclo : BOOL;
//     END_VAR

// END_CONFIGURATION

USING libUdtOop;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#300ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram2;

    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
    VAR_GLOBAL
        start : BOOL;
        tavolaRotante : axisInterface;
        braccioSx : axisInterface;
        braccioDx : axisInterface;
        fineCiclo : BOOL;
    END_VAR

END_CONFIGURATION
