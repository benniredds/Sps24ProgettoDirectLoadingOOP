// USING libreriaMotion;
// USING controllore;
// USING udt;
// USING Siemens.Simatic.S71500.MotionControl.Native;

// PROGRAM MyProgram
//     VAR_EXTERNAL
//         start : BOOL;
//         tavolaRotante : interfacciaTavola;
//         braccioDx : interfacciaAsse;
//         braccioSx : interfacciaAsse;
//         fineCiclo : BOOL;
//     END_VAR
        
//     VAR
//         instControlloTavolaRot : controlloAsse;
//         instControlloBraccioSx : controlloBraccio;
//         instControlloBraccioDx : controlloBraccio;
//         instControllore : controlloreCentrale;
//     END_VAR

//     VAR CONSTANT
//         posAxisLeftDB  : UINT := UINT#3;
//         posAxisRightDB  : UINT := UINT#6;
//         posAxisRotDB  : UINT := UINT#16;
//     END_VAR

//     VAR_TEMP
//         posAxisLeftDBRef  : REF_TO TO_PositioningAxis;
//         posAxisRightDBRef  : REF_TO TO_PositioningAxis;
//         posAxisRotDBRef  : REF_TO TO_PositioningAxis;
//     END_VAR



//     instControllore(start := start,
//                 asseRot := tavolaRotante,
//                 asseDx := braccioDx,
//                 asseSx := braccioSx,
//                 cicloAutomatico => fineCiclo);

//     instControlloTavolaRot(axisOn := tavolaRotante.accendi,
//                             home := tavolaRotante.vaiHome,
//                             goToPos1 := tavolaRotante.vaiPos1,
//                             goToPos2 := tavolaRotante.vaiPos2,
//                             Pos1 := 270,
//                             Pos2 := 90,
//                             asse := posAxisRotDB,
//                             powered => tavolaRotante.acceso,
//                             referenced => tavolaRotante.referenziato,
//                             inPos1 => tavolaRotante.inPos1,
//                             inPos2 => tavolaRotante.inPos2,
//                             error => tavolaRotante.errori);

//     posAxisRotDBRef := AsPositioningAxisRef(posAxisRotDB);
//     tavolaRotante.posizioneAttuale := posAxisRotDBRef^.ActualPosition;
    
//     instControlloBraccioSx(prendi := braccioSx.prendi,
//                             posa := braccioSx.posa,
//                             accendiAsse := braccioSx.accendiAsse,
//                             vaiAHomeAsse := braccioSx.vaiAHomeAsse,
//                             asse := posAxisLeftDB,
//                             finePresa := braccioSx.fineMissionePresa,
//                             finePosa := braccioSx.fineMissionePosa,
//                             pinzaAperta => braccioSx.pinzaAperta,
//                             pinzaChiusa => braccioSx.pinzaChiusa,
//                             inPosAlta => braccioSx.inPosAlta,
//                             inPosBassa => braccioSx.inPosBassa,
//                             asseAcceso => braccioSx.asseAcceso,
//                             asseReferenziato => braccioSx.asseReferenziato,
//                             errore => braccioSx.errori);

//     posAxisLeftDBRef := AsPositioningAxisRef(posAxisLeftDB);
//     braccioSx.posizioneAttuale := posAxisLeftDBRef^.ActualPosition;

// instControlloBraccioDx(prendi := braccioDx.prendi,
//                             posa := braccioDx.posa,
//                             accendiAsse := braccioDx.accendiAsse,
//                             vaiAHomeAsse := braccioDx.vaiAHomeAsse,
//                             asse := posAxisRightDB,
//                             finePresa := braccioDx.fineMissionePresa,
//                             finePosa := braccioDx.fineMissionePosa,
//                             pinzaAperta => braccioDx.pinzaAperta,
//                             pinzaChiusa => braccioDx.pinzaChiusa,
//                             inPosAlta => braccioDx.inPosAlta,
//                             inPosBassa => braccioDx.inPosBassa,
//                             asseAcceso => braccioDx.asseAcceso,
//                             asseReferenziato => braccioDx.asseReferenziato,
//                             errore => braccioDx.errori);

//     posAxisRightDBRef := AsPositioningAxisRef(posAxisRightDB);
//     braccioDx.posizioneAttuale := posAxisRightDBRef^.ActualPosition;
                            

// END_PROGRAM
