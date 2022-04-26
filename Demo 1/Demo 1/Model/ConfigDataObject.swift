//
//  ConfigDataObject.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class ConfigDataObject: NSObject {
    var terms_and_conditions_content: String    = ""
    var agreement_content: String               = ""
    var terms_and_condition: String             = ""
    var privacy_policy: String                  = ""
    var AML_Polerms_ficy_Statement: String      = ""
    var Risk_Disclosure_Statemen: String        = ""
    var User_Agreement: String                  = ""
    
    var arrCountryList: [CountryObject]         = []
    var arrPackageList: [PackageObject]         = []
    var arrAgreementList: [AgreementObject]     = []
    
    init(_ dictionary: [String: Any]) {
        self.terms_and_conditions_content   = dictionary["terms_and_conditions_content"] as? String ?? ""
        self.agreement_content              = dictionary["agreement_content"] as? String ?? ""
        self.terms_and_condition            = dictionary["terms_and_condition"] as? String ?? ""
        self.privacy_policy                 = dictionary["privacy_policy"] as? String ?? ""
        self.AML_Polerms_ficy_Statement     = dictionary["AML_Polerms_ficy_Statement"] as? String ?? ""
        self.Risk_Disclosure_Statemen       = dictionary["Risk_Disclosure_Statemen"] as? String ?? ""
        self.User_Agreement                 = dictionary["User_Agreement"] as? String ?? ""
        
        //COUNTRY LIST
        if let country_list = dictionary["country_list"] as? [Dictionary<String, Any>] {
            for i in 0..<country_list.count  {
                let objCountry = CountryObject.init(country_list[i])
                self.arrCountryList.append(objCountry)
            }
        }
        
        //PACKAGE LIST
        if let package_list = dictionary["package_list"] as? [Dictionary<String, Any>] {
            for i in 0..<package_list.count  {
                let objPackage = PackageObject.init(package_list[i])
                self.arrPackageList.append(objPackage)
            }
        }
        
        //AGREEMENT LIST
        if let agreements = dictionary["agreements"] as? [Dictionary<String, Any>] {
            for i in 0..<agreements.count  {
                let objAgreement = AgreementObject.init(agreements[i])
                self.arrAgreementList.append(objAgreement)
            }
        }
    }
}

//MARK:- COUNTRY OBJECT
struct CountryObject {
    var id: Int                 = 0
    var country_code: String    = ""
    var country_name: String    = ""
    var created_at: String      = ""
    var updated_at: String      = ""
    
    init(_ dictionary: [String: Any]) {
        self.id             = dictionary["id"] as? Int ?? 0
        self.country_code   = dictionary["country_code"] as? String ?? ""
        self.country_name   = dictionary["country_name"] as? String ?? ""
        self.created_at     = dictionary["created_at"] as? String ?? ""
        self.updated_at     = dictionary["updated_at"] as? String ?? ""
    }
}

//MARK:- PACKAGE OBJECT
struct PackageObject {
    var id: Int             = 0
    var name: String        = ""
    var amount: Double      = 0.0
    var label: Int          = 0
    var value: Int          = 0
    var status: String      = ""
    var is_deleted: String  = ""
    var created_at: String  = ""
    var updated_at: String  = ""
    
    init(_ dictionary: [String: Any]) {
        self.id         = dictionary["id"] as? Int ?? 0
        self.name       = dictionary["name"] as? String ?? ""
        self.amount     = dictionary["amount"] as? Double ?? 0.0
        self.label      = dictionary["label"] as? Int ?? 0
        self.value      = dictionary["value"] as? Int ?? 0
        self.status     = dictionary["status"] as? String ?? ""
        self.is_deleted = dictionary["is_deleted"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""
    }
}

//MARK:- AGREEMENT OBJECT
struct AgreementObject {
    var name: String    = ""
    var link: String    = ""
    
    init(_ dictionary: [String: Any]) {
        self.name       = dictionary["name"] as? String ?? ""
        self.link     = dictionary["link"] as? String ?? ""
    }
}
