global class MBSandboxProcessInvocableApex {
    @InvocableMethod(
        label='Get Sandbox data'
        description='Fetches sandbox data from the Tooling API'
    )
    global static List<List<MBSandboxProcess>> getSandboxes(
        List<String> criteria
    ) {
        String filter = criteria[0];
        List<List<MBSandboxProcess>> results = new List<List<MBSandboxProcess>>();
        List<MBSandboxProcess> sandboxes = new List<MBSandboxProcess>();

        String baseURL = 'callout:ToolingRest?'; //Named Credential
        System.debug('baseURL=========>' + baseURL);

        String toolingApiEndpoint =
            baseURL +
            'q=SELECT+SandboxName,Description,LicenseType,CopyProgress,StartDate,EndDate,ActivatedDate,Status+from+SandboxProcess';
        if ((filter == null) || (filter == 'All') || (filter == '*')) {
            toolingApiEndpoint += '+where+Status=' + '\'1\'+order+by+StartDate';
        } else {
            toolingApiEndpoint +=
                '+where+SandboxName=' +
                '\'' +
                filter +
                '\'+order+by+StartDate';
        }
        System.debug('toolingApiEndpoint=' + toolingApiEndpoint);
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
                System.debug(str);

                Map<String, Object> payload1 = (Map<String, Object>) JSON.deserializeUntyped(
                    res.getBody()
                );

                List<Object> items = (List<Object>) payload1.get('records');
                sandboxes = (List<MBSandboxProcess>) JSON.deserialize(
                    JSON.serialize(items),
                    List<MBSandboxProcess>.class
                );
            } else {
                System.debug(res.getStatus());
                //result.add('Error: ' + res.getStatus() + ' ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            //result.add('Exception: ' + e.getMessage());
        }
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        System.debug('offset = ' + offset);
        for (MBSandboxProcess sb : sandboxes) {
            sb.StartDate = sb.StartDate?.addSeconds(offset / 1000);
            sb.EndDate = sb.EndDate?.addSeconds(offset / 1000);
            sb.ActivatedDate = sb.ActivatedDate?.addSeconds(offset / 1000);
            Date datestarted = sb.StartDate.date();
            Date dateactivated = sb.ActivatedDate?.date();
            Date dateended = sb.EndDate?.date();
            Date today = Date.today();
            sb.ElapsedDaysSinceActivated = dateactivated?.daysBetween(today);
            sb.ElapsedDaysSinceRefreshed = dateended?.daysBetween(today);
        }
        system.debug('filter=' + filter);
        results.add(sandboxes);

        return results;
    }
}
