public with sharing class EinsteinGenerativeGatewayService {
    public static String getPromptTemplateResponse(
        String promptTemplateDeveloperName,
        ConnectApi.EinsteinPromptTemplateGenerationsInput input
    ) {
        try {
            // Call the service
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
                '0hfIg0000004C9cIAE',
                input
            );
            //ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(promptTemplateDeveloperName, input);

            // Consume response
            ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
            System.debug('Prompt: ' + generationsOutput.prompt);
            System.debug('Response: ' + generationsOutput.generations[0]);
            return response.text;
        } catch (exception e) {
            throw new EinsteinGenerativeGatewayException(e.getMessage());
        }
    }

    public class EinsteinGenerativeGatewayException extends Exception {
    }
}
