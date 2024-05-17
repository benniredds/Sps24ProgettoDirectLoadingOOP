USING libMotOop;
USING libUdtOop;
USING Siemens.Simatic.S71500.MotionControl.Native;

PROGRAM MyProgram
    VAR_EXTERNAL
        start : BOOL;
        stop : BOOL;
        tavolaRotante : AxisClass;
        braccioDx : ArmClass;
        braccioSx : ArmClass;
        fineCiclo : BOOL;
        nrCicli : INT;
        HmiPosGripperSx : LREAL;
        HmiPosGripperDx : LREAL;
        HmiMacchinaStati : INT;
    END_VAR
        
    VAR
        instControllore : controlloreCentrale;
    END_VAR

    VAR CONSTANT
        posAxisLeftDB  : UINT := UINT#3;
        posAxisRightDB  : UINT := UINT#6;
        posAxisRotDB  : UINT := UINT#16;
    END_VAR


    instControllore(start := start,
                    stop := stop,
                    posAxisRot := posAxisRotDB,
                    posAxisRight := posAxisRightDB,
                    posAxisLeft := posAxisLeftDB,
                    asseRot := tavolaRotante,
                    asseDx := braccioDx,
                    asseSx := braccioSx,
                    cicloAutomatico => fineCiclo,
                    numeroCicli => nrCicli,
                    state => HmiMacchinaStati);

    HmiPosGripperSx := braccioSx._axisInterface.axisActualPosition*3.75 + 430.0;
    HmiPosGripperDx := braccioDx._axisInterface.axisActualPosition*3.75 + 430.0;

END_PROGRAM
