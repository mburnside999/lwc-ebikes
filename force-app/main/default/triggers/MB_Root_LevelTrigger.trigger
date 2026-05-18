trigger MB_Root_LevelTrigger on MB_Root_Level__c(before update) {
    System.debug('================== HBF Demo ========================');
    System.debug('HBF Demo: MB Root Level Object Updated, - Trigger Firing');
    String currentUserName = UserInfo.getName();
    System.debug('HBF Demo: Current user updating record: ' + currentUserName);

    List<MB_Root_Level__c> before = (List<MB_Root_Level__c>) Trigger.old;
    List<MB_Root_Level__c> after = (List<MB_Root_Level__c>) Trigger.new;

    System.debug(
        'HBF Demo: BEFORE==>: Name=' +
            before[0].Name +
            ', f1=' +
            before[0].f1__c +
            ', f2=' +
            before[0].f2__c +
            ', f3=' +
            before[0].f3__c
    );
    System.debug(
        'HBF Demo: AFTER==>: Name=' +
            after[0].Name +
            ', f1=' +
            after[0].f1__c +
            ', f2=' +
            after[0].f2__c +
            ', f3=' +
            after[0].f3__c
    );
}
