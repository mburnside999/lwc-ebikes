global class MBDreamhouseHCRiskFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterHCRisks.getHCHighRisks(
                'ToolingRestDreamhouse',
                '00D5j000008wzRs',
                'MB Dreamhouse',
                'All'
            );
            // Chain the second fetch
            System.enqueueJob(new MBEcarHCRiskFetcher());
        } catch (Exception e) {
            System.debug(
                'Error in MBDreamhouseHCRiskFetcher: ' + e.getMessage()
            );
        }
    }
}
