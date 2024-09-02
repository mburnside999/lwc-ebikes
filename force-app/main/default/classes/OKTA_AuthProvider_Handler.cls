global class OKTA_AuthProvider_Handler implements Auth.RegistrationHandler {
    global User createUser(Id portalId, Auth.UserData data) {
        return [SELECT Id FROM User WHERE username = 'mburnside@dxdo2023.demo'];
    }
    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
    }
}
