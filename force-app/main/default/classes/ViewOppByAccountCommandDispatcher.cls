/*
    This example apex class extends Slack.SlashCommandDispatcher and is responsible for
    responding to the Slack slash command registered with the Slack application.

    sample command:
    /apex-find-opp-by-accountid 001xx000001a3f5AAA
*/
public class ViewOppByAccountCommandDispatcher extends Slack.SlashCommandDispatcher {

    public override Slack.ActionHandler invoke(Slack.SlashCommandParameters parameters, Slack.RequestContext context) {
        return Slack.ActionHandler.modal(new Handler(parameters, context));
    }

    public class Handler implements Slack.ModalHandler {

        Slack.SlashCommandParameters parameters;
        Slack.RequestContext context;

        public Handler (Slack.SlashCommandParameters parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }

        public Slack.ModalView call () {
            String commandText = parameters.getText();

            Slack.ViewReference viewReference = Slack.View.view_opportunity_by_account.get();
            if (commandText instanceOf Id) {
                viewReference.setParameter('recordId', commandText);
            } else {
                return MessageModal.getMessageModalView('Error Occurred', 'There was a problem loading the account. AccountId is missing or is invalid.');
            }

            viewReference.setParameter('channelId', context.getchannelId());
            Slack.ModalView modalView = new Slack.ModalView.builder()
                    .viewReference(viewReference)
                    .build();
            return modalView;
        }
    }
  }