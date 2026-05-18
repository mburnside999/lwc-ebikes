/*
    This example apex class extends Slack.ShortcutDispatcher
    It demonstrates how to use the ReactionsGet api method, and how to parse the response for values to use as view params.
*/
public class ShortcutDispatcherReactionsGet extends Slack.ShortcutDispatcher {
    public override Slack.ActionHandler invoke(Slack.ShortcutParameters parameters, Slack.RequestContext context) {
        return Slack.ActionHandler.Modal(new Handler(parameters, context), 'Reactions Get');
    }

    public class Handler implements Slack.ModalHandler {
        Slack.ShortcutParameters parameters;
        Slack.RequestContext context;

        public Handler(Slack.ShortcutParameters parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }

        public Slack.ModalView call() {
            // Name must match the DeveloperName of your SlackApp.
            Slack.App app = Slack.App.ApexSlackApp.get();
            Slack.BotClient botClient = app.getBotClientForTeam(this.context.getTeamId());
            Slack.ReactionsGetRequest req = new Slack.ReactionsGetRequest.builder()
                .channel(this.context.getChannelId())
                .timestamp(this.context.getMessageContext().getTs())
                .build();

            Slack.ReactionsGetResponse response = BotClient.reactionsGet(req);
            Slack.ViewReference viewReference;

            if (response.getError() != null) {
                String errMsg =
                    'The shortcut failed with the error ' +
                    response.getError() +
                    '. Make sure you are using the shortcut in a channel where the bot for the current app is a member.';
                viewReference = Slack.View.message_modal.get();
                viewReference.setParameter('title', 'Shortcut error');
                viewReference.setParameter('message', errMsg);
            } else {
                String messageText = response.getMessage().getText();
                List<Slack.Reaction> reactions = response.getMessage().getReactions();
                Integer reactionsCount = reactions != null ? reactions.size() : 0;

                //TODO support passing List<Slack.Reaction> directly as a view parameter.
                List<Map<String, Object>> reactionsParam = new List<Map<String, Object>>();
                if (reactions != null) {
                    for (Slack.Reaction reaction : reactions) {
                        Map<String, Object> reactionsMap = new Map<String, Object>{ 'name' => reaction.getName(), 'count' => reaction.getCount() };
                        reactionsParam.add(reactionsMap);
                    }
                }

                Map<String, Object> viewData = new Map<String, Object>{ 'reactionsCount' => reactionsCount, 'messageText' => messageText };

                viewReference = Slack.View.message_reactions.get();
                viewReference.setParameter('reaction', reactionsParam);
                viewReference.setParameter('viewData', viewData);
            }

            Slack.ModalView modalView = new Slack.ModalView.builder().viewReference(viewReference).build();
            return modalView;
        }
    }
}