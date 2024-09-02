import { LightningElement } from 'lwc';
import generate from '@salesforce/apex/NewsLetterGenerator.generate';

export default class AiNewsLetterGenerator extends LightningElement {
    bikeId;
    newsLetterBody;
    isLoading = false;
    isLetterGenerated = false;
    isPreview = false;

    handleChange(event) {
        console.log(`Selected record: ${event.detail.recordId}`);
        this.bikeId = event.detail.recordId;
    }

    handleToggleChange(event) {
        if (event.target.checked) {
            this.isPreview = true;
        } else {
            this.isPreview = false;
        }
    }
    handleClick() {
        this.isLoading = true;
        // setTimeout(() => {
        //     this.newsLetterBody = `<html>
        //     <body>
        //         <title>Unleash Your Adventure with DYNAMO X4</title>
        //         <h3>Unleash Your Adventure with DYNAMO X4 </h3>
        //         <img src="https://s3-us-west-2.amazonaws.com/dev-or-devrl-s3-bucket/sample-apps/ebikes/dynamox4.jpg" style="border-radius: 15px; width: 100%; max-width: 600px; height: auto;"> 
        //         <h2> Features: </h2>
        //         <p>Introducing the DYNAMO X4, a cutting-edge mountain bike designed for adventure enthusiasts. With its sleek carbon frame in red color, this bike is not only stylish but also built to withstand the toughest terrains. The bike comes with a 284-watt, 75Nm motor. MSRP is set at 7800.</p>
        //         <br>
        //         <h3> Discover More Products You Might Enjoy</h3>
        //         <div style="display: flex; justify-content: space-between;">
        //           <div>
        //             <img src="https://s3-us-west-2.amazonaws.com/dev-or-devrl-s3-bucket/sample-apps/ebikes/dynamox1.jpg" style="width: 90%; border-radius: 15px;border: 2px solid #C23335;">
        //             <p style="margin: 10px 0;">DYNAMO X1, MSRP: 7000</p>
        //           </div>
        //           <div>
        //             <img src="https://s3-us-west-2.amazonaws.com/dev-or-devrl-s3-bucket/sample-apps/ebikes/dynamox2.jpg" style="width: 90%; border-radius: 15px;border: 2px solid #C23335;">
        //             <p style="margin: 10px 0;">DYNAMO X2, MSRP: 7200</p>
        //           </div>
        //           <div>
        //             <img src="https://s3-us-west-2.amazonaws.com/dev-or-devrl-s3-bucket/sample-apps/ebikes/dynamox3.jpg" style="width: 90%; border-radius: 15px;border: 2px solid #C23335;">
        //             <p style="margin: 10px 0;">DYNAMO X3, MSRP: 7400</p>
        //           </div>
        //         </div>
        //         <div style="text-align: center; margin-top: 20px;">
        //           <a href="https://ebikes.com" style="background-color: #C23335; border: none; color: white; padding: 15px 32px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px; margin: 4px 2px; cursor: pointer; border-radius: 5px;">Explore More</a>
        //         </div>
        //         <p>Best Regards,</p>
        //         <p>Your Name</p>
        //     </body>
        //     </html>
        //     `;
        //     this.isLetterGenerated = true;
        //     this.isLoading = false;
        // }, 4000); // 10 seconds in milliseconds

        //wire service to get the bike details
        generate({ bikeId: this.bikeId })
            .then((result) => {
                this.isLoading = false;
                this.newsLetterBody = result;
                this.isLetterGenerated = true;
            })
            .catch((error) => {
                this.error = error;
                this.isLoading = false;
            });
    }
}