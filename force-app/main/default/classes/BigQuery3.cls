public class BigQuery3 {
    @AuraEnabled(Cacheable=true)
    public static String getBQ() {
        String results;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'https://mb-bigquery-2c4c1f7e2751.herokuapp.com/bigquery3'
        );
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            results = response.getBody();
            System.debug(results);
        } else
            results = 'Error';
        System.debug(results);
        return results;
    }
}
