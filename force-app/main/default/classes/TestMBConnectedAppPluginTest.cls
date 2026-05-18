@IsTest
private class TestMBConnectedAppPluginTest {
    @IsTest
    static void testAuthorize() {
        // Create a test user (or use existing active one)
        User testUser = [SELECT Id, IsActive FROM User WHERE IsActive=true LIMIT 1];

        Test.startTest();
        MBConnectedAppPlugin plugin = new MBConnectedAppPlugin();
        Auth.InvocationContext ctx; // minimal dummy context
        Boolean authResult = plugin.authorize(testUser.Id, UserInfo.getOrganizationId(), true, ctx);
        Test.stopTest();

        System.assert(authResult == true, 'Expected authorize to return true for active user');
    }

    
}