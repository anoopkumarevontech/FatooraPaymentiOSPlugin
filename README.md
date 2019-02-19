# FatooraPaymentiOSPlugin
Add the plugin using command below.
ionic cordova plugin add https://github.com/anoopkumarevontech/FatooraPaymentiOSPlugin.git --save
Create a Provider file same like below :-

import { Injectable } from '@angular/core';
import { Plugin,Cordova} from '@ionic-native/core';



@Plugin(
  {
    pluginName: "FatooraPayMentiOSPlugin",
    plugin: "cordova-plugin-fatoorapayment",
    pluginRef: "FatooraPayMentiOSPlugin",
    rep:"https://github.com/anoopkumarevontech/FatooraPaymentiOSPlugin.git",
    platforms: ["ios"]
  }

)

@Injectable()

export class FatooraProvider {

@Cordova()
initialisePaymentDetails(arg1: any): Promise<string> {
return;
}

@Cordova()
payNow(arg1: any): Promise<string> {
return;
}
  
}
How to call function from screen (For exapmle from Home.ts) :-

import { FatooraProvider } from '../../providers/fatoora/fatoora';
@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {

  constructor(public fatoora:FatooraProvider) {

  }

  initialiseYourPayment(){

    let  merchantDetails =  {
      merchantBaseUrl : "",
      merchantEmail : "",
      merchantPassword : "",
      }

    this.fatoora.initialisePaymentDetails(merchantDetails).then(result=>{
      console.log('000--- result --000',result)
      alert("merchantDetails intialised")
  }).catch(error =>{
      console.log("---in startBgApp error---",error)
      alert("error in merchantDetails")    
  })

  }

  clickPay(){
       var detailObject = {
   productName: "SchoolJob",
   productPrice: "1000",
   productQuantity:"2",
   customerBlockNo: "",
   customerCivilID: "",
   customerStreet: "",
   customerBuildingNo: "building-23",
   customerEmailAddress: "",//Required
   customerName: "",//Required
   customerMobileNo: "",//Required
   customerReference: "",
       apiCustomFieild :"",
   expiryDate:"2030-01-08T11:04:42.005Z"
   }

    this.fatoora.payNow(detailObject).then(result=>{
      console.log('pay Success',JSON.stringify(result))
  }).catch(error =>{
      console.log("---in payNow error---",JSON.stringify(error))
  })

  }

}
