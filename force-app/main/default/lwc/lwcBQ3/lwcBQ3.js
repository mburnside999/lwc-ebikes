import { LightningElement, track, wire } from 'lwc';
import getBQ from '@salesforce/apex/BigQuery3.getBQ';

const columns = [
    { label: 'Title', fieldName: 'title', type: 'text' },
    { label: 'Page Views', fieldName: 'views', type: 'text' }
];

export default class LwcBQ3 extends LightningElement {
    result = [];
    columns = columns;

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