//
//  UserObject.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class UserObject: NSObject, Codable {
    var id: Int = 0
    var sponsor_id: Int     = 0
    var name: String     = ""
    var username: String = ""
    var email: String        = ""
    var identification_number: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var country_id: Int = 0
    var phone_number: String = ""
    var signature: String = ""
    var member_group: Int = 0
    var mt4_user_id: String = ""
    var mt4_password: String = ""
    var rank_id: Int = 0
    var package_id: Int = 0
    var invest_id: Int = 0
    var fixed_rank: String = ""
    var promo_account: String = ""
    var downline_user_transfer: String = ""
    var enable_fund_wallet: String = ""
    var disabled_commission: String = ""
    var disable_commission: String = ""
    var status: String = ""
    var email_verified_at: String = ""
    var mt4_capital_form_exclude: Double = 0.0
    var total_capital: Double = 0.0
    var password_otp: String = ""
    var login_token: String = ""
    var device_token: String = ""
    var device_type: String = ""
    var proof_status: String = ""
    var usdt_image: String = ""
    var finger_uuid: String = ""
    var finger_print: String = ""
    var usdt_address: String = ""
    var profile_image: String = ""
    var is_deleted: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var sponsor_name: String = ""
    var balance: Double = 0.0
    var share_link: String = ""
    var is_login: String = ""
    var group_sales: Double = 0.0
    var monthly_group_sales: Double = 0.0
    var rank: String = ""
    var maturity_date: String = ""
    
    class func saveUserData(dict: Dictionary<String, Any>) -> UserObject {
        let objLoginUser = UserObject()
        
        if let id = dict["id"] as? Int {
            objLoginUser.id = id
        }
        if let sponsor_id = dict["sponsor_id"] as? Int {
            objLoginUser.sponsor_id = sponsor_id
        }
        if let name = dict["name"] as? String {
            objLoginUser.name = name
        }
        if let username = dict["username"] as? String {
            objLoginUser.username = username
        }
        if let email = dict["email"] as? String {
            objLoginUser.email = email
        }
        if let identification_number = dict["identification_number"] as? String {
            objLoginUser.identification_number = identification_number
        }
        if let address = dict["address"] as? String {
            objLoginUser.address = address
        }
        if let city = dict["city"] as? String {
            objLoginUser.city = city
        }
        if let state = dict["state"] as? String {
            objLoginUser.state = state
        }
        if let country_id = dict["country_id"] as? Int {
            objLoginUser.country_id = country_id
        }
        if let phone_number = dict["phone_number"] as? String {
            objLoginUser.phone_number = phone_number
        }
        if let signature = dict["signature"] as? String {
            objLoginUser.signature = signature
        }
        if let member_group = dict["member_group"] as? Int {
            objLoginUser.member_group = member_group
        }
        if let mt4_user_id = dict["mt4_user_id"] as? String {
            objLoginUser.mt4_user_id = mt4_user_id
        }
        if let mt4_password = dict["mt4_password"] as? String {
            objLoginUser.mt4_password = mt4_password
        }
        if let rank_id = dict["rank_id"] as? Int {
            objLoginUser.rank_id = rank_id
        }
        if let package_id = dict["package_id"] as? Int {
            objLoginUser.package_id = package_id
        }
        if let invest_id = dict["invest_id"] as? Int {
            objLoginUser.invest_id = invest_id
        }
        if let fixed_rank = dict["fixed_rank"] as? String {
            objLoginUser.fixed_rank = fixed_rank
        }
        if let promo_account = dict["promo_account"] as? String {
            objLoginUser.promo_account = promo_account
        }
        if let downline_user_transfer = dict["downline_user_transfer"] as? String {
            objLoginUser.downline_user_transfer = downline_user_transfer
        }
        if let enable_fund_wallet = dict["enable_fund_wallet"] as? String {
            objLoginUser.enable_fund_wallet = enable_fund_wallet
        }
        if let disabled_commission = dict["disabled_commission"] as? String {
            objLoginUser.disabled_commission = disabled_commission
        }
        if let disable_commission = dict["disable_commission"] as? String {
            objLoginUser.disable_commission = disable_commission
        }
        if let status = dict["status"] as? String {
            objLoginUser.status = status
        }
        if let email_verified_at = dict["email_verified_at"] as? String {
            objLoginUser.email_verified_at = email_verified_at
        }
        if let mt4_capital_form_exclude = dict["mt4_capital_form_exclude"] as? Double {
            objLoginUser.mt4_capital_form_exclude = mt4_capital_form_exclude
        }
        if let total_capital = dict["total_capital"] as? Double {
            objLoginUser.total_capital = total_capital
        }
        if let password_otp = dict["password_otp"] as? String {
            objLoginUser.password_otp = password_otp
        }
        if let login_token = dict["login_token"] as? String {
            objLoginUser.login_token = login_token
        }
        if let device_token = dict["device_token"] as? String {
            objLoginUser.device_token = device_token
        }
        if let device_type = dict["device_type"] as? String {
            objLoginUser.device_type = device_type
        }
        if let proof_status = dict["proof_status"] as? String {
            objLoginUser.proof_status = proof_status
        }
        if let usdt_image = dict["usdt_image"] as? String {
            objLoginUser.usdt_image = usdt_image
        }
        if let finger_uuid = dict["finger_uuid"] as? String {
            objLoginUser.finger_uuid = finger_uuid
        }
        if let finger_print = dict["finger_print"] as? String {
            objLoginUser.finger_print = finger_print
        }
        if let usdt_address = dict["usdt_address"] as? String {
            objLoginUser.usdt_address = usdt_address
        }
        if let profile_image = dict["profile_image"] as? String {
            objLoginUser.profile_image = profile_image
        }
        if let is_deleted = dict["is_deleted"] as? String {
            objLoginUser.is_deleted = is_deleted
        }
        if let created_at = dict["created_at"] as? String {
            objLoginUser.created_at = created_at
        }
        if let updated_at = dict["updated_at"] as? String {
            objLoginUser.updated_at = updated_at
        }
        if let sponsor_name = dict["sponsor_name"] as? String {
            objLoginUser.sponsor_name = sponsor_name
        }
        if let balance = dict["balance"] as? Double {
            objLoginUser.balance = balance
        }
        if let share_link = dict["share_link"] as? String {
            objLoginUser.share_link = share_link
        }
        if let is_login = dict["is_login"] as? String {
            objLoginUser.is_login = is_login
        }
        if let group_sales = dict["group_sales"] as? Double {
            objLoginUser.group_sales = group_sales
        }
        if let monthly_group_sales = dict["monthly_group_sales"] as? Double {
            objLoginUser.monthly_group_sales = monthly_group_sales
        }
        if let rank = dict["rank"] as? String {
            objLoginUser.rank = rank
        }
        if let maturity_date = dict["maturity_date"] as? String {
            objLoginUser.maturity_date = maturity_date
        }
        
        return objLoginUser
    }
}
