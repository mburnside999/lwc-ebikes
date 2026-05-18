public class AccountContactInserter implements Database.Batchable<SObject> {
    // Start method: generates the records to be processed in the batch
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id FROM Account LIMIT 1]); // No actual query since we are not querying existing records
    }

    // Execute method: where actual record creation happens
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Account> accountsToInsert = new List<Account>();
        List<Contact> contactsToInsert = new List<Contact>();

        Integer accountIdIncrement = 1000; // Start with the first account ID increment

        // Loop to create 10,000 accounts
        for (Integer i = 0; i < 2000; i++) {
            // Create the Account record
            Account newAccount = new Account(
                Name = 'Synthetic Account ' + (i + 1),
                ebikesaws__ExtAccountId__c = 'ACC' + (accountIdIncrement + i)
            );
            accountsToInsert.add(newAccount);

            // Create 5 Contact records for each Account
            for (Integer j = 0; j < 4; j++) {
                Contact newContact = new Contact(
                    FirstName = 'First' + (i * 5 + j),
                    LastName = 'Last' + (i * 5 + j),
                    AccountId = newAccount.Id // The contact will be associated with the Account
                );
                contactsToInsert.add(newContact);
            }
        }

        // Insert the Accounts and Contacts
        insert accountsToInsert;
        insert contactsToInsert;
    }

    // Finish method: called after all batches are processed
    public void finish(Database.BatchableContext BC) {
        System.debug('Batch process completed.');
    }
}
