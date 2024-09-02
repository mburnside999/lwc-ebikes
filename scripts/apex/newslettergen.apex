// get a Product to be the Prompt input, any one will do - lets choose the first
Product__c product = [select id,name,product_family__c,msrp__c from Product__c where name = 'DYNAMO X4' limit 1];
System.debug(product);
Id bikeId=product.Id;


String response=NewsLetterGenerator.generate(bikeId);
System.debug(response);
