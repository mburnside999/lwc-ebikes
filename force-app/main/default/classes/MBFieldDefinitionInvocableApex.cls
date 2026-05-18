global class MBFieldDefinitionInvocableApex {
    @InvocableMethod(
        label='Get Field Security and Compliance Data'
        description='Fetches field security and compliance data from the Tooling API'
    )
    global static List<List<MBFieldDefinition>> getFieldSecurityAndCompliance(
        List<String> criteria
    ) {
        List<List<MBFieldDefinition>> results = new List<List<MBFieldDefinition>>();
        List<MBFieldDefinition> fielddefs = new List<MBFieldDefinition>();

        String baseURL = 'callout:ToolingRest?'; //Named Credential
        System.debug('baseURL=========>' + baseURL);

        String toolingApiEndpoint =
            baseURL +
            'q=SELECT+Id,DeveloperName,QualifiedApiname,EntityDefinitionId,DurableId,Description,SecurityClassification,ComplianceGroup,EntityDefinition.QualifiedApiName+FROM+FieldDefinition+WHERE+EntityDefinition.QualifiedApiName+in+(\'Account\',\'Contact\',\'Lead\')+AND+SecurityClassification!=NULL+ORDER+BY+EntityDefinitionId';
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

                Map<String, Object> payload1 = (Map<String, Object>) JSON.deserializeUntyped(
                    res.getBody()
                );

                List<Object> items = (List<Object>) payload1.get('records');
                fielddefs = (List<MBFieldDefinition>) JSON.deserialize(
                    JSON.serialize(items),
                    List<MBFieldDefinition>.class
                );
            } else {
                System.debug(res.getStatus());
                //result.add('Error: ' + res.getStatus() + ' ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            //result.add('Exception: ' + e.getMessage());
        }

        results.add(fielddefs);
        System.debug(results);
        return results;
    }
}
