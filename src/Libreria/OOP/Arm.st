USING libUdtOop;
USING Siemens.Simatic.S71500.MotionControl.Native;

NAMESPACE libMotOop

    CLASS PUBLIC ArmClass EXTENDS AxisClass
        VAR PUBLIC
            _instGripper : GripperClass;
            //_instAxis : AxisClass;
            _armInterface : armInterface;
        END_VAR

        METHOD PUBLIC Pick
            VAR
                state : INT;
            END_VAR
            //Logica Presa Braccio
            CASE state OF
                0: // Avvio Missione Prendi
                    IF _armInterface.armCmd.pickArm THEN
                        _armInterface.endPick := FALSE;
                        state := 2;
                    END_IF;
                2: // La pinza è aperta?
                    IF _instGripper._gripperInterface.gripperOpened THEN
                        state := 4;
                    ELSE
                        _instGripper.OpenGripper(timerGripper := TIMER#GRIPPER);
                    END_IF;
                4: //Vai a posizione di presa (bassa)
                    IF _armInterface.armPos1 THEN
                        state := 6;
                    ELSE
                        THIS.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#ARMPOS1);
                    END_IF;
                6: //Chiudi la pinza
                    IF _instGripper._gripperInterface.gripperClosed THEN
                        state := 8;
                    ELSE
                        _instGripper.CloseGripper(timerGripper := TIMER#GRIPPER);
                    END_IF;
                8: //Vai a posizione di attesa (alta)
                    IF _armInterface.armPos2 THEN
                        state := 30;
                    ELSE
                        THIS.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#ARMPOS2);
                    END_IF;
                30: //Fine
                    state := 0;
                    _armInterface.endPick := TRUE;
            END_CASE;
        END_METHOD

        METHOD PUBLIC Place
            VAR
                state : INT;
            END_VAR
            //Logica Posa Braccio
            CASE state OF
                0: // Avvio Missione Posa
                    IF _armInterface.armCmd.placeArm THEN
                        _armInterface.endPlace := FALSE;
                        state := 2;
                    END_IF;
                2: //Vai a posizione di posa (bassa)
                    IF _armInterface.armPos1 THEN
                        state := 4;
                    ELSE
                        THIS.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#ARMPOS1);
                    END_IF;
                4: //Apri la pinza
                    IF _instGripper._gripperInterface.gripperOpened THEN
                        state := 6;
                    ELSE
                        _instGripper.OpenGripper(timerGripper := TIMER#GRIPPER);
                    END_IF;
                6: //Vai a posizione di attesa (alta)
                    IF _armInterface.armPos2 THEN
                        state := 30;
                    ELSE
                        THIS.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#ARMPOS2);
                    END_IF;
                30: //Fine
                    state := 0;
                    _armInterface.endPlace := TRUE;
            END_CASE;
        END_METHOD
    END_CLASS

END_NAMESPACE
