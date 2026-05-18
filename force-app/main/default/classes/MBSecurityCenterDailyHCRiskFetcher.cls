global class MBSecurityCenterDailyHCRiskFetcher implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Start with the first sandbox fetch
        System.enqueueJob(new MBEBikeHCRiskFetcher());
    }
}
