//
//  WithdrawalWalletDetailObject.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class WithdrawalWalletDetailObject: NSObject {
    var proof_status: String                = ""
    var upload_status: String               = ""
    var message_display: String             = ""
    var proof_pending_msg: String           = ""
    var bank_country_enable: Int            = 0
    var bank_country_enable_message: String = ""
    var enable_usdt_option: String          = ""
    var enable_bank_option: String          = ""
    var usdt_text: String                   = ""
    var usdt_trc_text: String               = ""
    var usdc_erc_text: String               = ""
    var usdtErc_address: String             = ""
    var usdtTrc_address: String             = ""
    var usdcErc_address: String             = ""
    var usdtErc_proof: String               = ""
    var usdtTrc_proof: String               = ""
    var usdcErc_proof: String               = ""
    var text: String                        = ""
    var withdrawal_balance: Double          = 0.0
    var terms_and_condition: String         = ""
    var total_page: Int                     = 0
    var current_page: Int                   = 0
    
    var arrHistory: [WithdrawalWalletHistoryObject] = []
    
    init(_ dictionary: [String: Any]) {
        self.proof_status                   = dictionary["proof_status"] as? String ?? ""
        self.upload_status                  = dictionary["upload_status"] as? String ?? ""
        self.message_display                = dictionary["message_display"] as? String ?? ""
        self.proof_pending_msg              = dictionary["proof_pending_msg"] as? String ?? ""
        self.bank_country_enable            = dictionary["bank_country_enable"] as? Int ?? 0
        self.bank_country_enable_message    = dictionary["bank_country_enable_message"] as? String ?? ""
        self.enable_usdt_option             = dictionary["enable_usdt_option"] as? String ?? ""
        self.enable_bank_option             = dictionary["enable_bank_option"] as? String ?? ""
        
        self.usdt_text                      = dictionary["usdt_text"] as? String ?? ""
        self.usdt_trc_text                  = dictionary["usdt_trc_text"] as? String ?? ""
        self.usdc_erc_text                  = dictionary["usdc_erc_text"] as? String ?? ""
        
        self.usdtErc_address                = dictionary["usdt_address"] as? String ?? ""
        self.usdtTrc_address                = dictionary["usdt_trc_address"] as? String ?? ""
        self.usdcErc_address                = dictionary["usdc_erc_address"] as? String ?? ""
        self.usdtErc_proof                  = dictionary["usdt_proof"] as? String ?? ""
        self.usdtTrc_proof                  = dictionary["usdt_trc_proof"] as? String ?? ""
        self.usdcErc_proof                  = dictionary["usdc_erc_proof"] as? String ?? ""
        
        self.text                           = dictionary["text"] as? String ?? ""
        self.withdrawal_balance             = dictionary["withdrawal_balance"] as? Double ?? 0.0
        self.terms_and_condition            = dictionary["terms_and_condition"] as? String ?? ""
        self.total_page                     = dictionary["total_page"] as? Int ?? 0
        self.current_page                   = dictionary["current_page"] as? Int ?? 0
        
        //HISTORY
        if let history = dictionary["history"] as? [Dictionary<String, Any>] {
            for i in 0..<history.count  {
                let objHistory = WithdrawalWalletHistoryObject.init(history[i])
                self.arrHistory.append(objHistory)
            }
        }
    }
}

//MARK:- WITHDRAWAL WALLET HISTORY OBJECT
struct WithdrawalWalletHistoryObject {
    var id: Int                         = 0
    var user_id: Int                    = 0
    var transaction_id: Int             = 0
    var payment_address: String         = ""
    var payment_proof: String           = ""
    var remarks: String                 = ""
    var withdrawal_amount: Double       = 0.0
    var payble_amount: Double           = 0.0
    var type: String                    = ""
    var status: Int                     = 0
    var usdt_verification_key: String   = ""
    var usdc_verification_key: String   = ""
    var created_at: String              = ""
    var updated_at: String              = ""
    var withdrawal_fees: Double         = 0.0
    var createdDate: String             = ""
    
    init(_ dictionary: [String: Any]) {
        self.id                     = dictionary["id"] as? Int ?? 0
        self.user_id                = dictionary["user_id"] as? Int ?? 0
        self.transaction_id         = dictionary["transaction_id"] as? Int ?? 0
        self.payment_address        = dictionary["payment_address"] as? String ?? ""
        self.payment_proof          = dictionary["payment_proof"] as? String ?? ""
        self.remarks                = dictionary["remarks"] as? String ?? ""
        self.withdrawal_amount      = dictionary["withdrawal_amount"] as? Double ?? 0.0
        self.payble_amount          = dictionary["payble_amount"] as? Double ?? 0.0
        self.type                   = dictionary["type"] as? String ?? ""
        self.status                 = dictionary["status"] as? Int ?? 0
        self.usdt_verification_key  = dictionary["usdt_verification_key"] as? String ?? ""
        self.usdc_verification_key  = dictionary["usdc_verification_key"] as? String ?? ""
        self.created_at             = dictionary["created_at"] as? String ?? ""
        self.updated_at             = dictionary["updated_at"] as? String ?? ""
        self.withdrawal_fees         = dictionary["withdrawal_fees"] as? Double ?? 0.0
        self.createdDate            = dictionary["createdDate"] as? String ?? ""
    }
}
