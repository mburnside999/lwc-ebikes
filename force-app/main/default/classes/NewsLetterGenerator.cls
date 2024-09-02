public with sharing class NewsLetterGenerator {
    @AuraEnabled
    public static String generate(String bikeId) {
        ConnectApi.EinsteinPromptTemplateGenerationsInput promptGenerationsInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
        Map<String, String> productInput = new Map<String, String>();

        productInput.put('id', bikeId);
        // Add wrapped values
        ConnectApi.WrappedValue productValueMap = new ConnectApi.WrappedValue();
        productValueMap.value = productInput;
        inputParams.put('Input:Bike', productValueMap);

        promptGenerationsInput.inputParams = inputParams;
        promptGenerationsInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        promptGenerationsInput.additionalConfig.numGenerations = 1;
        promptGenerationsInput.additionalConfig.maxTokens = 4000;
        promptGenerationsInput.additionalConfig.enablePiiMasking = false;
        promptGenerationsInput.additionalConfig.applicationName = ApplicationConstant.APP_NAME;

        promptGenerationsInput.isPreview = false;
        promptGenerationsInput.inputParams = inputParams;

        return EinsteinGenerativeGatewayService.getPromptTemplateResponse(
            '0hfIg0000004C9cIAE',
            promptGenerationsInput
        );
    }
}
