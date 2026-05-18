global class MBBatchController {
    /*******************************************************************************************************
     * @name execute
     * @description Start
     *
     * @param SCBC
     * @return
     */

    global void execute() {
        System.debug('in MBBatchController()');

        MBBatch mbbatch = new MBBatch();

        //mbbatch.query = 'SELECT qualifiedapiname from entitydefinition';

        mbbatch.email = 'mburnside@salesforce.com';
        ID mbbatchid = Database.executeBatch(MBBatch, 500);
    }
}