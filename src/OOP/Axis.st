USING libUdtOop;
USING Siemens.Simatic.S71500.MotionControl.Native;

NAMESPACE libMotOop

    CLASS PUBLIC AxisClass
        VAR PROTECTED
            _instMcPower : MC_Power;
            _instMcHome : MC_Home;
            _instMc_MoveAbs : MC_MoveAbsolute;
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

        METHOD PUBLIC MoveAbs //Movimento Asse in posizione
            VAR_INPUT
                direction : INT;
                position : LREAL;
            END_VAR
            _instMc_MoveAbs.Execute := TRUE;
            _instMc_MoveAbs.Position := position;
            _instMc_MoveAbs.Direction := direction;
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
                _instMc_MoveAbs(Axis := _axisAsPos^);
                IF _instMcHome.Done THEN
                    _instMcHome.Execute := FALSE;
                END_IF;
                IF _instMc_MoveAbs.Done OR _instMc_MoveAbs.CommandAborted THEN
                    _instMc_MoveAbs.Execute := FALSE;
                END_IF;
                _axisInterface.axisOn := _instMcPower.Status;
                _axisInterface.axisReferenced := _axisAsPos^.StatusWord.%X5;
                _axisInterface.axisError := _instMcPower.Error OR _instMcHome.Error OR _instMc_MoveAbs.Error;
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
