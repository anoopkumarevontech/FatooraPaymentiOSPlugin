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
    bridgeObject = [[FatooraObjcBridge alloc]init];
    [bridgeObject configureSettinsWithBuserName:@"apiaccount@myfatoorah.com" bpassword:@"api12345*" bbaseUrl:@"https://apidemo.myfatoorah.com/"];
    [bridgeObject setFatooraBridgeDelegate:self];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Added merchant account"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)payNow:(CDVInvokedUrlCommand*)command{
    NSDictionary *productDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"Samosa",@"product_name",@"2",@"unit_value",@"5",@"quantity", nil];
    
    NSArray *array = [[NSArray alloc]initWithObjects:productDict, nil];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"Anoop kumar",@"customerName",@"10.0",@"price",@"",@"customerEmail",
                          @"9808311471",@"customerMobile",array,@"productArray",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    [bridgeObject createInvoiceWithInvoiceDict:dict];
}

- (void)didBridgePaymentCancel{
    NSLog(@"Payment cancelled");
    
}

- (void)didBridgeInvoiceCreateFailWithError:(BridgeMFFailResponse *)error{
    NSLog(@"Fail=====%@",error.description);
}

- (void)didBridgeInvoiceCreateSucessWithTransaction:(BridgeMTTransaction *)transaction{
    NSLog(@"Is log file ====%@",transaction.description);
}

@end
