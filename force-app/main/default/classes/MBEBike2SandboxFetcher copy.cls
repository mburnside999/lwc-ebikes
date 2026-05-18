global class MBEBike2HCRiskFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterHCRisks.getHCHighRisks(
                'ToolingResteBikes2',
                '00Dd2000008ye2w',
                'eBikes 2.0',
                'All'
            );
        } catch (Exception e) {
            System.debug('Error in MBEBike2HCRiskFetcher: ' + e.getMessage());
        }
    }
}
