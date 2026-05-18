global class MBBatchFieldScanController {
    /*******************************************************************************************************
     * @name execute
     * @description Start
     *
     * @param
     * @return
     */

    global void execute() {
        System.debug('in MBBAtchFieldScanController.execute()');

        MBBatchFieldScan batchfs = new MBBatchFieldScan();

        //set the email to receive notification
        batchfs.email = 'mburnside@salesforce.com';

        //execute with chosen batch size
        ID batchfsid = Database.executeBatch(batchfs, 500);
    }
}