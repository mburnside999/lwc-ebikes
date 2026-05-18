// Custom ConnectedAppPlugin example class
global class MBConnectedAppPlugin extends Auth.ConnectedAppPlugin {

    // Authorize method override - simple logic allowing access if user is active
    global override Boolean authorize(Id userId, Id connectedAppId, Boolean isAdminApproved, Auth.InvocationContext context) {
        User u = [SELECT Id, IsActive FROM User WHERE Id = :userId];
        System.debug('User='+u);
        System.debug('Context='+context);
        System.debug('isAdminApproved='+isAdminApproved);
        return u.IsActive;
    }

   
}