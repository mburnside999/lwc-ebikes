public class WinePredictionCallout {
    @future(callout=true)
    public static void makeCallout(Set<id> wineSet) {
        System.debug('in makeCallout wineSet=' + wineSet);
        String endpoint = 'https://mb-ml-wine-classifier-aed7c8be3155.herokuapp.com/wines';
        String requestUrl = endpoint;

        List<Wines__c> winerecords = [
            SELECT
                Id,
                qualitative_ml_prediction__c,
                Name,
                alcohol__c,
                chlorides__c,
                citric_acid__c,
                density__c,
                fixed_acidity__c,
                free_sulfur_dioxide__c,
                pH__c,
                residual_sugar__c,
                sulphates__c,
                total_sulfur_dioxide__c,
                volatile_acidity__c,
                quality__c
            FROM wines__c
            WHERE id = :wineSet
        ];

        for (Wines__c winerecord : winerecords) {
            // Create a JSON payload
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('fixed_acidity__c', winerecord.fixed_acidity__c);
            requestBody.put(
                'volatile_acidity__c',
                winerecord.volatile_acidity__c
            );
            requestBody.put('citric_acid__c', winerecord.citric_acid__c);
            requestBody.put('residual_sugar__c', winerecord.residual_sugar__c);
            requestBody.put('chlorides__c', winerecord.chlorides__c);
            requestBody.put(
                'free_sulfur_dioxide__c',
                winerecord.free_sulfur_dioxide__c
            );
            requestBody.put(
                'total_sulfur_dioxide__c',
                winerecord.total_sulfur_dioxide__c
            );
            requestBody.put('density__c', winerecord.density__c);
            requestBody.put('sulphates__c', winerecord.sulphates__c);
            requestBody.put('pH__c', winerecord.pH__c);
            requestBody.put('alcohol__c', winerecord.alcohol__c);

            String jsonPayload = JSON.serialize(requestBody);

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(requestUrl);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(jsonPayload);

            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                WinePredictionResponse wpr = (WinePredictionResponse) JSON.deserialize(
                    response.getBody(),
                    WinePredictionResponse.class
                );
                winerecord.qualitative_ml_prediction__c = wpr.result;
                //return response.getBody();
            } else {
                winerecord.qualitative_ml_prediction__c = 'callout ERROR';
            }
            update winerecords;
        }
    }

    public class WinePredictionResponse {
        public String result { get; set; }
    }
}
