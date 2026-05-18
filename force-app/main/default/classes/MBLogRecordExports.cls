public class MBLogRecordExports {
    @InvocableMethod(label='Log Record Exports')
    public static void logAccess(List<InputWrapper> inputs) {
        // If no inputs, exit
        if (inputs == null || inputs.isEmpty()) {
            return;
        }

        // Get only the last event
        InputWrapper lastInput = inputs[inputs.size() - 1];

        try {
            Record_Export_Log__c logRecord = new Record_Export_Log__c(
                User__c = lastInput.UserId,
                QueriedEntities__c = lastInput.QueriedEntities,
                TotalRecords__c = lastInput.RowsProcessed,
                ExportTime__c = lastInput.EventDate
            );

            insert logRecord;
        } catch (Exception e) {
            System.debug(
                'Failed to parse event Records JSON: ' + e.getMessage()
            );
        }
    }

    public class InputWrapper {
        @InvocableVariable(required=true)
        public String QueriedEntities;

        @InvocableVariable(required=true)
        public Double RowsProcessed;

        @InvocableVariable(required=true)
        public Id UserId;

        @InvocableVariable(required=true)
        public Datetime EventDate;
    }
}
