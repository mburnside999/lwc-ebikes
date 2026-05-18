global class MBSecurityCenterDailySandboxFetcher implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Start with the first sandbox fetch
        System.enqueueJob(new MBEBikeSandboxFetcher());
    }
}
