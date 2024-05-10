USING libMotOop;
USING libUdtOop;
USING Siemens.Simatic.S71500.MotionControl.Native;

PROGRAM MyProgram
    VAR_EXTERNAL
        start : BOOL;
        tavolaRotante : AxisClass;
        braccioDx : ArmClass;
        braccioSx : ArmClass;
        fineCiclo : BOOL;
        nrCicli : INT;
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
                    posAxisRot := posAxisRotDB,
                    posAxisRight := posAxisRightDB,
                    posAxisLeft := posAxisLeftDB,
                    asseRot := tavolaRotante,
                    asseDx := braccioDx,
                    asseSx := braccioSx,
                    cicloAutomatico => fineCiclo,
                    numeroCicli => nrCicli);

END_PROGRAM
