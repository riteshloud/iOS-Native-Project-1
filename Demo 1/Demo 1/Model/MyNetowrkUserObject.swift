//
//  MyNetowrkUserObject.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class MyNetowrkUserObject: NSObject {
    var id: Int                 = 0
    var sponsor_id: Int         = 0
    var name: String            = ""
    var username: String        = ""
    var email: String           = ""
    var direct_downline: Int    = 0
    var mt4_user_id: String     = ""
    var created_at              = ""
    var package_amount: String  = ""
    
    init(_ dictionary: [String: Any]) {
        self.id                 = dictionary["id"] as? Int ?? 0
        self.sponsor_id         = dictionary["sponsor_id"] as? Int ?? 0
        self.name               = dictionary["name"] as? String ?? ""
        self.username           = dictionary["username"] as? String ?? ""
        self.email              = dictionary["email"] as? String ?? ""
        self.direct_downline    = dictionary["direct_downline"] as? Int ?? 0
        self.mt4_user_id        = dictionary["mt4_user_id"] as? String ?? ""
        self.created_at         = dictionary["created_at"] as? String ?? ""
        let fpackage_amount     = dictionary["package_amount"] as? Float ?? 0.0
        self.package_amount     = fpackage_amount.clean
    }
}

class MyNetowrkRankObject: NSObject {
    var id: Int = 0
    var name: String = ""
    var icon: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.icon = dictionary["icon"] as? String ?? ""
    }
}

class MyNetworkUserDetail: NSObject {
  var usdt_image: String = ""
  var payment_methods: Int = 0
  var rank_detail: MyNetowrkUserRankObject = MyNetowrkUserRankObject.init([:])
  var usdt_address: String = ""
  var country_id: Int = 0
  var rank_id: Int = 0
  var signature: String = ""
  var profile_image: String = ""
  var total_dir_sales: Int = 0
  var downline_user_transfer: String = ""
  var mt4_user_id: String = ""
  var stock_investment_amount: String = ""
  var mt4_password: String = ""
  var password_otp: String = ""
  var proof_status: String = ""
  var month_group_sales: Int = 0
  var city: String = ""
  var promo_account: String = ""
  var child: [MyNetworkUserDetail] = []
  var is_deleted: String = ""
  var device_token: String = ""
  var address: String = ""
  var package_amount: Int = 0
  var is_leader: String = ""
  var group_sales: Int = 0
  var total_capital: Int = 0
  var name: String = ""
  var secure_password: String = ""
  var package_id: Int = 0
  var member_group: Int = 0
  var monthly_group_sales: Int = 0
  var email_verified_at: String = ""
  var phone_number: String = ""
  var email: String = ""
  var sponsor_id: Int = 0
  var fixed_rank: String = ""
  var total_group_sales: Int = 0
  var is_consultant: Int = 0
  var device_type: String = ""
  var disabled_commission: String = ""
  var direct_downline: Int = 0
  var identification_number: String = ""
  var username: String = ""
  var highlight: Bool = false
  var state: String = ""
  var finger_print: String = ""
  var first_login: Int = 0
  var updated_at: String = ""
  var disable_commission: String = ""
  var created_at: String = ""
  var login_token: String = ""
  var invest_id: Int = 0
  var status: String = ""
  var id: Int = 0
  var mt4_capital_form_exclude: Int = 0
  var enable_fund_wallet: String = ""
  var finger_uuid: String = ""

