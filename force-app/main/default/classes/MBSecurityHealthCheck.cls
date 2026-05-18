global class MBSecurityHealthCheck {
    @AuraEnabled
    @InvocableVariable
    public String CustomBaselineId;
    @AuraEnabled
    @InvocableVariable
    public String DurableId;
    @AuraEnabled
    @InvocableVariable
    public String Score;
}