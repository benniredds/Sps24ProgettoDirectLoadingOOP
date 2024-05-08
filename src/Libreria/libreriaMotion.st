USING Siemens.Simatic.S71500.MotionControl.Native;
USING System.Timer;

NAMESPACE libreriaMotion

    FUNCTION_BLOCK controlloPinza
        VAR_INPUT 
           apri : Bool;
           chiudi : Bool;
           timerPinza : LTime;
        END_VAR
     
        VAR_OUTPUT 
           chiudiPinza : Bool;
           aperta : Bool;
           chiusa : Bool;
           errore : Bool;
        END_VAR
     
        VAR 
           instTimerChiudi : OnDelay;
           instTimerApri : OnDelay;
        END_VAR
     
         
         IF chiudi AND NOT apri THEN
             chiudiPinza := TRUE;
         END_IF;
         IF apri AND NOT chiudi THEN
             chiudiPinza := FALSE;
         END_IF;
         
         //Errore doppio comando
         errore := apri AND chiudi;
         
         //Temporizzatore chiusura
         instTimerChiudi(signal := chiudiPinza, duration := timerPinza, output => chiusa);
         
         //Temporizzatore apertura
         instTimerApri(signal := NOT chiudiPinza, duration := timerPinza, output => aperta);
          
     END_FUNCTION_BLOCK

    FUNCTION_BLOCK controlloAsse
        VAR_INPUT
            axisOn : Bool;
            home : Bool;
            goToPos1 : Bool;
            goToPos2 : Bool;
            Pos1 : Real;
            Pos2: Real;
            asse : DB_ANY;
        END_VAR
        VAR_OUTPUT
            powered : Bool;
            referenced : Bool;
            inPos1 : Bool;
            inPos2 : Bool;
            error : Bool;
        END_VAR
        VAR_TEMP
            minPos1 : LReal;
            maxPos1 : LReal;
            minPos2 : LReal;
            maxPos2 : LReal;
            posAxisRef : REF_TO TO_PositioningAxis;
        END_VAR
        VAR CONSTANT
            TOL : LREAL := 0.5;
        END_VAR
        VAR
            instMcPower : MC_Power;
            instMcHome : MC_Home;
            instMc_MoveAbs1 : MC_MoveAbsolute;
            instMc_MoveAbs2 : MC_MoveAbsolute;
        END_VAR
        
        //Assegnazione
        posAxisRef := AsPositioningAxisRef(asse);
    
        //Power
        instMcPower(Enable := axisOn, StartMode := 1, Axis := posAxisRef^, Status => powered);
        
        //Homing
        instMcHome(Execute := home, Axis := posAxisRef^);
        referenced := posAxisRef^.StatusWord.%X5;
    
        //MoveAbs1
        instMc_MoveAbs1(Execute := goToPos1, Position := Pos1, Direction := 3, Axis := posAxisRef^);
    
        //MoveAbs2
        instMc_MoveAbs2(Execute := goToPos2, Position := Pos2, Direction := 3, Axis := posAxisRef^);
    
        //Tolleranze per range di posizione e controllo posizione
        minPos1 := Pos1 - TOL;
        maxPos1 := Pos1 + TOL;
        minPos2 := Pos2 - TOL;
        maxPos2 := Pos2 + TOL;
    
        IF (minPos1 < posAxisRef^.ActualPosition) AND (posAxisRef^.ActualPosition < maxPos1) THEN
            inPos1 := TRUE;
        ELSE
            inPos1 := FALSE;
        END_IF;
    
        IF (minPos2 < posAxisRef^.ActualPosition) AND (posAxisRef^.ActualPosition < maxPos2) THEN
            inPos2 := TRUE;
        ELSE
            inPos2 := FALSE;
        END_IF;
    
        //cumulativo errori
        error := instMcPower.Error OR instMcHome.Error OR instMc_MoveAbs1.Error OR instMc_MoveAbs2.Error;
    
    END_FUNCTION_BLOCK
    
    FUNCTION_BLOCK controlloBraccio
        VAR_INPUT
            prendi : BOOL;
            posa : BOOL;
            accendiAsse : BOOL;
            vaiAHomeAsse : BOOL;
            asse : DB_ANY;
        END_VAR
        VAR_OUTPUT
            pinzaAperta : BOOL;
            pinzaChiusa : BOOL;
            inPosAlta : BOOL;
            inPosBassa : BOOL;
            asseAcceso : BOOL;
            asseReferenziato : BOOL;
            uscitaPinza : BOOL;
            errore : BOOL;
        END_VAR
        VAR_IN_OUT
            finePresa : BOOL;
            finePosa : BOOL;
        END_VAR
        VAR
        instControlloPinza : controlloPinza;
        instControlloAsse : controlloAsse;
        statMissionePrendi : Int;
        statMissionePosa : Int;
        statApriPinza : BOOL;
        statChiudiPinza : BOOL;
        statVaiAPosAttesa : BOOL;
        statVaiAPosPresa : BOOL;
        statErroreAsse : BOOL;
        statErrorePinza : BOOL;
        END_VAR
        VAR_TEMP
            posAxisRef : REF_TO TO_PositioningAxis;
        END_VAR

        //Logica Presa Braccio
        CASE statMissionePrendi OF
            0:  // Avvio Missione Prendi
                IF prendi THEN
                    finePresa := FALSE;
                    statMissionePrendi := 2;
                END_IF;
            2:  // La pinza è aperta?
                IF pinzaAperta THEN
                    statApriPinza := FALSE;
                    statMissionePrendi := 4;
                ELSE
                    statApriPinza := TRUE;
                END_IF;
            4: //Vai a posizione di presa
                IF inPosBassa THEN
                    statvaiAPosPresa := FALSE;
                    statMissionePrendi := 6;
                ELSE
                    statvaiAPosPresa := TRUE;
                END_IF;
            6: //Chiudi la pinza
                IF pinzaChiusa THEN
                    statChiudiPinza := FALSE;
                    statMissionePrendi := 8;
                ELSE
                    statChiudiPinza := TRUE;
                END_IF;
            8: //Vai a posizione di attesa
                IF inPosAlta THEN
                    statvaiAPosAttesa := FALSE;
                    statMissionePrendi := 30;
                ELSE
                    statvaiAPosAttesa := TRUE;
                END_IF;
            30: //Fine
                statMissionePrendi := 0;
                finePresa := true;
        END_CASE;

        //Logica Posa Braccio
        CASE statMissionePosa OF
            0:  // Avvio Missione Prendi
                IF posa THEN
                    finePosa := FALSE;
                    statMissionePosa := 2;
                END_IF;
            2: //Vai a posizione di deposito
                IF inPosBassa THEN
                    statvaiAPosPresa := FALSE;
                    statMissionePosa := 4;
                ELSE
                    statvaiAPosPresa := TRUE;
                END_IF;
            4: //Apri la pinza
                IF pinzaAperta THEN
                    statApriPinza := FALSE;
                    statMissionePosa := 6;
                ELSE
                    statApriPinza := TRUE;
                END_IF;
            6: //Vai a posizione di attesa
                IF inPosAlta THEN
                    statvaiAPosAttesa := FALSE;
                    statMissionePosa := 30;
                ELSE
                    statvaiAPosAttesa := TRUE;
                END_IF;
            30: //Fine
                statMissionePosa := 0;
                finePosa := TRUE;
        END_CASE;

        instControlloAsse(axisOn := accendiAsse
                        , home := vaiAHomeAsse
                        , goToPos1 := statVaiAPosAttesa
                        , goToPos2 := statVaiAPosPresa
                        , Pos1 := 5
                        , Pos2 := 100
                        , asse := asse
                        , powered => asseAcceso
                        , referenced => asseReferenziato
                        , inPos1 => inPosAlta
                        , inPos2 => inPosBassa
                        , error => statErroreAsse                        
                        );
        
        instControlloPinza(apri := statApriPinza
                            , chiudi := statChiudiPinza
                            , timerPinza := LT#500ms
                            , chiudiPinza => uscitaPinza
                            , aperta => pinzaAperta
                            , chiusa => pinzaChiusa
                            , errore => statErrorePinza
                        );

        errore := statErroreAsse OR statErrorePinza;
        ;
    END_FUNCTION_BLOCK

END_NAMESPACE
