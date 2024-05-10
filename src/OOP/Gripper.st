USING libUdtOop;
USING System.Timer;

NAMESPACE libMotOop

    CLASS PUBLIC GripperClass
        VAR PROTECTED
            _instTimerOpen : OnDelay;
            _instTimerClose : OnDelay;
        END_VAR
        {S7.extern=ReadWrite}
        {OpcUa=ReadWrite}
        VAR PUBLIC
            _gripperInterface : gripperInterface;
        END_VAR

        METHOD PUBLIC OpenGripper
            VAR_INPUT
                timerGripper : LTIME;
            END_VAR
            _gripperInterface.gripperCmd.closeGripper := FALSE;
            _gripperInterface.gripperCmd.openGripper := TRUE;

            _gripperInterface.gripperClosed := FALSE;
            _instTimerOpen(signal := TRUE, duration := timerGripper, output => _gripperInterface.gripperOpened);
        END_METHOD

        METHOD PUBLIC CloseGripper
            VAR_INPUT
                timerGripper : LTIME;
            END_VAR
            _gripperInterface.gripperCmd.openGripper := FALSE;
            _gripperInterface.gripperCmd.closeGripper := TRUE;

            _gripperInterface.gripperOpened := FALSE;
            _instTimerClose(signal := TRUE, duration := timerGripper, output => _gripperInterface.gripperClosed);
        END_METHOD
    END_CLASS

END_NAMESPACE

