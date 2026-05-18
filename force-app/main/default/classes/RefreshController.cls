public with sharing class RefreshController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [
            SELECT Id, Name, Title
            FROM Contact
            WHERE FirstName = 'Ann'
        ];
    }
}
