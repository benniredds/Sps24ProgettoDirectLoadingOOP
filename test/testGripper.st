USING libMotOop;
USING AxUnit;

NAMESPACE MyGripperTests

    {TestFixture}
    CLASS PUBLIC GripperClassTest
        VAR
            GripperTest : GripperClass;
        END_VAR
        {Test}
        METHOD PUBLIC OpenGripperTest //will pass
            GripperTest.OpenGripper();
            AxUnit.Assert.Equal(TRUE, GripperTest._gripperInterface.gripperOpened);
            AxUnit.Assert.Equal(FALSE, GripperTest._gripperInterface.gripperClosed);
        END_METHOD
        {Test}
        METHOD PUBLIC OpenGripperTestFailed //will fail
            GripperTest.OpenGripper();
            AxUnit.Assert.Equal(TRUE, GripperTest._gripperInterface.gripperOpened);
            AxUnit.Assert.Equal(TRUE, GripperTest._gripperInterface.gripperClosed);
        END_METHOD
        {Test}
        METHOD PUBLIC CloseGripperTest //will pass
            GripperTest.CloseGripper();
            AxUnit.Assert.Equal(FALSE, GripperTest._gripperInterface.gripperOpened);
            AxUnit.Assert.Equal(TRUE, GripperTest._gripperInterface.gripperClosed);
        END_METHOD
        {Test}
        METHOD PUBLIC CloseGripperTestFailed //will fail
            GripperTest.CloseGripper();
            AxUnit.Assert.Equal(TRUE, GripperTest._gripperInterface.gripperOpened);
            AxUnit.Assert.Equal(TRUE, GripperTest._gripperInterface.gripperClosed);
        END_METHOD
    END_CLASS

END_NAMESPACE
