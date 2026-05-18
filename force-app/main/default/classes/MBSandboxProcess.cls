global class MBSandboxProcess {
    @AuraEnabled
    @InvocableVariable
    public String SandboxName;
    @AuraEnabled
    @InvocableVariable
    public String Description;
    @AuraEnabled
    @InvocableVariable
    public String LicenseType;
    @AuraEnabled
    @InvocableVariable
    public DateTime EndDate;
    @AuraEnabled
    @InvocableVariable
    public DateTime ActivatedDate;
    @AuraEnabled
    @InvocableVariable
    public DateTime StartDate;
    @AuraEnabled
    @InvocableVariable
    public String Status;
    @AuraEnabled
    @InvocableVariable
    public String StatusString;
    @AuraEnabled
    @InvocableVariable
    public Integer ElapsedDaysSinceActivated;
    @AuraEnabled
    @InvocableVariable
    public Integer ElapsedDaysSinceRefreshed;
    @AuraEnabled
    @InvocableVariable
    public String CopyProgress;
}
