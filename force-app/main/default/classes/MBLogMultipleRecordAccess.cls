public class MBLogMultipleRecordAccess {
    @InvocableMethod(label='Log Accessed Record IDs')
    public static void logAccess(List<InputWrapper> inputs) {
        List<Record_Access_Log__c> logs = new List<Record_Access_Log__c>();

        for (InputWrapper input : inputs) {
            String recordsJson = input.RecordsField;

            try {
                // Parse JSON
                Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(
                    recordsJson
                );

                List<Object> records = (List<Object>) parsed.get('records');

                for (Object recordObj : records) {
                    Map<String, Object> recordMap = (Map<String, Object>) recordObj;
                    String recordId = (String) recordMap.get('Id');

                    if (recordId != null) {
                        logs.add(
                            new Record_Access_Log__c(
                                User__c = input.UserId,
                                RecordId__c = recordId,
                                AccessTime__c = input.EventDate
                            )
                        );
                    }
                }
            } catch (Exception e) {
                System.debug(
                    'Failed to parse event Records JSON: ' + e.getMessage()
                );
            }
        }

        // Insert logs if any were collected
        if (!logs.isEmpty()) {
            insert logs;
        }
    }

    public class InputWrapper {
        @InvocableVariable(required=true)
        public String RecordsField; // raw JSON from ListViewEvent.Records

        @InvocableVariable(required=true)
        public Id UserId;

        @InvocableVariable(required=true)
        public Datetime EventDate;
    }
}
