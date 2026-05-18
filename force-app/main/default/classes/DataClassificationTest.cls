@IsTest
private class DataClassificationTest {
    // Test method to check if the evaluate method returns true when an ApiEvent contains a confidential field
    @IsTest
    static void testEvaluate_ApiEvent_WithConfidentialField() {
        // Create a new ApiEvent instance
        ApiEvent event = new ApiEvent();
        // Set the QueriedEntities and Query properties of the event
        event.QueriedEntities = 'Contact';
        event.Query = 'SELECT Id, MobilePhone FROM Contact';

        // Create an instance of the DataClassification class with the fake provider
        DataClassification classifier = new DataClassification();
        // Call the evaluate method and store the result
        Boolean result = classifier.evaluate(event);

        // Assert that the result is true, as the event contains a confidential field ('SSN')
        System.assertEquals(true, result);
    }

    // Test method to check if the evaluate method returns false when an ApiEvent does not contain a confidential field
    @IsTest
    static void testEvaluate_ApiEvent_WithoutConfidentialField() {
        // Create a new ApiEvent instance
        ApiEvent event = new ApiEvent();
        // Set the QueriedEntities and Query properties of the event
        event.QueriedEntities = 'Contact';
        event.Query = 'SELECT Id  FROM Contact';

        // Create an instance of the DataClassification class with the fake provider
        DataClassification classifier = new DataClassification();
        // Call the evaluate method and store the result
        Boolean result = classifier.evaluate(event);

        // Assert that the result is false, as the event does not contain a confidential field
        System.assertEquals(false, result);
    }

    // Test method to check if the evaluate method returns true when a ReportEvent is an export operation and contains a confidential field
    @IsTest
    static void testEvaluate_ReportEvent_WithExport() {
        // Create a new ReportEvent instance
        ReportEvent event = new ReportEvent();
        // Set the QueriedEntities, ColumnHeaders, and Operation properties of the event
        event.QueriedEntities = 'Contact';
        event.ColumnHeaders = 'MobilePhone';
        event.Operation = 'ReportExported';

        // Create an instance of the DataClassification class with the fake provider
        DataClassification classifier = new DataClassification();
        // Call the evaluate method and store the result
        Boolean result = classifier.evaluate(event);

        // Assert that the result is true, as the event is an export operation and contains a confidential field ('Mobile')
        System.assertEquals(true, result);
    }

    // Test method to check if the evaluate method returns false when a ReportEvent is not an export operation, even if it contains a confidential field
    @IsTest
    static void testEvaluate_ReportEvent_NonExport() {
        // Create a new ReportEvent instance
        ReportEvent event = new ReportEvent();
        // Set the QueriedEntities, ColumnHeaders, and Operation properties of the event
        event.QueriedEntities = 'Contact';
        event.ColumnHeaders = 'MobilePhone';
        event.Operation = 'ReportViewed';

        // Create an instance of the DataClassification class with the fake provider
        DataClassification classifier = new DataClassification();
        // Call the evaluate method and store the result
        Boolean result = classifier.evaluate(event);

        // Assert that the result is false, as the event is not an export operation
        System.assertEquals(false, result);
    }

    // Test method to check if the evaluate method returns true when a ListViewEvent contains a confidential field
    @IsTest
    static void testEvaluate_ListViewEvent_WithConfidentialField() {
        // Create a new ListViewEvent instance
        ListViewEvent event = new ListViewEvent();
        // Set the QueriedEntities and ColumnHeaders properties of the event
        event.QueriedEntities = 'Contact';
        event.ColumnHeaders = 'MobilePhone';

        // Create an instance of the DataClassification class with the fake provider
        DataClassification classifier = new DataClassification();
        // Call the evaluate method and store the result
        Boolean result = classifier.evaluate(event);

        // Assert that the result is true, as the event contains a confidential field ('SSN')
        System.assertEquals(true, result);
    }

    // Test method to check if the evaluate method returns false when a ListViewEvent does not contain a confidential field
    @IsTest
    static void testEvaluate_ListViewEvent_WithoutConfidentialField() {
        // Create a new ListViewEvent instance
        ListViewEvent event = new ListViewEvent();
        // Set the QueriedEntities and ColumnHeaders properties of the event
        event.QueriedEntities = 'Account';
        event.ColumnHeaders = 'Id';

        // Create an instance of the DataClassification class with the fake provider
        DataClassification classifier = new DataClassification();
        // Call the evaluate method and store the result
        Boolean result = classifier.evaluate(event);

        // Assert that the result is false, as the event does not contain a confidential field
        System.assertEquals(false, result);
    }

    // Test method to check if the evaluate method returns true when the input event is null
    @IsTest
    static void testEvaluate_NullEvent() {
        // Create an instance of the DataClassification class with the fake provider
        DataClassification classifier = new DataClassification();
        // Call the evaluate method with a null input and store the result
        Boolean result = classifier.evaluate(null);

        // Assert that the result is true, as the input event is null
        System.assertEquals(true, result);
    }

    // Test method to check if the evaluate method returns true when the input event is of an unknown type
    @IsTest
    static void testEvaluate_UnknownEventType() {
        // Create a dummy Account instance
        Account dummy = new Account(Name = 'Test');

        // Create an instance of the DataClassification class with the fake provider
        DataClassification classifier = new DataClassification();
        // Call the evaluate method with an unknown event type (Account) and store the result
        Boolean result = classifier.evaluate(dummy);

        // Assert that the result is true, as the input event is of an unknown type
        System.assertEquals(true, result);
    }
}
