/********* FatooraPayMentiOSPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <MFSDK/MFSDK.h>
#import <firstTeacher-Swift.h>
// #import <MyApp-Swift.h>
//#import <MFSDKDemo-Swift.h>


@interface FatooraPayMentiOSPlugin : CDVPlugin<FatooraObjcBridgeProtocol> {
  // Member variables go here.
  CDVInvokedUrlCommand *commandVar;
  FatooraObjcBridge *bridgeObject;
}

- (void)initialisePaymentDetails:(CDVInvokedUrlCommand*)command;
- (void)payNow:(CDVInvokedUrlCommand*)command;

@end

@implementation FatooraPayMentiOSPlugin

- (void) initialisePaymentDetails:(CDVInvokedUrlCommand*)command{
    NSLog(@"Initialization data is ====%@",command.arguments[0]);
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
    CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Payment cancelled"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandVar.callbackId];
    
}

- (void)didBridgeInvoiceCreateFailWithError:(BridgeMFFailResponse *)error{
    NSLog(@"Fail=====%@",error.description);
    NSDictionary *dict  = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:error.bstatusCode],@"statusCode",error.berrorDescription,@"errorDescription", nil];
   CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandVar.callbackId];
}

- (void)didBridgeInvoiceCreateSucessWithTransaction:(BridgeMTTransaction *)transaction{
    NSLog(@"Is log file ====%@",transaction.description);

    NSDictionary *successRespnoseDict = @{transaction.customerName:@"customerName",
                                          transaction.customerEmail:@"customerEmailAddress",
                                          transaction.invoiceId:@"invoiceId",
                                          transaction.invoiceReference:@"invoiceReference",
                                          transaction.createdDate:@"createdDate",
                                          transaction.invoiceValue:@"invoiceValue",
                                          transaction.comments:@"comments",
                                          transaction.customerMobile:@"customerMobileNo",
                                          transaction.transactionDate:@"transactionDate",
                                          transaction.paymentGateway:@"paymentGateway",
                                          transaction.referenceId:@"referenceId",
                                          transaction.trackId:@"trackId",
                                          transaction.transactionId:@"transactionId",
                                          transaction.paymentId:@"paymentId",
                                          transaction.authorizationId:@"authorizationId",
                                          transaction.orderId:@"orderId",
                                        //   transaction.invoiceItems:@"invoiceItems",
                                          transaction.transactionStatus:@"transactionStatus",
                                          transaction.transationValue:@"transationValue",
                                          transaction.customerServiceCharge:@"customerServiceCharge",
                                          transaction.invoiceDisplayValue:@"invoiceDisplayValue",
                                          transaction.dueValue:@"dueValue",
                                          transaction.currency:@"currency",
                                          transaction.apiCustomFileds:@"apiCustomFieild"
                                          };
 
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:successRespnoseDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandVar.callbackId];
}

@end
