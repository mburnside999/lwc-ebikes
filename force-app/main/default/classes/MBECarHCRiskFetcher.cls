global class MBECarHCRiskFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterHCRisks.getHCHighRisks(
                'ToolingResteCars',
                '00D5j00000Ae9dn',
                'MB-Cars',
                'All'
            );
            System.enqueueJob(new MBEBike2HCRiskFetcher());
        } catch (Exception e) {
            System.debug('Error in MBECarHCRiskFetcher: ' + e.getMessage());
        }
    }
}
