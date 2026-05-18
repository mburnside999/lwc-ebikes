import { LightningElement, api, track, wire } from 'lwc';
import getBQ from '@salesforce/apex/BigQuery3.getBQ';

const columns = [
    { label: 'Title', fieldName: 'title', type: 'text' },
    { label: 'Page Views', fieldName: 'views', type: 'number' }
];

export default class LwcBQ3 extends LightningElement {
    result = [];
    columns = columns;
    @api msg = 'This LWC is hosted in this org, and calls out to BigQuery.';

    @wire(getBQ)
    wiredData({ error, data }) {
        if (data) {
            this.result = JSON.parse(data);
            console.log(data);
        } else if (error) {
            console.error(error);
        }
    }
}
