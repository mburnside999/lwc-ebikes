import { LightningElement, wire, api } from "lwc";
import getAccounts from "@salesforce/apex/AccountController.getAccounts";
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import ID_FIELD from "@salesforce/schema/Account.Id";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import WEBSITE_FIELD from "@salesforce/schema/Account.Website";
import TYPE_FIELD from "@salesforce/schema/Account.Type";

const COLS = [
  { label: "Name", fieldName: "Name", editable: true },
  { label: "Website", fieldName: "Website", editable: true },
  { label: "Type", fieldName: "Type" }
];

export default class LWCAccountList extends LightningElement {
  @api recordId;
  columns = COLS;
  draftValues = [];

  @wire(getAccounts, {})
  account;

  handleSave(event) {
    const fields = {};
    fields[ID_FIELD.fieldApiName] = event.detail.draftValues[0].Id;
    fields[NAME_FIELD.fieldApiName] = event.detail.draftValues[0].Name;
    fields[WEBSITE_FIELD.fieldApiName] = event.detail.draftValues[0].Website;
    fields[TYPE_FIELD.fieldApiName] = event.detail.draftValues[0].Type;

    const recordInput = { fields };
    updateRecord(recordInput)
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Account updated",
            variant: "success"
          })
        );
        // Display fresh data in the datatable
        return refreshApex(this.account).then(() => {
          // Clear all draft values in the datatable
          this.draftValues = [];
        });
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error updating or reloading record",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }
}
