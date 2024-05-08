USING libmOTOop;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#300ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
    VAR_GLOBAL
        start : BOOL;
        tavolaRotante : AxisClass;
        braccioSx : ArmClass;
        braccioDx : ArmClass;
        fineCiclo : BOOL;
        nrCicli : INT;
    END_VAR

END_CONFIGURATION
