USING libUdtOop;
USING Siemens.Simatic.S71500.MotionControl.Native;

NAMESPACE libMotOop

    CLASS PUBLIC ArmClass EXTENDS AxisClass
        VAR PUBLIC
            _instGripper : GripperClass;
            //_instAxis : AxisClass;
            _armInterface : armInterface;
            _statePick : INT;
            _statePlace :INT;
        END_VAR


        METHOD PUBLIC Pick
            VAR
                state : INT;
            END_VAR
            //Logica Presa Braccio
            CASE _statePick OF
                0: // Avvio Missione Prendi
                    
                    //IF _armInterface.armCmd.pickArm THEN
                        _armInterface.endPick := FALSE;
                        _statePick := 2;
                    //END_IF;

                2: // La pinza è aperta?
                    IF _instGripper._gripperInterface.gripperOpened THEN
                        _statePick := 4;
                    ELSE
                        _instGripper.OpenGripper(timerGripper := TIMER#GRIPPER);
                    END_IF;
                4: //Vai a posizione di presa (bassa)
                    IF _axisInterface.axisPos1 THEN
                        _statePick := 6;
                    ELSE
                        THIS.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#ARMPOS1);
                    END_IF;
                6: //Chiudi la pinza
                    IF _instGripper._gripperInterface.gripperClosed THEN
                        _statePick := 8;
                    ELSE
                        _instGripper.CloseGripper(timerGripper := TIMER#GRIPPER);
                    END_IF;
                8: //Vai a posizione di attesa (alta)
                    IF _axisInterface.axisPos2 THEN
                        _statePick := 0;
                        _armInterface.endPick := TRUE;
                    ELSE
                        THIS.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#ARMPOS2);
                    END_IF;                  
            END_CASE;
        END_METHOD

        METHOD PUBLIC Place
            VAR_OUTPUT
                state : INT;
            END_VAR
            //Logica Posa Braccio
            CASE _statePlace OF
                0: // Avvio Missione Posa
                    //IF _armInterface.armCmd.placeArm THEN
                        _armInterface.endPlace := FALSE;
                        _statePlace := 2;
                    //END_IF;
                2: //Vai a posizione di posa (bassa)
                    IF _axisInterface.axisPos1 THEN
                        _statePlace := 4;
                    ELSE
                        THIS.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#ARMPOS1);
                    END_IF;
                4: //Apri la pinza
                    IF _instGripper._gripperInterface.gripperOpened THEN
                        _statePlace := 6;
                    ELSE
                        _instGripper.OpenGripper(timerGripper := TIMER#GRIPPER);
                    END_IF;
                6: //Vai a posizione di attesa (alta)
                    IF _axisInterface.axisPos2 THEN
                        _statePlace := 30;
                        _statePlace := 0;
                        _armInterface.endPlace := TRUE;    
                    ELSE
                        THIS.MoveAbs(direction := DIRECTION#DEFAULT, position := POSITION#ARMPOS2);
                    END_IF;
                //30: //Fine
            END_CASE;
        END_METHOD
    END_CLASS

END_NAMESPACE
