/*
    This example apex class is responsible for responding to data provider requests
    for looking up account records. See usage defined in the 'create_contact' view.
*/
public class DataProviderAccountLookup {
    public static Slack.OptionDataResponse getAccountsByName(String value) {
        System.debug('XXXX create List<Account>');
        List<Account> accounts;
        if (String.isNotBlank(value)) {
            String name = '%' + value + '%';
            accounts = [
                SELECT Id, Name
                FROM Account
                WHERE Name LIKE :name
                WITH SECURITY_ENFORCED
                LIMIT 10
            ];
        }

        List<Slack.Option> accountOptions = new List<Slack.Option>();
        if (accounts != null) {
            for (Account account : accounts) {
                Slack.Option option = new Slack.Option(
                    account.Name,
                    account.Id
                );
                accountOptions.add(option);
            }
        }
        return new Slack.OptionDataResponse(accountOptions);
    }
}
