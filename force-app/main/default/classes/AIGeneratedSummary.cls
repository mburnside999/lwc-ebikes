public with sharing class AIGeneratedSummary {
    @InvocableVariable
    public String AIGeneratedFeedback;
    @InvocableVariable
    public String AIGeneratedSentiment;
    @InvocableVariable
    public String ProductId;

    @InvocableMethod(
        label='Parse AIGeneratedSummary'
        description='Parse AIGeneratedSummary'
    )
    public static List<AIGeneratedSummary> parse(List<String> input) {
        List<AIGeneratedSummary> output = new List<AIGeneratedSummary>();
        // deserialize JSON input to the AIGeneratedSummary class
        output.add(
            (AIGeneratedSummary) JSON.deserializeStrict(
                input[0],
                AIGeneratedSummary.class
            )
        );
        return output;
    }
}
