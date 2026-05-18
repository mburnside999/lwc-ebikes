global class MBEBikeHCRiskFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterHCRisks.getHCHighRisks(
                'ToolingRest',
                '00D2w00000NK4yO',
                'eBikes',
                'All'
            );
            // Chain the second fetch
            System.enqueueJob(new MBDreamhouseHCRiskFetcher());
        } catch (Exception e) {
            System.debug('Error in MBEBikeHCRiskFetcher: ' + e.getMessage());
        }
    }
}
