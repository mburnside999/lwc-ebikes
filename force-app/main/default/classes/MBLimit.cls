global class MBLimit {
    @AuraEnabled
    @InvocableVariable
    public String LimitName;
    @AuraEnabled
    @InvocableVariable
    public Integer MaxValue;
    @AuraEnabled
    @InvocableVariable
    public Integer RemainingValue;
    @AuraEnabled
    @InvocableVariable
    public Boolean Unused;
}