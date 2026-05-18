global class MBSecurityCenterSharingCounts {
    global static void getSharing(
        String namedCredential,
        String tenantId,
        String tenantName,
        String criteria
    ) {
        String filter = criteria;
        List<List<MBEntityDefinitionSharing>> results = new List<List<MBEntityDefinitionSharing>>();
        List<MBEntityDefinitionSharing> sharinglist = new List<MBEntityDefinitionSharing>();

        // String baseURL = 'callout:ToolingRest?'; //Named Credential
        // String baseURL = 'callout:ToolingResteBikes2?'; //Named Credential
        String baseUrl = 'callout:' + namedCredential + '?';
        System.debug('baseURL=========>' + baseURL);

        String query =
            'q=SELECT+QualifiedApiName,InternalSharingModel,ExternalSharingModel+' +
            'FROM+EntityDefinition+' +
            'WHERE+defaultcompactlayoutid!=null+and+iscompactlayoutable=true+and+isapextriggerable=true+AND+isCustomizable=true+AND+isProcessEnabled=true';

        String toolingApiEndpoint = baseURL + query;

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
                sharinglist = (List<MBEntityDefinitionSharing>) JSON.deserialize(
                    JSON.serialize(items),
                    List<MBEntityDefinitionSharing>.class
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
        Integer i = 0;
        for (MBEntityDefinitionSharing sb : sharinglist) {
            Date today = Date.today();
            sb.QualifiedApiName = sb.QualifiedApiName;

            if (
                (sb.ExternalSharingModel == 'Read' |
                sb.ExternalSharingModel == 'ReadWrite') &
                !sb.QualifiedApiName.contains('__') &
                // !sb.QualifiedApiName.contains('OB_') &
                !sb.QualifiedApiName.contains('shield_') &
                !sb.QualifiedApiName.contains('sc_ext_') &
                sb.QualifiedApiName != 'EmailMessage' &
                sb.QualifiedApiName != 'DuplicateRecordSet' &
                sb.QualifiedApiName != 'EntityMilestone'
            ) {
                i += 1;
                System.debug('EXTERNAL PUBLIC');
                externalsharing__c es = new externalsharing__c();
                es.RecordProductionDate__c = DateTime.now();
                es.QualifiedAPIName__c = sb.QualifiedApiName;
                es.ExternalSharingModel__c = sb.ExternalSharingModel;
                es.TenantId__c = tenantId;
                es.Tenant__c = tenantName;
                insert es;
            }
        }
        System.debug('Inserted ' + i + ' EXTERNAL sharing rules');
    }
}
