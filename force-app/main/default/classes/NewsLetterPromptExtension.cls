public class NewsLetterPromptExtension {
    @InvocableMethod(
        CapabilityType='FlexTemplate://Bike_Promotion_Newsletter'
    ) // Matches API Name of template*/
    public static List<Response> getPrompt(List<Request> requests) {
        Request input = requests[0];
        List<Response> responses = new List<Response>();

        Response output = new Response();
        output.Prompt = 'Recommended Products:';
        for (
            Product__c prd : ProductController.getSimilarProducts(
                input.Bike.Id,
                input.Bike.Product_Family__c
            )
        ) {
            output.Prompt +=
                '\n' +
                'product name:' +
                prd.Name +
                ', Picture URL:' +
                prd.Picture_URL__c +
                ', MSRP:' +
                prd.MSRP__c;
        }
        output.Prompt += '\n';
        responses.add(output);
        return responses;
    }

    // Type and Name of all variables must match as defined when creating the template
    public class Request {
        @InvocableVariable
        public Product__c Bike;
    }

    public class Response {
        @InvocableVariable(required=true)
        public String Prompt;
    }
}
