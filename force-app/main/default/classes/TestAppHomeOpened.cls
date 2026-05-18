/*
    This example test suite is responsible for testing the AppHomeOpened event dispatcher. 
*/
@isTest
public class TestAppHomeOpened {
    
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
    
    @isTest static void testAppHomeOpened() {
        
        // open app home and assert the content
        Slack.TestHarness.Home home = userSession.openAppHome(slackApp);
        System.assertEquals(3, home.getComponentCount());
        Slack.TestHarness.Header header = (Slack.TestHarness.Header)home.getComponent(0, Slack.TestHarness.Header.class);
        System.assertEquals('Welcome to the Apex Slack App Example.', header.getText());
        Slack.TestHarness.Section section = (Slack.TestHarness.Section)home.getComponent(1, Slack.TestHarness.Section.class);
        System.assertEquals('To see how this custom home view was created, see the AppHomeOpened apex class.', section.getText());
        
    }
    
}