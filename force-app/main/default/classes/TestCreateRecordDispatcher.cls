/*
    This example test suite is responsible for testing the CreateRecordCommandDispatcher 
    and the CreateRecordShortcutDispatcher. 
*/
@isTest
public class TestCreateRecordDispatcher {
    
    private static Slack.App slackApp;
    private static Slack.TestHarness testHarness;
    private static Slack.TestHarness.State slackState;
    private static Slack.TestHarness.UserSession userSession;
    
    static {
        // setup test harness and user session
        slackApp = Slack.App.ApexSlackApp.get();
        testHarness = new Slack.TestHarness();
        slackState = testHarness.getNewSlackState();
        userSession = slackState.createUserSession();
    }
    
    private static Slack.TestHarness.Modal openCreateModal(String buttonLabel) {
        // execute the 'apex-create-record' command and assert modal
        userSession.executeSlashCommand('/apex-create-record', slackApp);
        Slack.TestHarness.Modal modal = userSession.getTopModal();
        System.assertEquals('Create Record', modal.getTitle());
        System.assertEquals(2, modal.getComponentCount());
        
        // click the 'Account' button and assert the updated modal 
        modal.getButtonByLabel(buttonLabel).click();
        modal = userSession.getTopModal();
        return modal;
    }
    
    // This test creates an account and verifies it was inserted into the database.
    @isTest 
    static void createAccountCommand() {
        Integer i = [Select count() from Account];
        
        // open the create account modal
        Slack.TestHarness.Modal modal = openCreateModal('Account');
        System.assertEquals('Create Account', modal.getTitle());
        
        // fill out the form data and click submit
        Slack.TestHarness.Input input = modal.getInputByLabel('Name');
        Slack.TestHarness.TextInput textInput = (Slack.TestHarness.TextInput)input.getComponent(Slack.TestHarness.TextInput.class);
        textInput.setValue('Bob');
        modal.submit(); 
        
        // assert the confirmation modal
        modal = userSession.getTopModal();
        System.assertEquals('Record Created', modal.getTitle());
        Slack.TestHarness.Section section = (Slack.TestHarness.Section)modal.getComponent(0, Slack.TestHarness.Section.class);
        System.assertEquals('Your account was created: Bob', section.getText());
        
        // assert db insert
        System.assertEquals(i+1,[Select count() from Account]);
    }
    
    // This test creates a contact and verifies it was inserted into the database.
    @isTest
    static void createContactCommand() {
        Integer i = [Select count() from Contact];
        
        // open the create contact modal
        Slack.TestHarness.Modal modal = openCreateModal('Contact');
        System.assertEquals('Create Contact', modal.getTitle());
        
        // fill out the form data and click submit
        // first name
        Slack.TestHarness.Input input = modal.getInputByLabel('First Name');
        Slack.TestHarness.TextInput textInput = (Slack.TestHarness.TextInput)input.getComponent(Slack.TestHarness.TextInput.class);
        textInput.setValue('Robert');
        // last name
        input = modal.getInputByLabel('Last Name');
        textInput = (Slack.TestHarness.TextInput)input.getComponent(Slack.TestHarness.TextInput.class);
        textInput.setValue('Smith');
        // phone
        input = modal.getInputByLabel('Phone');
        textInput = (Slack.TestHarness.TextInput)input.getComponent(Slack.TestHarness.TextInput.class);
        textInput.setValue('888-555-4444');
        // email
        input = modal.getInputByLabel('Email');
        textInput = (Slack.TestHarness.TextInput)input.getComponent(Slack.TestHarness.TextInput.class);
        textInput.setValue('bobsmith@example.com');
        // submit
        modal.submit();  
        
        // assert the confirmation modal
        modal = userSession.getTopModal();
        System.assertEquals('Record Created', modal.getTitle());
        Slack.TestHarness.Section section = (Slack.TestHarness.Section)modal.getComponent(0, Slack.TestHarness.Section.class);
        System.assertEquals('Your contact was created: Robert', section.getText());
        
        // assert db insert
        System.assertEquals(i+1,[Select count() from Contact]);
        
    }
    
