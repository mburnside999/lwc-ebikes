import { LightningElement, track } from 'lwc';
import startRequest from '@salesforce/apexContinuation/SimpleContinuationClass.startRequest';
export default class lwccontinuation extends LightningElement {
    @track listOfRecords = {};
    @track error;
    connectedCallback() {
        startRequest()
            .then((result) => {
                this.listOfRecords = result;
                console.log('xxx' + result);
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                console.log('ERROR!' + JSON.stringify(error));
                this.listOfRecords = undefined;
            });
    }
}
