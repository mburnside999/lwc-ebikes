public class MBSlackMessenger {
    //C06HN8JGV1T
    //E06J3QVQ265E06J3QVQ265/C06JE0TJ8SU
    public Slack.ChatPostMessageResponse sendMessage(
        String appName,
        String channelId
    ) {
        Slack.App app = Slack.App.ApexSlackApp.get();
        Slack.ChatPostMessageRequest req = Slack.ChatPostMessageRequest.builder()
            .channel('C06HN9J9L85')
            .viewReference(Slack.ViewReference.getViewByName('ExampleView'))
            .build();
        Slack.BotClient client = app.getBotClientForTeam('T06HTLK8JUU');
        return client.chatPostMessage(req);
    }
}
