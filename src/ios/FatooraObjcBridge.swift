//
//  FatooraObjcBridge.swift
//  MFSDKDemo
//
//  Created by anoop on 15/02/19.
//  Copyright © 2019 anoop . All rights reserved.
//

import Foundation
import UIKit
import MFSDK

public class BridgeInvoiceItem : NSObject {
    
    @objc public var item:String?
    
    
}



public class BridgeMFFailResponse:NSObject {
    public override init() {
        super.init()
    }
    public init(statusCode:Int,errorDescription:String) {
        bstatusCode = statusCode
        berrorDescription = errorDescription
    }
    
    @objc public var bstatusCode: Int = 0
    
    @objc public var berrorDescription: String = ""
}


public class BridgeMTTransaction:NSObject {
    
    public override init() {
        super.init()
    }
    
    @objc public var invoiceId = ""
    
   @objc public var invoiceReference = ""
    
   @objc public var createdDate = ""
    
   @objc public var expireDate = ""
    
   @objc public var invoiceValueNSNumber = 0
    
   @objc public var comments = ""
    
   @objc public var customerName = ""
    
   @objc public var customerMobile = ""
   @objc public var customerEmail = ""
    
   @objc public var transactionDate = ""
    
   @objc public var paymentGateway = ""
    
   @objc public var referenceId = ""
    
   @objc public var trackId = ""
    
   @objc public var transactionId = ""
    
   @objc public var paymentId = ""
    
    @objc public var authorizationId = ""
    
   @objc public var orderId = ""
    
   @objc public var invoiceItems = [BridgeInvoiceItem]()
    
   @objc public var transactionStatus:NSNumber = 0
    
   @objc public var error = ""
    
   @objc public var paidCurrency = ""
    
   @objc public var paidCurrencyValue = ""
    
    @objc public var transationValue = ""
    
    @objc public var customerServiceCharge = ""
    
    @objc public var dueValue = ""
    
   @objc public var currency = ""
    
    @objc public var apiCustomFileds = ""
    
   @objc public var invoiceDisplayValue = ""
}

@objc public protocol FatooraObjcBridgeProtocol {
    //Delegate to call in Objc class
    @objc func didBridgeInvoiceCreateSucess(transaction: BridgeMTTransaction)
    @objc func didBridgeInvoiceCreateFail(error: BridgeMFFailResponse)
    @objc func didBridgePaymentCancel()
    
}

public class FatooraObjcBridge:NSObject,MFInvoiceCreateStatusDelegate {
    
    
    @objc weak var fatooraBridgeDelegate:FatooraObjcBridgeProtocol? = nil
    
    @objc public func configureSettins(buserName:String,bpassword:String,bbaseUrl:String) {
        MFInvoiceCreateStatus.shared.delegate = self
        MFSettings.shared.configure(username: buserName, password: bpassword, baseURL: bbaseUrl)
    }
    
    
    @objc public func createInvoice(invoiceDict:[String:Any]) {

        print("Recived request is ===\(invoiceDict)");
        let invoiceValue = Double(invoiceDict["price"] as! String)  ?? 0.0
        let invoice = MFInvoice(invoiceValue: invoiceValue , customerName: invoiceDict["customerName"] as? String ?? "" , countryCode: .kuwait, displayCurrency: .Kuwaiti_Dinar_KWD)
        print("Invoaid is ===\(invoice.invoiceValue)")
        
        invoice.customerEmail = invoiceDict["customerEmailAddress"] as? String ?? ""// must be email
        invoice.customerMobile =  invoiceDict["customerMobileNo"] as? String ?? ""//Required
        invoice.customerCivilId =  invoiceDict["customerCivilID"] as? String ?? ""
        invoice.customerBlock = invoiceDict["customerBlockNo"] as? String ?? ""
        invoice.customerStreet = invoiceDict["customerStreet"] as? String ?? ""
        invoice.customerHouseBuildingNo = invoiceDict["customerBuildingNo"] as? String ?? ""
        invoice.customerReference = invoiceDict["customerReference"] as? String ?? ""
        invoice.expireDate = invoiceDict["expiryDate"] as? String ?? ""
        invoice.language = .arabic
        invoice.sendInvoiceOption = .sms
        invoice.apiCustomFileds = invoiceDict["apiCustomFieild"] as? String ?? ""
        
         var productList = [MFProduct]()
        
            let product = MFProduct(name: invoiceDict["productName"] as! String, unitPrice: Double(invoiceDict["productPrice"] as! String) ?? 0.0, quantity: Int(invoiceDict["productQuantity"] as! String) ?? 0)
            productList.append(product)
        
        MFPaymentRequest.shared.createInvoice(invoice: invoice, paymentMethod: .all, apiLanguage: .english)
    }
    
    //MARK:- FrameWork Delegates
    
    public func didInvoiceCreateSucess(transaction: MFTransaction) {
        guard fatooraBridgeDelegate == nil else {
            let bridgeTransaction  = BridgeMTTransaction()
            bridgeTransaction.apiCustomFileds = transaction.apiCustomFileds ?? ""
            
            fatooraBridgeDelegate?.didBridgeInvoiceCreateSucess(transaction: bridgeTransaction)
            return
        }
    }
    
    public func didInvoiceCreateFail(error: MFFailResponse) {
        guard fatooraBridgeDelegate == nil else {
         let failResponse =  BridgeMFFailResponse(statusCode: error.statusCode, errorDescription: error.errorDescription)
            fatooraBridgeDelegate?.didBridgeInvoiceCreateFail(error: failResponse)
            return
        }
    }
    
    public func didPaymentCancel() {
        guard fatooraBridgeDelegate == nil else {
            fatooraBridgeDelegate?.didBridgePaymentCancel()
            return
        }
    }
}
