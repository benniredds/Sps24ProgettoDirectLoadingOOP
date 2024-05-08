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

    VAR_TEMP
        //posAxisLeftDBRef  : REF_TO TO_PositioningAxis;
        //posAxisRightDBRef  : REF_TO TO_PositioningAxis;
        //posAxisRotDBRef  : REF_TO TO_PositioningAxis;
    END_VAR

    //posAxisRotDBRef := AsPositioningAxisRef(posAxisRotDB);
    //posAxisLeftDBRef := AsPositioningAxisRef(posAxisLeftDB);
    //posAxisRightDBRef := AsPositioningAxisRef(posAxisRightDB);


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
