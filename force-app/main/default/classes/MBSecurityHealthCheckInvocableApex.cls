global class MBSecurityHealthCheckInvocableApex {
    @InvocableMethod(
        label='Get Health Check Score'
        description='Fetches health check score from Tooling API'
    )
    global static List<MBSecurityHealthCheck> getScore(List<String> criteria) {
        List<MBSecurityHealthCheck> results = new List<MBSecurityHealthCheck>();
        String baseURL = 'callout:ToolingRest?'; //Named Credential
        System.debug('baseURL=========>' + baseURL);

        // String toolingApiEndpoint =
        //     URL.getOrgDomainUrl().toExternalForm() +
        //     '/services/data/v59.0/tooling/query/?q=SELECT+CustomBaselineId,DurableId,Score+FROM+SecurityHealthCheck';
        String toolingApiEndpoint =
            baseURL +
            'q=SELECT+CustomBaselineId,DurableId,Score+FROM+SecurityHealthCheck';
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
                System.debug(payload1);
                List<Object> items = (List<Object>) payload1.get('records');
                results = (List<MBSecurityHealthCheck>) JSON.deserialize(
                    JSON.serialize(items),
                    List<MBSecurityHealthCheck>.class
                );
            } else {
                System.debug(res.getStatus());
                //result.add('Error: ' + res.getStatus() + ' ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            //result.add('Exception: ' + e.getMessage());
        }

        //results.add(risks);

        return results;
    }
}