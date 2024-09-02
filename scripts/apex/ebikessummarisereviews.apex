// get a Product to be the Prompt input, any one will do - lets choose the first
Product__c product = [
    SELECT id, name, product_family__c, msrp__c
    FROM Product__c
    WHERE name = 'DYNAMO X4'
    LIMIT 1
];
System.debug(product);

// Build the Request
List<SummarizeCustomerFeedbackPromptExtension.Request> requests = new List<SummarizeCustomerFeedbackPromptExtension.Request>();
SummarizeCustomerFeedbackPromptExtension.Request request = new SummarizeCustomerFeedbackPromptExtension.Request();
request.Bike = product;
requests.add(request);

// Submit the Request to the SummarizeCustomerFeedbackPromptExtension.getPrompt method to populate the Response (in this example its just a simple SOQL based list of Products related to the input Product)
List<SummarizeCustomerFeedbackPromptExtension.Response> responses = SummarizeCustomerFeedbackPromptExtension.getPrompt(
    requests
);

// Display the newly built Prompt string (responses[0].Prompt) in a readable format
System.debug(
    '\n\n********************************************************************\n\nFor input Product:[' +
        product.name +
        ',' +
        product.msrp__c +
        '...], Apex returned the following Prompt string to Prompt Builder:\n\n"' +
        responses[0].Prompt +
        '"\n\n******************************************************************\n'
);
