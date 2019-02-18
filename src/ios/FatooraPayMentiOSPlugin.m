/********* FatooraPayMentiOSPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <MFSDK/MFSDK.h>
#import <MyApp-Swift.h>
//#import <MFSDKDemo-Swift.h>


@interface FatooraPayMentiOSPlugin : CDVPlugin<FatooraObjcBridgeProtocol> {
  // Member variables go here.
  CDVInvokedUrlCommand *commandVar;
  FatooraObjcBridge *bridgeObject;
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
- (void)initialisePaymentDetails:(CDVInvokedUrlCommand*)command;
- (void)payNow:(CDVInvokedUrlCommand*)command;

@end

@implementation FatooraPayMentiOSPlugin

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) initialisePaymentDetails:(CDVInvokedUrlCommand*)command{
    NSLog(@"Test data is ====%@",[command.arguments[0] valueForKey:@"merchantBaseUrl"]);
    NSLog(@"Test data is ====%@",[command.arguments[0] valueForKey:@"merchantEmail"]);
    NSLog(@"Test data is ====%@",[command.arguments[0] valueForKey:@"merchantPassword"]);
    CDVPluginResult* pluginResult = nil;
    if ([[command.arguments[0]allKeys] count] > 0) {
        bridgeObject = [[FatooraObjcBridge alloc]init];
        [bridgeObject configureSettinsWithBuserName:[command.arguments[0] valueForKey:@"merchantEmail"] bpassword:[command.arguments[0] valueForKey:@"merchantPassword"] bbaseUrl:[command.arguments[0] valueForKey:@"merchantBaseUrl"]];
        [bridgeObject setFatooraBridgeDelegate:self];
       
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Added merchant account"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Reqesut not in correct format"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

- (void)payNow:(CDVInvokedUrlCommand*)command{
    commandVar = command;
    NSDictionary  *requestDict = command.arguments[0];
    [bridgeObject createInvoiceWithInvoiceDict:requestDict];
}

- (void)didBridgePaymentCancel{
    NSLog(@"Payment cancelled");
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Payment cancelled"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandVar.callbackId];
    
}

- (void)didBridgeInvoiceCreateFailWithError:(BridgeMFFailResponse *)error{
    NSLog(@"Fail=====%@",error.description);
    NSDictionary *dict  = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:error.bstatusCode],@"statusCode",error.description,@"errorDescription", nil];
   CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandVar.callbackId];
}

- (void)didBridgeInvoiceCreateSucessWithTransaction:(BridgeMTTransaction *)transaction{
    NSLog(@"Is log file ====%@",transaction.description); 

    NSDictionary *successRespnoseDict = @{transaction.customerName:@"",
                                          transaction.customerEmail:@"",
                                          transaction.invoiceId:@"",
                                          transaction.invoiceReference:@"",
                                          transaction.createdDate:@"",
                                          transaction.invoiceValue:@"",
                                          transaction.comments:@"",
                                          transaction.customerName:@"",
                                          transaction.customerMobile:@"",
                                          transaction.transactionDate:@"",
                                          transaction.paymentGateway:@"",
                                          transaction.referenceId:@"",
                                          transaction.trackId:@"",
                                          transaction.transactionId:@"",
                                          transaction.paymentId:@"",
                                          transaction.authorizationId:@"",
                                          transaction.orderId:@"",
                                          transaction.invoiceItems:@"",
                                          transaction.transactionStatus:@"",
                                          transaction.transationValue:@"",
                                          transaction.customerServiceCharge:@"",
                                          transaction.invoiceDisplayValue:@"",
                                          transaction.dueValue:@"",
                                          transaction.currency:@"",
                                          transaction.apiCustomFileds:@""
                                          };
 
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:successRespnoseDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandVar.callbackId];
}

@end
