/********* FatooraPayMentiOSPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <MFSDK/MFSDK.h>
#import <First_Teacher-Swift.h>
//#import <firstTeacher-Swift.h> project name changes to above
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

    NSDictionary *successRespnoseDict = @{@"customerName":transaction.customerName,
                                          @"customerEmailAddress":transaction.customerEmail,
                                          @"invoiceId":transaction.invoiceId,
                                          @"invoiceReference" :transaction.invoiceReference,
                                          @"createdDate":transaction.createdDate,
                                          @"invoiceValue":[NSString stringWithFormat:@"%@",transaction.invoiceValue],
                                          @"comments":transaction.comments,
                                          @"customerMobileNo":transaction.customerMobile,
                                          @"transactionDate":transaction.transactionDate,
                                          @"paymentGateway":transaction.paymentGateway,
                                          @"referenceId":transaction.referenceId,
                                          @"trackId":transaction.trackId,
                                          @"transactionId":transaction.transactionId,
                                          @"paymentId":transaction.paymentId,
                                          @"authorizationId":transaction.authorizationId,
                                          @"orderId":transaction.orderId,
                                        //   transaction.invoiceItems:@"invoiceItems",
                                          @"transactionStatus":[NSString stringWithFormat:@"%@",transaction.transactionStatus],
                                          @"transationValue":transaction.transationValue,
                                          @"customerServiceCharge":transaction.customerServiceCharge,
                                          @"invoiceDisplayValue":transaction.invoiceDisplayValue,
                                              @"dueValue":transaction.dueValue,
                                          @"currency":transaction.currency,
                                          @"apiCustomFieild":transaction.apiCustomFileds
                                          };
 
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:successRespnoseDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandVar.callbackId];
}

@end
