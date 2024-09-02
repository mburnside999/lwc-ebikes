global class BigQuery {
  @InvocableMethod
  public static List<Long> getCommitCount(List<Integer> mylist) {
    Long file_count;
    List<Long> bqresult = new List<Long>();

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'https://mb-bigquery-2c4c1f7e2751.herokuapp.com/bigquery'
    );
    request.setMethod('GET');
    HttpResponse response = http.send(request);

    // If the request is successful, parse the JSON response.
    if (response.getStatusCode() == 200) {
      System.debug(response.getBody());
      // Deserialize the JSON string into collections of primitive data types.
      Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      file_count = (Long) results.get('file_count');
      System.debug('BigQuery file_count=' + file_count);
      bqresult.add(file_count);
    }

    return bqresult;
  }
}
