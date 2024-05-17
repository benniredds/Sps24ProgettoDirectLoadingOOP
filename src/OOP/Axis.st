USING libUdtOop;
USING Siemens.Simatic.S71500.MotionControl.Native;

NAMESPACE libMotOop

    CLASS PUBLIC AxisClass
        VAR PROTECTED
            _instMcPower : MC_Power;
            _instMcHome : MC_Home;
            _instMcMoveAbs : MC_MoveAbsolute;

            _instMcStop : MC_Stop;
            // _instMcReset : MC_Reset;

            _axisDB : DB_ANY;
        END_VAR
        {S7.extern=ReadWrite}
        {OpcUa=ReadWrite}
        VAR PUBLIC
            _axisInterface : axisInterface;
        END_VAR

        METHOD PUBLIC SetAxis : BOOL //Init: controllo se gli oggetti tecnologici sono compatibili
            VAR_INPUT
                axisDB : DB_ANY;
            END_VAR
            VAR_TEMP
                _axisAsPos : REF_TO TO_PositioningAxis;
            END_VAR
            _axisDB := axisDB;
            _axisAsPos := AsPositioningAxisRef(_axisDB);
            SetAxis := _axisAsPos <> NULL;
        END_METHOD

        METHOD PUBLIC Power : BOOL //Abilitazione Asse 
            VAR_INPUT
                startMode : INT;
            END_VAR
            _instMcPower.StartMode := startMode;
            _instMcPower.Enable := TRUE;
            Power := _instMcPower.Status;
        END_METHOD

        METHOD PUBLIC Homing //Homing Asse
            _instMcHome.Execute := TRUE;
        END_METHOD

        // METHOD PUBLIC Reset //reset Asse
        //     _instMcReset.Restart := FALSE;
        //     _instMcReset.Execute := TRUE;
        // END_METHOD

        METHOD PUBLIC Stop //reset Asse
            _instMcStop.Execute := TRUE;
            _instMcStop.Mode := 0;
        END_METHOD

        
        METHOD PUBLIC MoveAbs //Movimento Asse in posizione
            VAR_INPUT
                direction : INT;
                position : LREAL;
            END_VAR
            _instMcMoveAbs.Execute := TRUE;
            _instMcMoveAbs.Position := position;
            _instMcMoveAbs.Velocity := 25.0;
            _instMcMoveAbs.Direction := direction;
        END_METHOD

        METHOD PUBLIC CyclicCall //Metodo che inizializza le istruzioni di Motion e lo stato dell'Asse
            THIS.CallMcBlocksPosAxis();
        END_METHOD

        METHOD PROTECTED CallMcBlocksPosAxis //Metodo Protetto, non direttamente accessibile
            VAR_TEMP
                _axisAsPos : REF_TO TO_PositioningAxis;
            END_VAR
            _axisAsPos := AsPositioningAxisRef(_axisDB);
            IF _axisAsPos = NULL THEN
                RETURN;
            ELSE
                _instMcPower(Axis := _axisAsPos^);
                _instMcHome(Axis := _axisAsPos^);
                _instMcMoveAbs(Axis := _axisAsPos^);
                // _instMcReset(Axis := _axisAsPos^);
                _instMcStop(Axis := _axisAsPos^);

                //Gestione Home
                IF _instMcHome.Done THEN
                    _instMcHome.Execute := FALSE;
                END_IF;

                //Gestione Reset
                // IF _instMcReset.Done AND NOT _instMcReset.Restart THEN
                //     _instMcReset.Execute := FALSE;
                //     _instMcReset.Restart := TRUE;
                //     _instMcReset.Execute := TRUE;
                // END_IF;

                // IF _instMcReset.Done AND _instMcReset.Restart THEN
                //     _instMcReset.Execute := FALSE;
                // END_IF;

                //Gestione Stop
                IF _instMcStop.Done THEN
                    _instMcStop.Execute := FALSE;
                END_IF;

                //Gestione Move
                IF _instMcMoveAbs.Done OR _instMcMoveAbs.CommandAborted THEN
                    _instMcMoveAbs.Execute := FALSE;
                END_IF;

                _axisInterface.axisOn := _instMcPower.Status;
                _axisInterface.axisReferenced := _axisAsPos^.StatusWord.%X5;
                _axisInterface.axisError := _instMcPower.Error OR _instMcHome.Error OR _instMcMoveAbs.Error;
                _axisInterface.axisActualPosition := _axisAsPos^.ActualPosition;
            END_IF;
        END_METHOD

        METHOD PUBLIC CalculatePosition
            VAR_INPUT
                limit1 : LREAL;
                limit2 : LREAL;
            END_VAR
            VAR_TEMP
                _axisAsPos : REF_TO TO_PositioningAxis;
            END_VAR
            _axisAsPos := AsPositioningAxisRef(_axisDB);
            IF _axisAsPos = NULL THEN
                RETURN;
            ELSE
                IF ((limit1 - POSITION#TOL) < _axisAsPos^.ActualPosition) AND (_axisAsPos^.ActualPosition < (limit1 + POSITION#TOL)) THEN
                    _axisInterface.axisPos1 := TRUE;
                ELSE
                    _axisInterface.axisPos1 := FALSE;
                END_IF;
                IF ((limit2 - POSITION#TOL) < _axisAsPos^.ActualPosition) AND (_axisAsPos^.ActualPosition < (limit2 + POSITION#TOL)) THEN
                    _axisInterface.axisPos2 := TRUE;
                ELSE
                    _axisInterface.axisPos2 := FALSE;
                END_IF;
            END_IF;
        END_METHOD
    END_CLASS

END_NAMESPACE
