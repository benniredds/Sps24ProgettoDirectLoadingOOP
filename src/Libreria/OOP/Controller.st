USING libUdtOop;
USING System.Timer;
USING Siemens.Simatic.S71500.MotionControl.Native;

NAMESPACE libMotOop

    FUNCTION_BLOCK controlloreCentrale
        VAR_INPUT
            start : BOOL;
            posAxisRot : DB_ANY;
            posAxisRight : DB_ANY;
            posAxisLeft : DB_ANY;
        END_VAR
        VAR_OUTPUT
            cicloAutomatico : BOOL;
        END_VAR
        VAR
            state : INT;
            timer : OnDelay;
            numeroCicli : INT;
            asseRot : AxisClass;
            asseDx : ArmClass;
            asseSx : ArmClass;
        END_VAR
        
        CASE state OF
            0: //one-time setup
                asseRot.SetAxis(posAxisRot);
                asseDx.SetAxis(posAxisRight);
                asseSx.SetAxis(posAxisLeft);
                state := 1;
            1: // Avvio Sequenza
                IF start THEN
                    state := 100;
                    cicloAutomatico := TRUE;
                    asseDx._armInterface.endPick := FALSE;
                    asseDx._armInterface.endPlace := FALSE;
                    asseSx._armInterface.endPick := FALSE;
                    asseSx._armInterface.endPlace := FALSE;
                END_IF;
            100: // Controllo se gli assi sono accesi
                IF asseRot._axisInterface.axisOn AND asseSx._axisInterface.axisOn AND asseDx._axisInterface.axisOn THEN
                    state := 101;
                ELSE
                    IF NOT asseRot._axisInterface.axisOn THEN
                        asseRot.Power(startMode := DIRECTION#STARTMODE);
                    END_IF;
                    IF NOT asseSx._axisInterface.axisOn THEN
                        asseSx.Power(startMode := DIRECTION#STARTMODE);
                    END_IF;
                    IF NOT asseDx._axisInterface.axisOn THEN
                        asseDx.Power(startMode := DIRECTION#STARTMODE);
                    END_IF;
                END_IF;
            101: //Controllo se gli assi sono referenziati
                IF asseRot._axisInterface.axisReferenced AND asseSx._axisInterface.axisReferenced AND asseDx._axisInterface.axisReferenced THEN
                    state := 2;
                ELSE
                    IF NOT asseRot._axisInterface.axisReferenced THEN
                        asseRot.Homing();
                    END_IF;
                    IF NOT asseSx._axisInterface.axisReferenced THEN
                        asseSx.Homing();
                    END_IF;
                    IF NOT asseDx._axisInterface.axisReferenced THEN
                        asseDx.Homing();
                    END_IF;
                END_IF;
            2: // Ruota AsseRot in Pos 1
                IF asseRot._axisInterface.axisPos1 THEN
                    state := 4;
                ELSE
                    asseRot.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#BUFFERPOS1);
                END_IF;
            4: // Prendi con AsseSx
                IF asseSx._armInterface.endPick THEN
                    asseSx._armInterface.endPick := FALSE;
                    state := 6;
                ELSE
                    asseSx.Pick();
                END_IF;
            6: // Attesa 
                timer(signal := TRUE, duration := TIMER#WIP);
                IF timer.output THEN
                    timer.signal := FALSE;
                    state := 8;
                END_IF;
            8: // Posa con AsseSx
                IF asseSx._armInterface.endPlace THEN
                    asseSx._armInterface.endPlace := FALSE;
                    state := 10;
                ELSE
                    asseSx.Place();
                END_IF;
            10: // Ruota AsseRot in Pos 2
                IF asseRot._axisInterface.axisPos2 THEN
                    state := 12;
                ELSE
                    asseRot.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#BUFFERPOS2);
                END_IF;
            12: // Prendi con AsseDx
                IF asseDx._armInterface.endPick THEN
                    asseDx._armInterface.endPick := FALSE;
                    state := 14;
                ELSE
                    asseDx.Pick();
                END_IF;
            14: //Attesa
                timer(signal := TRUE, duration := TIMER#WIP);
                IF timer.output THEN
                    timer.signal := FALSE;
                    state := 16;
                END_IF;
            16: // Posa con AsseDx
                IF asseDx._armInterface.endPlace THEN
                    asseDx._armInterface.endPlace := FALSE;
                    state := 30;
                ELSE
                    asseDx.Place();
                END_IF;
            30: //Fine Sequenza
                state := 1;
                cicloAutomatico := FALSE;
                numeroCicli := numeroCicli + 1;
        END_CASE;

        asseRot.CyclicCall();
        asseRot.CalculatePosition(POSITION#BUFFERPOS1, POSITION#BUFFERPOS2);

        asseDx.CyclicCall();
        asseDx.CalculatePosition(POSITION#ARMPOS1, POSITION#ARMPOS2);
        
        asseSx.CyclicCall();
        asseSx.CalculatePosition(POSITION#ARMPOS1, POSITION#ARMPOS2);


    END_FUNCTION_BLOCK

END_NAMESPACE
