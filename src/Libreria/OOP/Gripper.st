USING libUdtOop;
USING System.Timer;

NAMESPACE libMotOop

    CLASS PUBLIC GripperClass
        VAR PROTECTED
            _instTimerOpen : OnDelay;
            _instTimerClose : OnDelay;
        END_VAR
        VAR PUBLIC
            _gripperInterface : gripperInterface;
        END_VAR

        METHOD PUBLIC OpenGripper
            VAR_INPUT
                timerGripper : LTIME;
            END_VAR
            _gripperInterface.gripperCmd.openGripper := TRUE;
            _instTimerOpen(signal := TRUE, duration := timerGripper, output => _gripperInterface.gripperOpened);
        END_METHOD

        METHOD PUBLIC CloseGripper
            VAR_INPUT
                timerGripper : LTIME;
            END_VAR
            _gripperInterface.gripperCmd.closeGripper := TRUE;
            _instTimerClose(signal := TRUE, duration := timerGripper, output => _gripperInterface.gripperClosed);
        END_METHOD
    END_CLASS

END_NAMESPACE
