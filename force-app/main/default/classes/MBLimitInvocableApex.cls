global class MBLimitInvocableApex {
    @InvocableMethod(
        label='Get Limit data'
        description='Fetches limit data from the REST API'
    )
    global static List<List<MBLimit>> getLimits(List<String> criteria) {
        String filterUsed = criteria[0];
        List<List<MBLimit>> results = new List<List<MBLimit>>();
        List<MBLimit> limits = new List<MBLimit>();

        String baseURL = 'callout:RESTAPI'; //Named Credential
        System.debug('baseURL=========>' + baseURL);

        String restAPIEndpoint = baseURL + '/limits';
        try {
            // Create HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint(restAPIEndpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');

            // Send the request
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug(res);
            // Handle response
            if (res.getStatusCode() == 200) {
                String str = res.getBody();
                System.debug(str);

                Map<String, Object> payload1 = (Map<String, Object>) JSON.deserializeUntyped(
                    res.getBody()
                );

                for (String lim : payload1.keySet()) {
                    System.debug('Processing ' + lim);
                    Map<String, Object> limitmap = (Map<String, Object>) payload1.get(
                        lim
                    );
                    System.debug(limitmap);
                    Integer maxval = (Integer) limitmap.get('Max');
                    Integer remainingval = (Integer) limitmap.get('Remaining');

                    MBLimit mblimit = new MBLimit();
                    mblimit.LimitName = lim;
                    mblimit.MaxValue = maxval;
                    mblimit.RemainingValue = remainingval;
                    mblimit.Unused = (remainingval == maxval ? true : false);
                    if ((filterUsed == 'Used') & (!mblimit.Unused)) {
                        limits.add(mblimit);
                    }
                }
            } else {
                System.debug(res.getStatus());
                //result.add('Error: ' + res.getStatus() + ' ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            //result.add('Exception: ' + e.getMessage());
        }

        results.add(limits);

        return results;
    }
}
