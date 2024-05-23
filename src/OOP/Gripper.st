USING libUdtOop;
USING System.Timer;

NAMESPACE libMotOop

    CLASS PUBLIC GripperClass
        VAR PROTECTED
            _instTimerOpen : OnDelay;
            _signalOpen : BOOL; 
            _instTimerClose : OnDelay;
            _signalClose : BOOL;
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


            IF NOT _signalOpen THEN
                _instTimerOpen(signal := _signalOpen, duration := timerGripper, output => _gripperInterface.gripperOpened);
                _signalOpen := TRUE;
            END_IF;
            _instTimerOpen(signal := _signalOpen, duration := timerGripper, output => _gripperInterface.gripperOpened);
            IF _instTimerOpen.output THEN
                _gripperInterface.gripperClosed := FALSE;
                _signalOpen := FALSE;
            END_IF;
            
        END_METHOD

        METHOD PUBLIC CloseGripper
            VAR_INPUT
                timerGripper : LTIME;
            END_VAR
            _gripperInterface.gripperCmd.openGripper := FALSE;
            _gripperInterface.gripperCmd.closeGripper := TRUE;

            
            IF NOT _signalClose THEN
                _instTimerClose(signal := _signalClose, duration := timerGripper, output => _gripperInterface.gripperClosed);
                _signalClose := TRUE;
            END_IF;
            _instTimerClose(signal := _signalClose, duration := timerGripper, output => _gripperInterface.gripperClosed);
            IF _instTimerClose.output THEN
                _gripperInterface.gripperOpened := FALSE;
                _signalClose := FALSE;
            END_IF;

        END_METHOD
    END_CLASS

END_NAMESPACE

