global class MBDetectHighVolumeAccessTSP implements TxnSecurity.EventCondition {
    // Get threshold from Custom Metadata with fallback
    private static Integer getThreshold() {
        Record_Access_Setting__mdt config = Record_Access_Setting__mdt.getInstance(
            'Default'
        );
        if (config != null && config.Threshold__c != null) {
            return Integer.valueOf(config.Threshold__c);
        }
        return 10000; // fallback
    }

    global Boolean evaluate(SObject event) {
        if (event == null) {
            System.debug('Event is null');
            return false;
        }

        Id userId;
        Datetime eventDate;

        // Handle ListViewEvent
        if (event instanceof ListViewEvent) {
            ListViewEvent e = (ListViewEvent) event;

            userId = e.UserId;
            eventDate = e.EventDate;
            if (userId == null || eventDate == null)
                return false;

            Datetime windowStart = eventDate.addHours(-24);

            // Count unique record accesses in 24 hours
            Set<String> uniqueRecordIds = new Set<String>();

            for (Record_Access_Log__c log : [
                SELECT RecordId__c
                FROM Record_Access_Log__c
                WHERE User__c = :userId AND AccessTime__c >= :windowStart
            ]) {
                uniqueRecordIds.add(log.RecordId__c);
            }

            return uniqueRecordIds.size() > getThreshold();
        }

        // Handle ReportEvent (export-style event)
        if (event instanceof ReportEvent) {
            ReportEvent e = (ReportEvent) event;

            // Ignore all other ReportEvent types
            if (e.Operation != 'ReportExported') {
                return false;
            }
            userId = e.UserId;
            eventDate = e.EventDate;
            if (userId == null || eventDate == null)
                return false;

            Datetime windowStart = eventDate.addHours(-24);

            // Sum exported records from logs
            AggregateResult ar = [
                SELECT SUM(TotalRecords__c) total
                FROM Record_Export_Log__c
                WHERE User__c = :userId AND ExportTime__c >= :windowStart
            ];

            Double exported = (Double) ar.get('total');
            if (exported == null)
                exported = 0;

            return exported > getThreshold();
        }

        System.debug('Unsupported event type.');
        return false;
    }
}
