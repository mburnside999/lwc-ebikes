import { LightningElement} from "lwc";
import sayHello from "@salesforce/apex/WTHelloWorld.sayHello";

export default class WTHelloWorld1 extends LightningElement {
  greetingVar;

  connectedCallback() {
    sayHello({s:"Earthling"}).then((result) => {
      this.greetingVar = result;
      console.log(result);
    });
  }
}