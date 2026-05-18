import { LightningElement } from 'lwc';

export default class MBrefresher extends LightningElement {
    message = '';

    connectedCallback() {
        this.interval = setInterval(() => {
            const d = new Date();
            this.message = `Hello, World! ${d}`;
        }, 1000);
    }

    disconnectedCallback() {
        clearInterval(this.interval);
    }
}
