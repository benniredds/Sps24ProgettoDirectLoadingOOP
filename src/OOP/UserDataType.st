NAMESPACE libUdtOop

    TYPE
    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
        gripperInterface : STRUCT
            gripperCmd : gripperCommands;
            gripperOpened : BOOL;
            gripperClosed : BOOL;
        END_STRUCT;
    END_TYPE

    TYPE
    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
        gripperCommands : STRUCT
            openGripper : BOOL;
            closeGripper : BOOL;
        END_STRUCT;
    END_TYPE

    TYPE
    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
        axisInterface : STRUCT
            axisCmd : axisCommands;
            axisOn : BOOL;
            axisReferenced : BOOL;
            axisError : BOOL;
            axisActualPosition : LREAL;
            axisPos1 : BOOL;
            axisPos2 : BOOL;
        END_STRUCT;
    END_TYPE

    TYPE
    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
        axisCommands : STRUCT
            powerAxis : BOOL;
            homingAxis : BOOL;
            goToPos1Axis : BOOL;
            goToPos2Axis : BOOL;
        END_STRUCT;
    END_TYPE

    TYPE
    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
        armInterface : STRUCT
            armCmd : armCommands;
            endPick : BOOL;
            endPlace : BOOL;
        END_STRUCT;
    END_TYPE

    TYPE
    {S7.extern=ReadWrite}
    {OpcUa=ReadWrite}
        armCommands : STRUCT
            pickArm : BOOL;
            placeArm : BOOL;
        END_STRUCT;
    END_TYPE

    TYPE
        POSITION : LREAL (
            NONE := 0,
            ARMPOS1 := 100.0,
            ARMPOS2 := 5.0,
            BUFFERPOS1 := 270.0,
            BUFFERPOS2 := 90.0,
            TOL := 0.5
        ) := NONE;
    END_TYPE
    TYPE
        DIRECTION : INT (
            DEFAULT := 3,
            STARTMODE := 1
        ) := DEFAULT;
    END_TYPE
    
    TYPE
        TIMER : LTIME (
            GRIPPER := LT#1s,
            WIP := LT#2s
        ) := GRIPPER;
    END_TYPE

END_NAMESPACE
