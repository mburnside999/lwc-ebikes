/*
	This example test suite is responsible for testing the OpportunityLookupDataProvider.
*/
@isTest
public class TestOpportunityLookupDataProvider {

    // This test runs the OpportunityLookupProvider with an account with a single opportunity.
    @isTest
    static void testSingleOpportunity(){
        // create new account and opportunity records
        Test.startTest();
        Account account = new Account(Name='Joe Co');
        insert account;
        Opportunity opportunity = new Opportunity(
            Name='Acme Co.',
            Amount=50000.00,
            StageName='Qualification',
            CloseDate=Date.today()+30,
            AccountId=account.Id
        );
        insert opportunity;
        Test.stopTest();
        
        List<Slack.Option> options = OpportunityLookupDataProvider.getOpportunitiesByAccount(account.Id);
        System.assertEquals(1, options.size());
        System.assertEquals(opportunity.Name, options.get(0).getText());
        System.assertEquals(opportunity.Id, options.get(0).getValue());
    }
    
    // This test runs the OpportunityLookupProvider with an account with multiple opportunities.
    @isTest
    static void testMultipleOpportunity(){
        // create new account and opportunity records
        Test.startTest();
        Account account = new Account(Name='Joe Co');
        insert account;
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Name='Acme Co.',
                Amount=50000.00,
                StageName='Qualification',
                CloseDate=Date.today()+30,
                AccountId=account.Id
            ),
            new Opportunity(
                Name='Global Media Co.',
                Amount=50000.00,
                StageName='Qualification',
                CloseDate=Date.today()+30,
                AccountId=account.Id
            )
        };
        insert opps;
        Test.stopTest();
        
        List<Slack.Option> options = OpportunityLookupDataProvider.getOpportunitiesByAccount(account.Id);
        System.assertEquals(2, options.size());
        System.assertEquals(opps[0].Name, options.get(0).getText());
        System.assertEquals(opps[0].Id, options.get(0).getValue());
        System.assertEquals(opps[1].Name, options.get(1).getText());
        System.assertEquals(opps[1].Id, options.get(1).getValue());
    }
    
    // This test runs the OpportunityLookupProvider with an account with no opportunity.
    @isTest
    static void testNoOpportunity(){
        // create new account record
        Test.startTest();
        Account account = new Account(Name='Joe Co');
        insert account;
        Test.stopTest();
        List<Slack.Option> options = OpportunityLookupDataProvider.getOpportunitiesByAccount(account.Id);
        System.assertEquals(1, options.size());
        System.assertEquals('Account has no Opportunity', options.get(0).getText());
        System.assertEquals('Account has no Opportunity', options.get(0).getValue());
    }
    
    // This test runs the OpportunityLookupProvider with a blank value.
    @isTest
    static void testBlankValue() {
        List<Slack.Option> options = OpportunityLookupDataProvider.getOpportunitiesByAccount('');
        System.assertEquals(1, options.size());
        System.assertEquals('Account Id is missing or is incorrect', options.get(0).getText());
        System.assertEquals('Account Id is missing or is incorrect', options.get(0).getValue());
    }
    
    // This test runs the OpportunityLookupProvider with a null value.
    @isTest
    static void testNullValue() {
        List<Slack.Option> options = OpportunityLookupDataProvider.getOpportunitiesByAccount(null);
        System.assertEquals(1, options.size());
        System.assertEquals('Account Id is missing or is incorrect', options.get(0).getText());
        System.assertEquals('Account Id is missing or is incorrect', options.get(0).getValue());
    }
    
}