@IsTest
public class MBLogMultipleRecordAccessTest {
    @IsTest
    static void testLogAccess_Success() {
        // Create a user for the User__c lookup
        User u = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];

        // Create dummy IDs to simulate record access
        Id id1 = '001000000000001AAA';
        Id id2 = '001000000000002AAA';

        // Build JSON matching the expected structure
        String jsonRecords =
            '{' +
            '"records": [' +
            '{"Id": "' +
            id1 +
            '"},' +
            '{"Id": "' +
            id2 +
            '"}' +
            ']' +
            '}';

        // Create input wrapper
        MBLogMultipleRecordAccess.InputWrapper wrap = new MBLogMultipleRecordAccess.InputWrapper();
        wrap.RecordsField = jsonRecords;
        wrap.UserId = u.Id;
        wrap.EventDate = System.now();

        List<MBLogMultipleRecordAccess.InputWrapper> inputList = new List<MBLogMultipleRecordAccess.InputWrapper>{
            wrap
        };

        Test.startTest();
        MBLogMultipleRecordAccess.logAccess(inputList);
        Test.stopTest();

        // Validate logs were inserted
        List<Record_Access_Log__c> logs = [
            SELECT User__c, RecordId__c, AccessTime__c
            FROM Record_Access_Log__c
        ];

        System.assertEquals(
            2,
            logs.size(),
            'Two logs should have been created.'
        );
        System.assertEquals(
            u.Id,
            logs[0].User__c,
            'User should match wrapper.'
        );
        System.assertNotEquals(
            null,
            logs[0].RecordId__c,
            'RecordId should not be null.'
        );
    }

    @IsTest
    static void testLogAccess_InvalidJSON() {
        // Build invalid JSON to force exception
        String badJson = '{not_valid_json';

        User u = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];

        MBLogMultipleRecordAccess.InputWrapper wrap = new MBLogMultipleRecordAccess.InputWrapper();
        wrap.RecordsField = badJson;
        wrap.UserId = u.Id;
        wrap.EventDate = System.now();

        Test.startTest();
        MBLogMultipleRecordAccess.logAccess(
            new List<MBLogMultipleRecordAccess.InputWrapper>{ wrap }
        );
        Test.stopTest();

        // Because JSON failed, no logs should be inserted
        List<Record_Access_Log__c> logs = [SELECT Id FROM Record_Access_Log__c];

        System.assertEquals(
            0,
            logs.size(),
            'No logs should be created from invalid JSON.'
        );
    }
}
