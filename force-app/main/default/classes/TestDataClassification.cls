/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestDataClassification {
    static testMethod void testApiEventPositiveTestCase() {
        // set up our event and its field values
        ApiEvent testEvent = new ApiEvent();
        testEvent.QueriedEntities = 'Contact';
        testEvent.Query = 'select firstname from contact';
        testEvent.RowsProcessed = 2001;

        // test that the Apex returns true for this event
        DataClassification eventCondition = new DataClassification();
        System.assert(!eventCondition.evaluate(testEvent));
    }

    /**
     * Positive test case 2: If a ReportEvent has Lead as a queried entity and more than 2000 rows
     * processed, then the evaluate method of our policy's Apex should return true.
     **/
    static testMethod void testReportEventPositiveTestCase() {
        // set up our event and its field values
        ReportEvent testEvent = new ReportEvent();
        testEvent.QueriedEntities = 'Contact';
        testEvent.ColumnHeaders = 'FirstName';
        testEvent.Operation='ReportExported'; 
        testEvent.RowsProcessed = 2001;

        // test that the Apex returns true for this event
        DataClassification eventCondition = new DataClassification();
        System.assert(!eventCondition.evaluate(testEvent));
    }

    /**
     * Positive test case 3: If a ListViewEvent has Lead as a queried entity and more than 2000 rows
     * processed, then the evaluate method of our policy's Apex should return true.
     **/
    static testMethod void testListViewEventPositiveTestCase() {
        // set up our event and its field values
        ListViewEvent testEvent = new ListViewEvent();
        testEvent.QueriedEntities = 'Contact';
        testEvent.ColumnHeaders = 'Firstname';
        testEvent.RowsProcessed = 2001;

        // test that the Apex returns true for this event
        DataClassification eventCondition = new DataClassification();
        System.assert(!eventCondition.evaluate(testEvent));
    }
}
