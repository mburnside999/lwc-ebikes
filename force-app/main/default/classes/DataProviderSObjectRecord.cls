/*
    This example apex class provides details for populating views that display a record.
    For the methods that return a single sobject directly, see usage defined in 'view_contact', 'view_account', and 'view_opportunity.'
    For the method that returns data in a list for an iterator, see usage in 'record_detail_message.'
*/
public class DataProviderSObjectRecord {
    public static List<FieldData> getRecord(String recordId, String objectApiName) {
        Sobject record;

        if (String.isNotBlank(objectApiName)) {
            switch on objectApiName {
                when 'Account' {
                    record = getAccountById(recordId);
                }
                when 'Contact' {
                    record = getContactById(recordId);
                }
                when 'Opportunity' {
                    record = getOpportunityById(recordId);
                }
                when else {
                    System.debug('Record must be an Account, Contact, or Opportunity');
                }
            }
        }

        List<FieldData> fieldsList = new List<FieldData>();
        if (record != null) {
            Map<String, Object> fields = record.getPopulatedFieldsAsMap();

            if (!fields.isEmpty()) {
                for (String key : fields.keySet()) {
                    FieldData fieldData;
                    if (fields.containsKey(key)) {
                        fieldData = new FieldData(key, fields.get(key));
                        fieldsList.add(fieldData);
                    }
                }
            }
        }
        return fieldsList;
    }

    public static Contact getContactById(String recordId) {
        Contact contact;
        try {
            contact = [SELECT Name, Id, Title, Phone, Email, AccountId FROM Contact WHERE Id = :recordId];
            return contact;
        } catch (Exception e) {
            System.debug('An error occurred with querying the Contact record. ' + e.getMessage());
        }
        return contact;
    }

    public static Account getAccountById(String recordId) {
        Account account;
        try {
            account = [SELECT Name, Id FROM Account WHERE Id = :recordId];
        } catch (Exception e) {
            System.debug('An error occurred with querying the Account record. ' + e.getMessage());
        }
        return account;
    }

    public static Opportunity getOpportunityById(String recordId) {
        Opportunity opportunity;
        try {
            opportunity = [SELECT Name, Id, Amount, StageName, CloseDate FROM Opportunity WHERE Id = :recordId];
        } catch (Exception e) {
            System.debug('An error occurred with querying the Opportunity record. ' + e.getMessage());
        }
        return opportunity;
    }
}