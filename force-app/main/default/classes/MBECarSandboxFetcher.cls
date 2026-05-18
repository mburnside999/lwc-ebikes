global class MBECarSandboxFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterSandbox.getSandboxes(
                'ToolingResteCars',
                '00D5j00000Ae9dn',
                'MB-Cars',
                'All'
            );
            System.enqueueJob(new MBEBike2SandboxFetcher());
        } catch (Exception e) {
            System.debug('Error in MBECarSandboxFetcher: ' + e.getMessage());
        }
    }
}
