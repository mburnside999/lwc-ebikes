global class MBEBikeSharingFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterSharingCounts.getSharing(
                'ToolingRest',
                '00D2w00000NK4yO',
                'eBikes',
                'All'
            );
            // Chain the second fetch
            System.enqueueJob(new MBDreamhouseSharingFetcher());
        } catch (Exception e) {
            System.debug('Error in MBEBikeSharingFetcher: ' + e.getMessage());
        }
    }
}
