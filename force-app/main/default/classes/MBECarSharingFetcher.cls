global class MBECarSharingFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterSharingCounts.getSharing(
                'ToolingResteCars',
                '00D5j00000Ae9dn',
                'MB-Cars',
                'All'
            );
            System.enqueueJob(new MBEBike2SharingFetcher());
        } catch (Exception e) {
            System.debug('Error in MBECarSharingFetcher: ' + e.getMessage());
        }
    }
}
