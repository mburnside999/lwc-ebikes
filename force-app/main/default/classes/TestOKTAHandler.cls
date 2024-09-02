@isTest
private class TestOKTAHandler {
    static testMethod void testApiEventPositiveTestCase() {
        //OKTA_AuthProvider_Handler
        // set up our event and its field values
        ApiEvent testEvent = new ApiEvent();
        testEvent.QueriedEntities = 'Contact';
        testEvent.Query = 'select firstname from contact';
        testEvent.RowsProcessed = 2001;

        // test that the Apex returns true for this event
        DataClassification eventCondition = new DataClassification();
        System.assert(!eventCondition.evaluate(testEvent));
    }
}
