public class MBBatchFieldScan implements Database.Batchable<sObject>, Database.Stateful {
    //default, to change set in the controller
    public String email = 'mburnside@salesforce.com';

    //counters
    private integer flds = 0;
    private integer objs = 0;
    private integer batch = 0;
    private integer batchflds = 0;

    public List<FieldDefinition> fieldslist;

    //message and timestamp setup
    private String message = 'Scanning for compliance fields...\n';
    private DateTime now;

    /*******************************************************************************************************
     * @name execute
     * @description start
     * initialise timestamp, instantiate global FieldDefinition list, return our custom Iterable
     * @param bc batchable context
     */

    public Iterable<EntityDefinition> start(Database.BatchableContext bc) {
        fieldslist = new List<FieldDefinition>();
        now = DateTime.now();
        message += '\nScan Started at: ' + now + '(UTC)\n\n';
        return new MBEntityDefinitionIterable();
    }

    /*******************************************************************************************************
     * @name execute
     * @description Start
     *
     * @param bc batchable context
     * @param scope scope
  
     */
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<String> entities = new List<String>();
        for (sObject s : scope) {
            objs += 1;
            EntityDefinition ed = (EntityDefinition) s;
            entities.add(ed.qualifiedapiname);
        }

        List<FieldDefinition> fdlist = new List<FieldDefinition>(
            [
                SELECT
                    Id,
                    DeveloperName,
                    DurableId,
                    Description,
                    SecurityClassification,
                    ComplianceGroup,
                    EntityDefinition.QualifiedApiName
                FROM FieldDefinition
                WHERE EntityDefinitionId IN :entities
            ]
        );

        for (FieldDefinition fd : fdlist) {
            flds += 1;
            //check the comliance and security fields
            if (
                fd.securityclassification != null ||
                fd.compliancegroup != null
            ) {
                fieldslist.add(fd);
            }
        }

        //increment the batch number
        batch += 1;

        message +=
            'Batch => ' +
            batch +
            ', Objects Scanned in Batch: ' +
            scope.size() +
            ', Fields Scanned in Batch: ' +
            fdlist.size() +
            '\n';
    }

    /*******************************************************************************************************
     * @name finish
     * @description
     * write the results to an email
     */

    public void finish(Database.BatchableContext bc) {
        now = Datetime.now();
        message += '\n Scan Finished at: ' + now + '(UTC)\n\n';

        message += 'Scan Results:\n';
        message += 'Total Objects Scanned: ' + objs + '\n';
        message += 'Total Fields Scanned: ' + flds + '\n';

        message += 'FieldName / Classification / Compliance\n';
        message += '==========================================\n';
        for (FieldDefinition fd : fieldslist) {
            message +=
                fd.entitydefinition.qualifiedapiname +
                '.' +
                fd.developername +
                ' / ' +
                fd.securityclassification +
                ' / ' +
                fd.compliancegroup +
                '\n';
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new List<String>{ email });
        mail.setReplyTo('batch@acme.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Compliance Scanning Completed.');

        mail.setPlainTextBody(message);

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    }
}