USING libmOTOop;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#50ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
    VAR_GLOBAL
        start : BOOL;
        stop : BOOL;
        tavolaRotante : AxisClass;
        braccioSx : ArmClass;
        braccioDx : ArmClass;
        fineCiclo : BOOL;
        nrCicli : INT;
        HmiPosGripperSx : LREAL;
        HmiPosGripperDx : LREAL;
        HmiMacchinaStati : INT;
    END_VAR

END_CONFIGURATION