    // This test creates an opportunity and verifies it was inserted into the database.
    @isTest
    static void createOpportunityCommand() {
        Integer i = [Select count() from Opportunity];
        
        // open the create opportunity modal
        Slack.TestHarness.Modal modal = openCreateModal('Opportunity');
        System.assertEquals('Create Opportunity', modal.getTitle());
        
        // fill out the form data and click submit
        // name
        Slack.TestHarness.Input input = modal.getInputByLabel('Name');
        Slack.TestHarness.TextInput textInput = (Slack.TestHarness.TextInput)input.getComponent(Slack.TestHarness.TextInput.class);
        textInput.setValue('Global Media');
        // amount
        input = modal.getInputByLabel('Amount');
        textInput = (Slack.TestHarness.TextInput)input.getComponent(Slack.TestHarness.TextInput.class);
        textInput.setValue('1500.00');
        // stage
        input = modal.getInputByLabel('Stage');
        Slack.TestHarness.SelectInput selectInput = (Slack.TestHarness.SelectInput)input.getComponent(Slack.TestHarness.SelectInput.class);
        selectInput.setValue('Qualification');
        // close date
        input = modal.getInputByLabel('Close Date');
        Slack.TestHarness.DatePicker datePicker = (Slack.TestHarness.DatePicker)input.getComponent(Slack.TestHarness.DatePicker.class);
        datePicker.setValue((Date.today().year()+1) + '-12-31');
        // submit
        modal.submit();  
        
        // assert the confirmation modal
        modal = userSession.getTopModal();
        System.assertEquals('Record Created', modal.getTitle());
        Slack.TestHarness.Section section = (Slack.TestHarness.Section)modal.getComponent(0, Slack.TestHarness.Section.class);
        System.assertEquals('Your opportunity was created: Global Media', section.getText());
        
        // assert db insert
        System.assertEquals(i+1,[Select count() from Opportunity]);
        
    }
    
    // This test verifies the account lookup when adding a contact.
    @isTest
    static void testCreateAccountLookup() {
        // open the create contact modal
        Slack.TestHarness.Modal modal = openCreateModal('Contact');
        System.assertEquals('Create Contact', modal.getTitle());
        
        // click the 'Create Account' button
        modal.getButtonByLabel('Create Account').click();
        
        // fill out the account form
        modal = userSession.getTopModal();
        System.assertEquals('Create Account', modal.getTitle());
        
        // fill out the form data and click submit and close the confirmation modal
        Slack.TestHarness.Input input = modal.getInputByLabel('Name');
        Slack.TestHarness.TextInput textInput = (Slack.TestHarness.TextInput)input.getComponent(Slack.TestHarness.TextInput.class);
        textInput.setValue('LookupAccount');
        modal.submit(); 
        modal = userSession.getTopModal();
        modal.close();
        
        // get the contact form modal again
        modal = userSession.getTopModal();
        System.assertEquals('Create Contact', modal.getTitle());
        
        Slack.TestHarness.Actions actions = (Slack.TestHarness.Actions)modal.getComponentByName('external_select_accounts', Slack.TestHarness.Actions.class);
        Slack.TestHarness.ExternalSelect externalSelect = (Slack.TestHarness.ExternalSelect)actions.getComponentByName('account_lookup', Slack.TestHarness.ExternalSelect.class);
        externalSelect.query('Lookup');
        
    }
    
    // This test runs the create record global shortcut.
    @isTest
    static void testCreateAccountGlobalShortcut() {
        userSession.executeGlobalShortcut('apex-create-record-global', slackApp);
        Slack.TestHarness.Modal modal = userSession.getTopModal();
        System.assertEquals('Create Record', modal.getTitle());
    }
    
    // This test runs the create record message shortcut.
    @isTest
    static void testCreateAccountMessageShortcut() {
        Slack.TestHarness.Message message = userSession.postMessage('Test Message!!');
        userSession.executeMessageShortcut('apex-create-record-message', message, slackApp);
        Slack.TestHarness.Modal modal = userSession.getTopModal();
        System.assertEquals('Create Record', modal.getTitle());
    }
}