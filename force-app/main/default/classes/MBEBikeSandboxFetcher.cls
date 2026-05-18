global class MBEBikeSandboxFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterSandbox.getSandboxes(
                'ToolingRest',
                '00D2w00000NK4yO',
                'eBikes',
                'All'
            );
            // Chain the second fetch
            System.enqueueJob(new MBDreamhouseSandboxFetcher());
        } catch (Exception e) {
            System.debug('Error in MBEBikeSandboxFetcher: ' + e.getMessage());
        }
    }
}
