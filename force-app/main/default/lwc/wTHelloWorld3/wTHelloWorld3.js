import { LightningElement,wire } from 'lwc';
import sayHello from "@salesforce/apex/WTHelloWorld.sayHello";

export default class WTHelloWorld1 extends LightningElement {
    @wire(sayHello,{s:"Mike"}) nameVar;




}