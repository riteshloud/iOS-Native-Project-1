//
//  GlobalData.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import Foundation
import Reachability
import Alamofire
import LocalAuthentication
import SVProgressHUD

class GlobalData {
    
    var objConfiguration = ConfigDataObject.init([:])
    
    var currrentUser = UserObject()
    
    var configData:[String:Any] = [:]
    var userData:[String:Any] = [:]
    
    var selectedWithdrawalType: WithdrawalType = .bankTransfer
    
    var arrLanguages: [String] = [Language.English.rawValue, Language.Chinese.rawValue, Language.ChineseTraditional.rawValue, Language.Korean.rawValue, Language.Thai.rawValue, Language.Vietnam.rawValue]
    
    //Once Biometric is locked out due to multiple incorrect attemp LAContext().biometricType returns me only type not the error code
    var nBiometricErrorCode: Int = 0
    
    var dashboardData: [String : Any] = [:]
        
    class var shared: GlobalData {
        struct Singleton {
            static let instance = GlobalData()
        }
        return Singleton.instance
    }
        
    func checkInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    //MARK:- SVProgressHUD
    func customizationSVProgressHUD() {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.30))
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16.0))
        SVProgressHUD.setRingRadius(18)
        
        SVProgressHUD.setRingThickness(2.5)
        SVProgressHUD.setCornerRadius(10.0)
    }
    
    class func showDefaultProgress() {
        SVProgressHUD.show()
    }
    
    class func showProgressWithTitle(title: String) {
        SVProgressHUD.show(withStatus: title)
    }
        
    class func hideProgress() {
        SVProgressHUD.dismiss()
    }
    
    func showLightStyleToastMesage(message :String) {
        var style = ToastStyle()
        style.backgroundColor = .white
        style.messageColor = .black
        appDelegate.window?.makeToast(message, duration: 4.0, position: .bottom, title: nil, image: nil, style: style, completion: nil)
    }
    
    func showLightStyleToastMesageFor30Seconds(message :String) {
        var style = ToastStyle()
        style.backgroundColor = .white
        style.messageColor = .black
        appDelegate.window?.makeToast(message, duration: 30.0, position: .bottom, title: nil, image: nil, style: style, completion: nil)
    }
    
    func hideAllToast() {
        appDelegate.window?.hideAllToasts()
    }
    
    func showLightStyleToastMessageFor5Seconds(message :String) {
        var style = ToastStyle()
        style.backgroundColor = .black
        style.messageColor = .white
        appDelegate.window?.makeToast(message, duration: 4.0, position: .bottom, title: nil, image: nil, style: style, completion: nil)
    }
    
    func showInvalidToken(message: String) {
        let alert = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: { action in
            appDelegate.logoutUser()
        }))
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func stringFromstring(str: String) -> String{
        let delimiter = " "
        let token = str.components(separatedBy: delimiter)
        var finalString = ""
        for i in 0..<token.count{
            let letter = token[i].first
            finalString = finalString + "\(letter!)"
        }
        return finalString
    }
    
    //MARK:- HOTEL MODULE
    func getHotelBookingTempCheckInDate() -> String {
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 2, to: today)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let strCheckInDate = dateFormatter.string(from: nextDate!)
        return strCheckInDate
    }
    
    func getHotelBookingTempCheckOutDate() -> String {
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 3, to: today)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let strCheckOutDate = dateFormatter.string(from: nextDate!)
        return strCheckOutDate
    }
    
    func stringToDate(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy" //Your date format
        //according to date format your date string
        guard let date = dateFormatter.date(from: strDate) else {
            fatalError()
        }
        return date
    }
    
    func fullStringDateToSmallStringDate(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        //according to date format your date string
        guard let date = dateFormatter.date(from: strDate) else {
            fatalError()
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your New Date format as per requirement change it own
        let strOutput =  dateFormatter.string(from: date) //pass Date here
        return strOutput
    }
    
    func fullStringDateToSmallStringDateWithMonth(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        //according to date format your date string
        guard let date = dateFormatter.date(from: strDate) else {
            fatalError()
        }
        
        dateFormatter.dateFormat = "dd MMM yyyy" //Your New Date format as per requirement change it own
        let strOutput =  dateFormatter.string(from: date) //pass Date here
        return strOutput
    }
    
    func stringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let myString = dateFormatter.string(from: date)
        guard let date = dateFormatter.date(from: myString) else {
            return ""
        }

        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd"
        return newDateFormatter.string(from: date)
    }
    
    
    func dateToShortString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getNumberOfDaysBetween2Date(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let dtStart = calendar.startOfDay(for: date1)
        let dtEnd = calendar.startOfDay(for: date2)

        let components = calendar.dateComponents([.day], from: dtStart, to: dtEnd)
        return components.day!
    }
    
    func getDayOfWeek(today: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)
        formatter.dateFormat = "dd MMM"
        let nameOfMonth = formatter.string(from: todayDate!)
        return String("\(nameOfMonth)")
    }
    
    func getShortDateFromLong(date: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let todayDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy-MM-dd"
        let nameOfMonth = formatter.string(from: todayDate!)
        return String("\(nameOfMonth)")
    }
    
    func getShortDay(today: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)
        formatter.dateFormat = "dd-MM"
        let nameOfMonth = formatter.string(from: todayDate!)
        return String("\(nameOfMonth)")
    }
    
    func getMonthOnly(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getMonthYear(date: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: date)
        formatter.dateFormat = "MMM, yyyy"
        let nameOfMonth = formatter.string(from: todayDate!)
        return String("\(nameOfMonth)")
    }
    
    //MARK:- Generate QR Code from String
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    //MARK: - Convert Param To JSON
    func convertParameter(inJSONString dict: [AnyHashable: Any]) -> String {
        var jsonString = ""
        
        defer {
        }
        
        do{
            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: [])
            if jsonData == nil {
                debugPrint("Error While converting Dictionary tp JSON String.")
                throw MyError.FoundNil("xmlDict")
            }
            else {
                jsonString = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
            }
        } catch {
            debugPrint("error getting xml string: \(error)")
        }
        
