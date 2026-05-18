global class MBDreamhouseSandboxFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        try {
            MBSecurityCenterSandbox.getSandboxes(
                'ToolingRestDreamhouse',
                '00D5j000008wzRs',
                'MB Dreamhouse',
                'All'
            );
            // Chain the second fetch
            System.enqueueJob(new MBEcarSandboxFetcher());
        } catch (Exception e) {
            System.debug(
                'Error in MBDreamhouseSandboxFetcher: ' + e.getMessage()
            );
        }
    }
}
