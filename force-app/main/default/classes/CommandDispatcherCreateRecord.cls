/*
    This example apex class extends Slack.SlashCommandDispatcher and is responsible for
    responding to the Slack slash command (ie. apex-create-record) registered with the Slack application.
*/
public class CommandDispatcherCreateRecord extends Slack.SlashCommandDispatcher {
    public override Slack.ActionHandler invoke(Slack.SlashCommandParameters parameters, Slack.RequestContext context) {
        // The slack action handler should immediately be returned.
        return Slack.ActionHandler.modal(new Handler(parameters, context), 'Create Record');
    }

    public class Handler implements Slack.ModalHandler {
        Slack.SlashCommandParameters parameters;
        Slack.RequestContext context;

        public Handler(Slack.SlashCommandParameters parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }

        public Slack.ModalView call() {
            // Returns the modal view for the 'create_record' view definition.
            Slack.ViewReference viewReference = Slack.View.create_record.get();
            Slack.ModalView modalView = new Slack.ModalView.builder().viewReference(viewReference).build();
            return modalView;
        }
    }
}