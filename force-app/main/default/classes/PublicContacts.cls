@RestResource(urlMapping='/PublicContacts/')
global with sharing class PublicContacts {
    @HttpGet
    global static List<Contact> getPublicContacts() {
        // Return up to 10 contacts accessible by the guest user profile
        return [SELECT Id, Name, Email, Phone FROM Contact LIMIT 100];
    }
}
