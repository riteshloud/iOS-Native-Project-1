//
//  AFWrapper.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AFWrapper: NSObject {
    class func requestGETURL(_ strURL: String, paramters: [String: Any]? = nil, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        debugPrint(strURL)
        
        var headers: Dictionary<String, String> = Dictionary<String, String>()
        var languageCode = "en"
        if defaults.object(forKey: kCurrentLanguage) as! String == Language.Chinese.rawValue {
            languageCode = "cn"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.ChineseTraditional.rawValue {
            languageCode = "cn_tr"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Korean.rawValue {
            languageCode = "ko"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Thai.rawValue {
            languageCode = "th"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Vietnam.rawValue {
            languageCode = "vi"
        }
        headers["X-localization"] = languageCode
        if defaults.object(forKey: "_token") != nil {
            headers["Authorization"] = "Bearer \(defaults.object(forKey: "_token") as! String)"
        }
        
        debugPrint(headers)
        
        Alamofire.request(strURL, method: .get, parameters: paramters, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (responseString: DataResponse<String>) in
            //debugPrint(responseString)
        }).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                debugPrint(resJson)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                debugPrint(error)
                failure(error)
            }
        }
    }
    
    class func requestGETURLWithParam(_ strURL: String, params : [String : AnyObject]?,  success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        debugPrint(strURL)
        
        var headers: Dictionary<String, String> = Dictionary<String, String>()
        var languageCode = "en"
        if defaults.object(forKey: kCurrentLanguage) as! String == Language.Chinese.rawValue {
            languageCode = "cn"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.ChineseTraditional.rawValue {
            languageCode = "cn_tr"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Korean.rawValue {
            languageCode = "ko"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Thai.rawValue {
            languageCode = "th"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Vietnam.rawValue {
            languageCode = "vi"
        }
        headers["X-localization"] = languageCode
        if defaults.object(forKey: "_token") != nil {
            headers["Authorization"] = "Bearer \(defaults.object(forKey: "_token") as! String)"
        }
        
        debugPrint(headers)
        
        Alamofire.request(strURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (responseString: DataResponse<String>) in
            //debugPrint(responseString)
        }).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                debugPrint(resJson)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                debugPrint(error)
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        debugPrint(strURL)
        
        var headers: Dictionary<String, String> = Dictionary<String, String>()
        var languageCode = "en"
        if defaults.object(forKey: kCurrentLanguage) as! String == Language.Chinese.rawValue {
            languageCode = "cn"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.ChineseTraditional.rawValue {
            languageCode = "cn_tr"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Korean.rawValue {
            languageCode = "ko"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Thai.rawValue {
            languageCode = "th"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Vietnam.rawValue {
            languageCode = "vi"
        }
        headers["X-localization"] = languageCode
        if defaults.object(forKey: "_token") != nil {
            headers["Authorization"] = "Bearer \(defaults.object(forKey: "_token") as! String)"
        }
        
        debugPrint(headers)
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (responseString: DataResponse<String>) in
            //debugPrint(responseString)
        }).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                debugPrint(resJson)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                debugPrint(error)
                failure(error)
            }
        }
    }
    
    class func postWithUploadImage(_ fileData: NSData, isPDF: Bool ,strURL : String, params : [String : AnyObject]?, headers : [String : String]?, isUploadBankProof: Bool, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        debugPrint(strURL)
        
        var headers: Dictionary<String, String> = Dictionary<String, String>()
        var languageCode = "en"
        if defaults.object(forKey: kCurrentLanguage) as! String == Language.Chinese.rawValue {
            languageCode = "cn"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.ChineseTraditional.rawValue {
            languageCode = "cn_tr"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Korean.rawValue {
            languageCode = "ko"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Thai.rawValue {
            languageCode = "th"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Vietnam.rawValue {
            languageCode = "vi"
        }
        headers["X-localization"] = languageCode
        if defaults.object(forKey: "_token") != nil {
            headers["Authorization"] = "Bearer \(defaults.object(forKey: "_token") as! String)"
        }
        
        debugPrint(headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
            
            if isPDF {
                if isUploadBankProof {
                    multipartFormData.append(fileData as Data, withName: "bank_proof", fileName: "\(Int64(Date().timeIntervalSince1970 * 1000.0))__bankProof.pdf", mimeType: "application/pdf")
                }
                else {
                    multipartFormData.append(fileData as Data, withName: "usdt_proof", fileName: "\(Int64(Date().timeIntervalSince1970 * 1000.0))__usdtProof.pdf", mimeType: "application/pdf")
                }
            } else {
                if isUploadBankProof {
                    multipartFormData.append(fileData as Data, withName: "bank_proof", fileName: "\(Int64(Date().timeIntervalSince1970 * 1000.0))_bankProof.jpg", mimeType: "image/jpeg")
                }
                else {
                    multipartFormData.append(fileData as Data, withName: "usdt_proof", fileName: "\(Int64(Date().timeIntervalSince1970 * 1000.0))_usdtProof.jpg", mimeType: "image/jpeg")
                }
            }
            
            for (key, value) in params! {
                multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8)!, withName: key)
            }
           
        }, to: strURL, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseString(completionHandler: { (response: DataResponse<String>) in
                    //debugPrint(response)
                })
                
                upload.responseJSON {  responseObject in
                    
                    upload.responseJSON(completionHandler: { (responseObject) -> Void in
                        
                        if responseObject.result.isSuccess {
                            let resJson = JSON(responseObject.result.value!)
                            debugPrint(resJson)
                            success(resJson)
                        }
                        if responseObject.result.isFailure {
                            let error : Error = responseObject.result.error!
                            debugPrint(error)
                            failure(error)
                        }
                    })
                }
            case .failure(_):
                debugPrint("failure")
            }
        })
    }
    
    class func postWithUploadMultipleFiles(_ files: [Document], strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        debugPrint("\(strURL) request: \(params ?? [:])")
        
        var headers: Dictionary<String, String> = Dictionary<String, String>()
        var languageCode = "en"
        if defaults.object(forKey: kCurrentLanguage) as! String == Language.Chinese.rawValue {
            languageCode = "cn"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.ChineseTraditional.rawValue {
            languageCode = "cn_tr"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Korean.rawValue {
            languageCode = "ko"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Thai.rawValue {
            languageCode = "th"
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Vietnam.rawValue {
            languageCode = "vi"
        }
        headers["X-localization"] = languageCode
        if defaults.object(forKey: "_token") != nil {
            headers["Authorization"] = "Bearer \(defaults.object(forKey: "_token") as! String)"
        }

        debugPrint(headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
            
            for file in files {
                multipartFormData.append(file.data, withName: file.uploadParameterKey, fileName: file.fileName, mimeType: file.mimeType)
            }
            if let params = params {
                for (key, value) in params {
                    multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
           
        }, to: strURL, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseString(completionHandler: { (response: DataResponse<String>) in
                    //debugPrint(response)
                })
                
                upload.responseJSON {  responseObject in
                    
                    upload.responseJSON(completionHandler: { (responseObject) -> Void in
                        
                        if responseObject.result.isSuccess {
                            let resJson = JSON(responseObject.result.value!)
                            debugPrint(resJson)
                            success(resJson)
                        }
                        if responseObject.result.isFailure {
                            let error : Error = responseObject.result.error!
                            debugPrint(error)
                            failure(error)
                        }
                    })
                }
            case .failure(_):
                debugPrint("failure")
            }
        })
    }
}