  init(_ dictionary: [String: Any]) {
    self.usdt_image = dictionary["usdt_image"] as? String ?? ""
    self.payment_methods = dictionary["payment_methods"] as? Int ?? 0
    self.rank_detail = MyNetowrkUserRankObject.init(dictionary["rank_detail"] as? Dictionary<String, Any> ?? [:])
    self.usdt_address = dictionary["usdt_address"] as? String ?? ""
    self.country_id = dictionary["country_id"] as? Int ?? 0
    self.rank_id = dictionary["rank_id"] as? Int ?? 0
    self.signature = dictionary["signature"] as? String ?? ""
    self.profile_image = dictionary["profile_image"] as? String ?? ""
    self.total_dir_sales = dictionary["total_dir_sales"] as? Int ?? 0
    self.downline_user_transfer = dictionary["downline_user_transfer"] as? String ?? ""
    self.mt4_user_id = dictionary["mt4_user_id"] as? String ?? ""
    self.stock_investment_amount = dictionary["stock_investment_amount"] as? String ?? ""
    self.mt4_password = dictionary["mt4_password"] as? String ?? ""
    self.password_otp = dictionary["password_otp"] as? String ?? ""
    self.proof_status = dictionary["proof_status"] as? String ?? ""
    self.month_group_sales = dictionary["month_group_sales"] as? Int ?? 0
    self.city = dictionary["city"] as? String ?? ""
    self.promo_account = dictionary["promo_account"] as? String ?? ""
    
    //HISTORY
    if let child = dictionary["child"] as? [Dictionary<String, Any>] {
        for i in 0 ..< child.count  {
            let objHistory = MyNetworkUserDetail.init(child[i])
            self.child.append(objHistory)
        }
    }
    
    self.is_deleted = dictionary["is_deleted"] as? String ?? ""
    self.device_token = dictionary["device_token"] as? String ?? ""
    self.address = dictionary["address"] as? String ?? ""
    self.package_amount = dictionary["package_amount"] as? Int ?? 0
    self.is_leader = dictionary["is_leader"] as? String ?? ""
    self.group_sales = dictionary["group_sales"] as? Int ?? 0
    self.total_capital = dictionary["total_capital"] as? Int ?? 0
    self.name = dictionary["name"] as? String ?? ""
    self.secure_password = dictionary["secure_password"] as? String ?? ""
    self.package_id = dictionary["package_id"] as? Int ?? 0
    self.member_group = dictionary["member_group"] as? Int ?? 0
    self.monthly_group_sales = dictionary["monthly_group_sales"] as? Int ?? 0
    self.email_verified_at = dictionary["email_verified_at"] as? String ?? ""
    self.phone_number = dictionary["phone_number"] as? String ?? ""
    self.email = dictionary["email"] as? String ?? ""
    self.sponsor_id = dictionary["sponsor_id"] as? Int ?? 0
    self.fixed_rank = dictionary["fixed_rank"] as? String ?? ""
    self.total_group_sales = dictionary["total_group_sales"] as? Int ?? 0
    self.is_consultant = dictionary["is_consultant"] as? Int ?? 0
    self.device_type = dictionary["device_type"] as? String ?? ""
    self.disabled_commission = dictionary["disabled_commission"] as? String ?? ""
    self.direct_downline = dictionary["direct_downline"] as? Int ?? 0
    self.identification_number = dictionary["identification_number"] as? String ?? ""
    self.username = dictionary["username"] as? String ?? ""
    self.highlight = dictionary["highlight"] as? Bool ?? false
    self.state = dictionary["state"] as? String ?? ""
    self.finger_print = dictionary["finger_print"] as? String ?? ""
    self.first_login = dictionary["first_login"] as? Int ?? 0
    self.updated_at = dictionary["updated_at"] as? String ?? ""
    self.disable_commission = dictionary["disable_commission"] as? String ?? ""
    self.created_at = dictionary["created_at"] as? String ?? ""
    self.login_token = dictionary["login_token"] as? String ?? ""
    self.invest_id = dictionary["invest_id"] as? Int ?? 0
    self.status = dictionary["status"] as? String ?? ""
    self.id = dictionary["id"] as? Int ?? 0
    self.mt4_capital_form_exclude = dictionary["mt4_capital_form_exclude"] as? Int ?? 0
    self.enable_fund_wallet = dictionary["enable_fund_wallet"] as? String ?? ""
    self.finger_uuid = dictionary["finger_uuid"] as? String ?? ""
  }
}

class MyNetowrkUserRankObject: NSObject {
    var id: Int = 0
    var name: String = ""
    var image_url: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.image_url = dictionary["image_url"] as? String ?? ""
    }
}
