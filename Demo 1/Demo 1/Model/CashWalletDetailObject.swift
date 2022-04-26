//
//  CashWalletDetailObject.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class CashWalletDetailObject: NSObject {
    var proof_status: String        = ""
    var proof_pending_msg: String   = ""
    var terms_and_condition: String = ""
    var terms_and_condition_mt5: String = ""
    var cash_wallet_balance: Double = 0.0
    var total_page: Int             = 0
    var current_page: Int           = 0
    
    var arrHistory: [CashWalletHistoryObject] = []
    var arrFundOptions: [FundOptionObject]  = []
    
    init(_ dictionary: [String: Any]) {
        self.proof_status           = dictionary["proof_status"] as? String ?? ""
        self.proof_pending_msg      = dictionary["proof_pending_msg"] as? String ?? ""
        self.terms_and_condition    = dictionary["terms_and_condition"] as? String ?? ""
        self.terms_and_condition_mt5 = dictionary["terms_and_condition_mt5"] as? String ?? ""
        self.cash_wallet_balance    = dictionary["cash_wallet_balance"] as? Double ?? 0.0
        self.total_page             = dictionary["total_page"] as? Int ?? 0
        self.current_page           = dictionary["current_page"] as? Int ?? 0
        
        //HISTORY
        if let history = dictionary["history"] as? [Dictionary<String, Any>] {
            for i in 0..<history.count  {
                let objHistory = CashWalletHistoryObject.init(history[i])
                self.arrHistory.append(objHistory)
            }
        }
        
        //FUND OPTIONS
        if let fund_option = dictionary["fund_option"] as? [Dictionary<String, Any>] {
            for i in 0..<fund_option.count  {
                let objFundOption = FundOptionObject.init(fund_option[i])
                self.arrFundOptions.append(objFundOption)
            }
        }
    }
}


//MARK:- CASH WALLET HISTORY OBJECT
struct CashWalletHistoryObject {
    var id: Int                 = 0
    var user_id: Int            = 0
    var amount: Double          = 0.0
    var description: String     = ""
    var type: String            = ""
    var from_wallet: String     = ""
    var update_date: String     = ""
    var final_amount: Double    = 0.0
    var created_at: String      = ""
    var updated_at: String      = ""
    var remarks: String         = ""
    
    init(_ dictionary: [String: Any]) {
        self.id             = dictionary["id"] as? Int ?? 0
        self.user_id        = dictionary["user_id"] as? Int ?? 0
        self.amount         = dictionary["amount"] as? Double ?? 0.0
        self.description    = dictionary["description"] as? String ?? ""
        self.type           = dictionary["type"] as? String ?? ""
        self.from_wallet    = dictionary["from_wallet"] as? String ?? ""
        self.update_date    = dictionary["update_date"] as? String ?? ""
        self.final_amount   = dictionary["final_amount"] as? Double ?? 0.0
        self.created_at     = dictionary["created_at"] as? String ?? ""
        self.updated_at     = dictionary["updated_at"] as? String ?? ""
        self.remarks        = dictionary["remarks"] as? String ?? ""
    }
}

//MARK:- FUND OPTION OBJECT
struct FundOptionObject {
    var value: String       = ""
    var text: String        = ""
    var bank_detail: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.value          = dictionary["value"] as? String ?? ""
        self.text           = dictionary["text"] as? String ?? ""
        self.bank_detail    = dictionary["bank_detail"] as? String ?? ""
    }
}

//MARK:- STOCK WALLET TRANSFER HISTORY OBJECT
struct StockWalletTransferHistoryObject {
    var id: Int = 0
    var user_id: Int = 0
    var amount: Double = 0.0
    var description_stock: String = ""
    var type: String = ""
    var from_wallet: Int = 0
    var to_wallet: Int = 0
    var created_at: String = ""
    var updated_at: String = ""
        
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.user_id = dictionary["user_id"] as? Int ?? 0
        self.amount = dictionary["amount"] as? Double ?? 0.0
        self.description_stock = dictionary["description"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
        self.from_wallet = dictionary["from_wallet"] as? Int ?? 0
        self.to_wallet = dictionary["to_wallet"] as? Int ?? 0
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""
    }
}
