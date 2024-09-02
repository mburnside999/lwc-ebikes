public with sharing class AccountController {
  public AccountController() {
  }

  @AuraEnabled(cacheable=true)
  public static List<Account> getAccounts() {
    return [
      SELECT Id, Name, Website, Type
      FROM Account
      WITH SECURITY_ENFORCED
      ORDER BY lastmodifieddate DESC
      LIMIT 3
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<Contact> getContacts(String recordId) {
    return [
      SELECT Id, FirstName, LastName, Account.Name
      FROM Contact
      WHERE AccountId = :recordid
      ORDER BY lastmodifieddate DESC
      LIMIT 3
    ];
  }
}
