USING libMotOop;

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
        HmiPosGripperSx : LREAL := 430.0;
        HmiPosGripperDx : LREAL := 430.0;
        HmiMacchinaStati : INT;
        HmiPosPezzo : LREAL := 456.0;
    END_VAR

END_CONFIGURATION