//        do {
//            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: [])
//            if jsonData == nil {
//                debugPrint("Error While converting Dictionary tp JSON String.")
//            }
//            else {
//                jsonString = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
//            }
//        } catch let exception {
//            debugPrint("exception: \(exception)")
//        }
        return jsonString
    }
    
    func getAndSetAttributedText(boldString: String, normalString: String) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font : UIFont(name: "PingFangSC-Semibold", size: 13)]
        let attributedString = NSMutableAttributedString(string:boldString, attributes:attrs as [NSAttributedString.Key : Any])
        let normalText = NSMutableAttributedString(string:normalString)
        attributedString.append(normalText)
        return attributedString
    }
    
    
    func generateRandomUUID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    //MARK:- Biometric related functions
    func authenticateTouchIDGlobally(completion: @escaping (Bool) -> Void) {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = FallbackTitle
        
        var authError: NSError?
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
                else {
                    guard let error = evaluateError else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(false)
                        if error._code == -2 || error._code == -4 || error._code == -1004 {
                            
                        }
                        else {
                            self.showLightStyleToastMesage(message: (GlobalData.shared.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code)))
                        }
                    }
                }
            }
        }
        else {
            guard let error = authError else {
                return
            }
            DispatchQueue.main.async {
                completion(false)
                if error._code == -2 || error._code == -4 || error._code == -1004 {
                    
                }
                else {
                    self.showLightStyleToastMessageFor5Seconds(message: (GlobalData.shared.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code)))
                }
            }
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication.".localized()
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times.".localized()
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication.".localized()
                
            default:
                message = "".localized()
            }
        }
        else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts.".localized()
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device".localized()
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device".localized()
                
            default:
                message = "".localized()
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials".localized()
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application".localized()
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive".localized()
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device".localized()
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system".localized()
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel".localized()
            
        case LAError.userFallback.rawValue:
            message = "The user choose to use the fallback".localized()
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
    
    func saveUUIDinUserDefault(strUUID: String) {
        DispatchQueue.main.async {
            defaults.setValue(strUUID, forKey: randomUUID)
            defaults.synchronize()
        }
    }
    
    func removeUUIDFromUserDefault() {
        DispatchQueue.main.async {
            defaults.setValue("", forKey: randomUUID)
            defaults.synchronize()
        }
    }
    
    func getSavedUUIDFromUserDefault() -> String {
        if let strUUID: String = defaults.value(forKey: randomUUID) as? String {
            if !strUUID.isEmpty {
                return strUUID
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
    }
    
    func isUUIDExistInUserDefault() -> Bool {
        if let strUUID: String = defaults.value(forKey: randomUUID) as? String {
            if !strUUID.isEmpty {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    func removePercentageSignFromString(strValue: String) -> String {
        let charsToRemove: Set<Character> = Set("%")
        let newString = String(strValue.filter { !charsToRemove.contains($0) })
        return newString
    }
    
    // MARK: - UIStoryboard -
    class func mainStoryBoard() -> UIStoryboard {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryBoard
    }
    
    class func tabBarStoryBoard() -> UIStoryboard {
        let tabBarStoryBoard = UIStoryboard(name: "TabBar", bundle: nil)
        return tabBarStoryBoard
    }
    
    class func dashboardStoryBoard() -> UIStoryboard {
        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        return dashboardStoryBoard
    }
    
    class func ticketStoryBoard() -> UIStoryboard {
        let ticketStoryBoard = UIStoryboard(name: "Ticket", bundle: nil)
        return ticketStoryBoard
    }
    
    class func leftMenuStoryBoard() -> UIStoryboard {
        let leftMenuStoryBoard = UIStoryboard(name: "LeftMenu", bundle: nil)
        return leftMenuStoryBoard
    }
    
    class func myNetworkStoryBoard() -> UIStoryboard {
        let myNetworkStoryBoard = UIStoryboard(name: "My Network", bundle: nil)
        return myNetworkStoryBoard
    }
    
    class func myProfileStoryBoard() -> UIStoryboard {
        let myProfileStoryBoard = UIStoryboard(name: "My Profile", bundle: nil)
        return myProfileStoryBoard
    }
    
    class func fundingStoryBoard() -> UIStoryboard {
        let fundingStoryBoard = UIStoryboard(name: "Funding", bundle: nil)
        return fundingStoryBoard
    }
    
    class func withdrawalStoryBoard() -> UIStoryboard {
        let withdrawalStoryBoard = UIStoryboard(name: "Withdrawal", bundle: nil)
        return withdrawalStoryBoard
    }
    
    class func selfTradingStoryBoard() -> UIStoryboard {
        let selfTradingStoryBoard = UIStoryboard(name: "SelfTrading", bundle: nil)
        return selfTradingStoryBoard
    }
    
    class func reportStoryBoard() -> UIStoryboard {
        let reportStoryBoard = UIStoryboard(name: "Reports", bundle: nil)
        return reportStoryBoard
    }
    
    class func stockMarketStoryBoard() -> UIStoryboard {
        let stockMarketStoryBoard = UIStoryboard(name: "StockMarket", bundle: nil)
        return stockMarketStoryBoard
    }
    
    class func stockWalletStoryBoard() -> UIStoryboard {
        let stockWalletStoryBoard = UIStoryboard(name: "StockWallet", bundle: nil)
        return stockWalletStoryBoard
    }
    
    func getAttributedString(myString: String) -> NSAttributedString {
        let strValues = myString.components(separatedBy: "/")
        
        let attributedString = NSMutableAttributedString(string: myString)
        let immutableString = myString
        
        let boldRange = (immutableString as NSString).range(of: strValues[0])
        let normalRange = (immutableString as NSString).range(of: strValues[1])
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.init(name: Fonts.PoppinsLight, size: 13.0)!], range: boldRange)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.init(name: Fonts.PoppinsLight, size: 12.0)!], range: normalRange)
        return attributedString
    }
}

public extension UIApplication {
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
}

enum MyError: Error {
    case FoundNil(String)
}
