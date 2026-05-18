public class MBBatch implements Database.Batchable<sObject>, Database.Stateful {
    public String query;
    public String email = 'mburnside@salesforce.com';
    public integer recs = 0;
    public integer objs = 0;
    public integer batch = 0;
    public integer batchrecs = 0;
    public List<FieldDefinition> fieldslist;
    public String message = 'Scanning for compliance fields...\n';
    public DateTime now;
    public Iterable<EntityDefinition> start(Database.BatchableContext bc) {
        fieldslist = new List<FieldDefinition>();
        now = DateTime.now();
        message += '\nScan Started at: ' + now + '(UTC)\n\n';
        return new MBIterable();
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
                //AND Securityclassification != NULL
            ]
        );

        for (FieldDefinition fd : fdlist) {
            recs += 1;
            if (
                fd.securityclassification != null ||
                fd.compliancegroup != null
            ) {
                fieldslist.add(fd);
            }
        }
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

    public void finish(Database.BatchableContext bc) {
        now = Datetime.now();
        message += '\n Scan Finished at: ' + now + '(UTC)\n\n';

        message += 'Scan Results:\n';
        message += 'Total Objects Scanned: ' + objs + '\n';
        message += 'Total Fields Scanned: ' + recs + '\n';

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
        mail.setSenderDisplayName('MB Batch Processing');
        mail.setSubject(' Compliance Scanning Completed.');

        mail.setPlainTextBody(message);

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    }
}