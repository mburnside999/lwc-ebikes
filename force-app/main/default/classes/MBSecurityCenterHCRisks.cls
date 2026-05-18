global class MBSecurityCenterHCRisks {
    global static void getHCHighRisks(
        String namedCredential,
        String tenantId,
        String tenantName,
        String criteria
    ) {
        String filter = criteria;
        List<List<MBSecurityHealthCheckRisks>> results = new List<List<MBSecurityHealthCheckRisks>>();
        List<MBSecurityHealthCheckRisks> risks = new List<MBSecurityHealthCheckRisks>();

        // String baseURL = 'callout:ToolingRest?'; //Named Credential
        // String baseURL = 'callout:ToolingResteBikes2?'; //Named Credential
        String baseUrl = 'callout:' + namedCredential + '?';
        System.debug('baseURL=========>' + baseURL);

        String toolingApiEndpoint =
            baseURL +
            // 'q=SELECT+RiskType,Setting,SettingGroup,OrgValue,StandardValue+FROM+SecurityHealthCheckRisks+where+RiskType=\'HIGH_RISK\'';
            'q=SELECT+Score,+DurableId,+(SELECT+Setting,+RiskType,+SettingRiskCategory,+StandardValue,+OrgValue,+SecurityHealthCheckId+FROM+SecurityHealthCheckRisk+WHERE+SettingRiskCategory+IN+(\'HIGH_RISK\',\'MEDIUM_RISK\')+AND+RiskType!=\'MEETS_STANDARD\')+FROM+SecurityHealthCheck+ORDER+BY+DurableId+DESC+LIMIT+1';

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
                // System.debug(str);

                Map<String, Object> payload1 = (Map<String, Object>) JSON.deserializeUntyped(
                    res.getBody()
                );

                List<Object> items = (List<Object>) payload1.get('records');

                String firstHealthCheckRecord = JSON.serialize(items[0]);
                Map<string, object> firstHealthCheckRecordMap = (Map<string, object>) JSON.deserializeUntyped(
                    firstHealthCheckRecord
                );

                Object SecurityHealthCheckRisk = (Object) firstHealthCheckRecordMap.get(
                    'SecurityHealthCheckRisk'
                );

                System.debug(
                    'SecurityHealthCheckRisk ' + SecurityHealthCheckRisk
                );

                Map<string, object> securityHealthCheckRiskMap = (Map<string, object>) JSON.deserializeUntyped(
                    JSON.serialize(SecurityHealthCheckRisk)
                );

                List<Object> riskitems = (List<Object>) securityHealthCheckRiskMap.get(
                    'records'
                );

                System.debug('riskitems ' + riskitems);

                risks = (List<MBSecurityHealthCheckRisks>) JSON.deserialize(
                    JSON.serialize(riskitems),
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
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        System.debug('offset = ' + offset);

        for (MBSecurityHealthCheckRisks risk : risks) {
            System.debug(risk);
            HealthCheckRisk__c hcr = new HealthCheckRisk__c();
            hcr.RiskType__c = risk.SettingRiskCategory;
            hcr.OrgValue__c = risk.OrgValue;
            hcr.TenantId__c = tenantId;
            hcr.OrgSetting__c = risk.Setting;
            hcr.RecordProductionDate__c = DateTime.now();
            hcr.Tenant__c = tenantName;
            insert hcr;
        }
    }
}
