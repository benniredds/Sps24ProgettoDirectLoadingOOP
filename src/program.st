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
        HmiPosPezzo : LREAL;
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

    // HMI                     
    HmiPosGripperSx := braccioSx._axisInterface.axisActualPosition*3.75 + 430.0;
    HmiPosGripperDx := braccioDx._axisInterface.axisActualPosition*3.75 + 430.0;

    IF HmiMacchinaStati = 2 THEN
        IF tavolaRotante._axisInterface.axisActualPosition < 270 AND tavolaRotante._axisInterface.axisActualPosition > 90 AND NOT (tavolaRotante._axisInterface.axisPos1 OR tavolaRotante._axisInterface.axisPos2) THEN
            HmiPosPezzo := -2.78*(tavolaRotante._axisInterface.axisActualPosition - 270) + 204;
        END_IF;
        
        IF tavolaRotante._axisInterface.axisActualPosition > 270 AND tavolaRotante._axisInterface.axisActualPosition <= 360 AND NOT (tavolaRotante._axisInterface.axisPos1 OR tavolaRotante._axisInterface.axisPos2) THEN
            HmiPosPezzo := 2.8*(tavolaRotante._axisInterface.axisActualPosition - 270)+ 204;
        END_IF;
    END_IF;

    IF HmiMacchinaStati = 10 THEN
        IF tavolaRotante._axisInterface.axisActualPosition > 270 AND tavolaRotante._axisInterface.axisActualPosition <= 360 AND NOT (tavolaRotante._axisInterface.axisPos1 OR tavolaRotante._axisInterface.axisPos2) THEN
            HmiPosPezzo := 2.8*(tavolaRotante._axisInterface.axisActualPosition - 270)+ 204;
        END_IF;
        
        IF tavolaRotante._axisInterface.axisActualPosition >=0 AND tavolaRotante._axisInterface.axisActualPosition < 90 AND NOT (tavolaRotante._axisInterface.axisPos1 OR tavolaRotante._axisInterface.axisPos2) THEN
            HmiPosPezzo := 2.77*(tavolaRotante._axisInterface.axisActualPosition) + 456;
        END_IF;
    END_IF;

END_PROGRAM
