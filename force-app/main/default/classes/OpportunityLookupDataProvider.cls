/*
    This example apex class is responsible for responding to data provider requests
	for Select component. See usage defined in the "view_opportunity_by_account" viewDefinition.
*/
public class OpportunityLookupDataProvider {

    private static final String NO_OPPORTUNITY = 'Account has no Opportunity';
    private static final String MISSING_OR_INCORRECT_ACCOUNT_ID = 'Account Id is missing or is incorrect';

    /*
    	This method shows how to use List<Slack.Option> which will be consumed by the view.
		For this example, we're retrieving all Opportunities by AccountId.
		Return result would be List<String, String>.
	*/
    public static List<Slack.Option> getOpportunitiesByAccount(String accountId) {
        List<Slack.Option> oppOptions;

        if (String.isNotBlank(accountId)) {
            List<Opportunity> opps = queryOpportunities(accountId);
            oppOptions = new List<Slack.Option>();

            if (!opps.isEmpty()) {
                for (Opportunity opp : opps) {
                    Slack.Option oppOption = new Slack.Option(opp.Name, opp.Id);
                    oppOptions.add(oppOption);
                }
            } else {
                oppOptions.add(new Slack.Option(NO_OPPORTUNITY, NO_OPPORTUNITY));
            }
        } else {
            oppOptions = new List<Slack.Option>{new Slack.Option(MISSING_OR_INCORRECT_ACCOUNT_ID, MISSING_OR_INCORRECT_ACCOUNT_ID)};
            System.debug(MISSING_OR_INCORRECT_ACCOUNT_ID);
        }

        return oppOptions;
    }

    /*
    	This method shows how to use List<Slack.OptionGroup> which will be consumed by the view.
		For this example, we're retrieving all Opportunities by AccountId and grouping them by Stage.
		Return result would be Map<String, List<Slack.Option> where String is StageName and List<Slack.Option>
		contains the Opportunity Name and Id.
	*/
    public static List<Slack.OptionGroup> getOpportunitiesByStage(String accountId) {
        List<Slack.OptionGroup> opportunityOptionGroup;

        if (String.isNotBlank(accountId)) {
            List<Opportunity> opportunities = queryOpportunities(accountId);
            opportunityOptionGroup = new List<Slack.OptionGroup>();

            if (!opportunities.isEmpty()) {
                List<Slack.Option> newOptions = new List<Slack.Option>();
                List<Slack.Option> inProgressOptions = new List<Slack.Option>();
                List<Slack.Option> closedOptions = new List<Slack.Option>();

                for (Opportunity opp : opportunities) {
                    switch on opp.StageName {
                        when 'New' {
                            Slack.Option newOption = new Slack.Option(opp.Id, opp.Name);
                            newOptions.add(newOption);
                        }
                        when 'In Progress' {
                            Slack.Option inProgressOption = new Slack.Option(opp.Id, opp.Name);
                            inProgressOptions.add(inProgressOption);
                        }
                        when 'Closed' {
                            Slack.Option closedOption = new Slack.Option(opp.Id, opp.Name);
                            closedOptions.add(closedOption);
                        }
                    }
                }

                Slack.OptionGroup newOptionGroup = new Slack.OptionGroup('New Opportunities', newOptions);
                opportunityOptionGroup.add(newOptionGroup);
                Slack.OptionGroup inProgressOptionGroup = new Slack.OptionGroup('In Progress Opportunities', inProgressOptions);
                opportunityOptionGroup.add(inProgressOptionGroup);
                Slack.OptionGroup closedOptionGroup = new Slack.OptionGroup('Closed Opportunities', closedOptions);
                opportunityOptionGroup.add(closedOptionGroup);

            } else {
                opportunityOptionGroup.add(getEmptyOptionGroup());
            }
        } else {
            opportunityOptionGroup.add(getEmptyOptionGroup());
            System.debug(MISSING_OR_INCORRECT_ACCOUNT_ID);
        }

        return opportunityOptionGroup;
    }

    private static List<Opportunity> queryOpportunities(Id accountId) {
        List<Opportunity> opportunities = new List<Opportunity>();

        try {
            if (String.isNotBlank(accountId)) {
                opportunities = [SELECT Id,
                                    Name,
                                    StageName
                                FROM Opportunity
                                WHERE AccountId = :accountId
                                WITH SECURITY_ENFORCED
                                LIMIT 10];
            }
        } catch (Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }

        return opportunities;
    }

    private static Slack.OptionGroup getEmptyOptionGroup() {
        Slack.OptionGroup emptyOptionGroup = new Slack.OptionGroup(NO_OPPORTUNITY, new List<Slack.Option>());
        return emptyOptionGroup;
    }
}