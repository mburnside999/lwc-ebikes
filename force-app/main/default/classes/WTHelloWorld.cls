public with sharing class WTHelloWorld {
//     public static String sayHello(String str) {
// System.debug('sayHello str='+str);
//         return 'Hello '+str +', nice to meet you.';
//     }
@AuraEnabled (cacheable=true)
    public static String sayHello(String s) {
                return 'Hello Earthling we come in peace!';
            }
}