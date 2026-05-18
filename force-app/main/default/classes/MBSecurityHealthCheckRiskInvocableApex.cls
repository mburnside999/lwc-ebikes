global class MBSecurityHealthCheckRiskInvocableApex {
    @InvocableMethod(
        label='Get Health Check Risk Data'
        description='Fetches health check risk data from the Tooling API'
    )
    global static List<List<MBSecurityHealthCheckRisks>> getRisks(
        List<String> criteria
    ) {
        List<List<MBSecurityHealthCheckRisks>> results = new List<List<MBSecurityHealthCheckRisks>>();
        List<MBSecurityHealthCheckRisks> risks = new List<MBSecurityHealthCheckRisks>();

        String baseURL = 'callout:ToolingRest?'; //Named Credential
        System.debug('baseURL=========>' + baseURL);

        String toolingApiEndpoint =
            baseURL +
            'q=SELECT+RiskType,Setting,SettingGroup,OrgValue,StandardValue+FROM+SecurityHealthCheckRisks+where+RiskType=\'HIGH_RISK\'';
        try {
            // Create HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint(toolingApiEndpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');

            // Send the request
            Http http = new Http();
            HttpResponse res = http.send(req);
            // Handle response
            if (res.getStatusCode() == 200) {
                String str = res.getBody();

                Map<String, Object> payload1 = (Map<String, Object>) JSON.deserializeUntyped(
                    res.getBody()
                );

                List<Object> items = (List<Object>) payload1.get('records');
                risks = (List<MBSecurityHealthCheckRisks>) JSON.deserialize(
                    JSON.serialize(items),
                    List<MBSecurityHealthCheckRisks>.class
                );
            } else {
                System.debug(res.getStatus());
                //result.add('Error: ' + res.getStatus() + ' ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            //result.add('Exception: ' + e.getMessage());
        }

        results.add(risks);

        return results;
    }
}
