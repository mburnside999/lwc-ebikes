import { LightningElement, api } from 'lwc';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled
} from 'lightning/empApi';
import TickerSymbol from '@salesforce/schema/Account.TickerSymbol';

const ORDER_CHANGE_CHANNEL = '/event/ebikesaws__OrderStatusUpdate__e';

export default class WTSubscribeToOrderChangeLWC extends LightningElement {
    @api recordId;
    subscription;
    messageVar = 'Listening for DynamoDB Order Updates...';
    messageReceived = false;
    subscribed = false;

    async connectedCallback() {
        // Check if EMP API is available
        const isEmpApiEnabled = await isEmpEnabled();
        if (!isEmpApiEnabled) {
            this.reportError('The EMP API is not enabled.');
            return;
        }
        // Handle EMP API debugging and error reporting
        setDebugFlag(true);
        onError((error) => {
            console.log('Error!');
        });

        // Subscribe to Manufacturing Event plaform event
        try {
            this.subscription = await subscribe(
                ORDER_CHANGE_CHANNEL,
                -1,
                (event) => {
                    this.handleOrderChangeEvent(event);
                }
            );
        } catch (error) {
            this.reportError('EMP API error: failed to subscribe', error);
        }
    }

    disconnectedCallback() {
        if (this.subscription) {
            unsubscribe(this.subscription);
        }
    }

    handleSubscribeChange(event) {
        this.value = event.target.checked;
        console.log('Subscribed: ' + event.target.checked);
        this.subscribed = event.target.checked;
    }
    handleOrderChangeEvent(event) {
        // Only handle events for the current record
        // if (event.data.payload.Order_Id__c === this.recordId) {
        //     this.setPicklistValue(event.data.payload.Status__c);
        // }
        this.messageReceived = true;
        this.messageVar =
            'Order Status Event received via EventBridge (' +
            event.data.payload.ebikesaws__Status__c +
            ')';
    }

    clearMessage(event) {
        // Only handle events for the current record
        // if (event.data.payload.Order_Id__c === this.recordId) {
        //     this.setPicklistValue(event.data.payload.Status__c);
        // }
        this.messageVar = 'Listening for DynamoDB Order Updates...';
        this.messageReceived = false;
        this.subscribed = true;
    }
}