global class MBDreamhouseSharingFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterSharingCounts.getSharing(
                'ToolingRestDreamhouse',
                '00D5j000008wzRs',
                'MB Dreamhouse',
                'All'
            );
            // Chain the second fetch
            System.enqueueJob(new MBEcarSharingFetcher());
        } catch (Exception e) {
            System.debug(
                'Error in MBDreamhouseSharingFetcher: ' + e.getMessage()
            );
        }
    }
}
