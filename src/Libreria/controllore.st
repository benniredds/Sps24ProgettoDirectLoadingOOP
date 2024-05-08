USING udt;
USING System.Timer;
NAMESPACE Controllore
    
    FUNCTION_BLOCK controlloreCentrale

        VAR_INPUT 
            start : Bool;
         END_VAR
      
         VAR_OUTPUT 
            cicloAutomatico : Bool;
         END_VAR
      
         VAR 
            statPasso : Int;
            timer : OnDelay;
            numeroCicli : Int;
         END_VAR

        VAR_IN_OUT
            asseRot : interfacciaTavola;
            asseDx : interfacciaAsse;
            asseSx : interfacciaAsse;
        END_VAR

         
        CASE statPasso OF
        
            0:  // Avvio Sequenza
                IF start THEN
                    statPasso := 100;
                    cicloAutomatico := TRUE;
                    asseDx.fineMissionePresa := FALSE;
                    asseDx.fineMissionePosa := FALSE;
                    asseSx.fineMissionePresa := FALSE;
                    asseSx.fineMissionePosa := FALSE;
                END_IF;
                
            100:  // Controllo se gli assi sono accesi
                IF asseRot.acceso AND asseSx.asseAcceso AND asseDx.asseAcceso THEN
                    statPasso := 101;
                ELSE
                    IF NOT asseRot.acceso THEN
                        asseRot.accendi := TRUE;
                    END_IF;
                    IF NOT asseSx.asseAcceso THEN
                        asseSx.accendiAsse := TRUE;
                    END_IF;
                    IF NOT asseDx.asseAcceso THEN
                        asseDx.accendiAsse := TRUE;
                    END_IF;
                END_IF;
                
            101://Controllo se gli assi sono referenziati
                IF asseRot.referenziato AND asseSx.asseReferenziato AND asseDx.asseReferenziato THEN
                    asseRot.vaiHome := FALSE;
                    asseSx.vaiAHomeAsse := FALSE;
                    asseDx.vaiAHomeAsse := FALSE;
                    statPasso := 2;
                ELSE
                    IF NOT asseRot.referenziato THEN
                        asseRot.vaiHome := TRUE;
                    END_IF;
                    IF NOT asseSx.asseReferenziato THEN
                        asseSx.vaiAHomeAsse := TRUE;
                    END_IF;
                    IF NOT asseDx.asseReferenziato THEN
                        asseDx.vaiAHomeAsse := TRUE;
                    END_IF;
                END_IF;
                
            2:  // Ruota AsseRot in Pos 1
                IF asseRot.inPos1 THEN
                    asseRot.vaiPos1 := FALSE;
                    statPasso := 4;
                ELSE
                    asseRot.vaiPos1 := TRUE;
                END_IF;
                
            4:  // Prendi con AsseSx
                IF asseSx.fineMissionePresa THEN
                    asseSx.fineMissionePresa := FALSE;
                    asseSx.prendi := FALSE;
                    statPasso := 6;
                ELSE
                    asseSx.prendi := TRUE;
                END_IF;
                
            6: // Attesa 
                 timer(signal := TRUE, duration:= T#1s);
                IF timer.output THEN
                    timer.signal := FALSE;
                    statPasso := 8;
                END_IF;
                
            8:  // Posa con AsseSx
                IF asseSx.fineMissionePosa THEN
                    asseSx.fineMissionePosa := FALSE;
                    asseSx.posa := FALSE;
                    statPasso := 10;
                ELSE
                    asseSx.posa := TRUE;
                END_IF;
                
            10:  // Ruota AsseRot in Pos 2
                IF asseRot.inPos2 THEN
                    asseRot.vaiPos2 := FALSE;
                    statPasso := 12;
                ELSE
                    asseRot.vaiPos2 := TRUE;
                END_IF;
                
            12:  // Prendi con AsseDx
                IF asseDx.fineMissionePresa THEN
                    asseDx.fineMissionePresa := FALSE;
                    asseDx.prendi := FALSE;
                    statPasso := 14;
                ELSE
                    asseDx.prendi := TRUE;
                END_IF;
                
            14: //Attesa
                timer(signal := TRUE, duration := T#1s);
                IF timer.output THEN
                    timer.signal := FALSE;
                    statPasso := 16;
                END_IF;
                
            16:  // Posa con AsseDx
                IF asseDx.fineMissionePosa THEN
                    asseDx.fineMissionePosa := FALSE;
                    asseDx.posa := FALSE;
                    statPasso := 30;
                ELSE
                    asseDx.posa := TRUE;
                END_IF;
                
            30: //Fine Sequenza
                statPasso := 0;
                cicloAutomatico := FALSE;
                numeroCicli := numeroCicli + 1;
        END_CASE;
    
    END_FUNCTION_BLOCK
END_NAMESPACE