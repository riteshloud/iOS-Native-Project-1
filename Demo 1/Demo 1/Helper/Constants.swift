// 
//  Constants.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import Localize_Swift

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let defaults = UserDefaults.standard

let kIsUserLoggedIn     = "is_userLoggedIn"
let kLoggedInUserData   = "user_data"

let webViewSource: String = "var meta = document.createElement('meta');" +
"meta.name = 'viewport';" +
"meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
"var head = document.getElementsByTagName('head')[0];" +
"head.appendChild(meta);"

let APP_NAME = "Demo 1".localized()
let DEVICE_TYPE = "ios"
var INTERNET_UNAVAILABLE = "Please check your internet connection and try again.".localized()
var NETWORK_ERROR = "Sorry we are unable to connect with the server, please try again later".localized()

let randomUUID = "UUID"
let isBiometricDialogDiplayed = "isBiometricDialogDisplay"
var noBiometricSupport = "Biometric is not supported or not setup in your device.".localized()
let isReauthDialogDisplayed = "isReauthDialogDisplayed"
let isAnnouncementDisplayed = "isAnnouncementDisplayed"

var FallbackTitle = "Please use your Passcode".localized()
var reasonString = "Authentication required to access the secure data".localized()


//MARK:- URL

//DEV SERVER
//let BASE_URL = ""

//LIVE SERVER
let BASE_URL = ""

struct URLS {
    static let GET_COMMON_LIST = ""
    static let LOGIN = ""
    static let REGISTER = ""
    static let VERIFY_SPONSER = ""
    static let FORGOT_PASSWORD = ""
    static let GET_USER_DASHBOARD = ""
    static let GET_SUPPORT_TICKETS_ALL = ""
    static let GET_SUPPORT_TICKETS_OPEN = ""
    static let GET_SUPPORT_TICKETS_CLOSE = ""
    static let CLOSE_TICKET = ""
    static let CREATE_NEW_TICKET = ""
    static let GET_SUPPORT_MESSAGES = ""
    static let REPLY_SUPPORT_MESSAGES = ""
    static let NEWS_LIST = ""
    static let GET_FAQ = ""
    static let GET_MYNETWORK = ""
    static let GET_GROUP_SALES = ""
    static let REGISTER_USER = ""
    
    static let ENABLE_FINGERPRINT = ""
    static let SEND_OTP_VERIFICATION = ""
    static let VERIFY_FINGERPRINT_CODE = ""
    static let LOGOUT = ""
    
    static let ACCOUNT_DETAILS = ""
    static let SEND_OTP = ""
    static let UPDATE_PASSWORD = ""
    static let UPDATE_PROFILE = ""
    static let UPGRADE_PACKAGE = ""
    
    static let UPLOAD_USER_PROOF = ""
    
    static let CASH_WALLET_HISTORY = ""
    static let TRANSFER_MONEY = ""
    static let TRANSFER_MT5_MONEY = ""
    
    static let CAPITAL_WITHDRAWAL_HISTORY = ""
    static let CAPITAL_WITHDRAWAL_REQUEST = ""
    static let TOPUP_FUND_HISTORY = ""
    static let FUND_WALLET_TOPUP = ""
    static let CANCEL_FUND_REQUEST = ""
    static let WITHDRAWAL_WALLET_HISTORY = ""
    static let WITHDRAWAL_WALLET_REQUEST = ""
    static let SEND_MAIL_WITHDRAWAL_REQUEST = ""
    
    static let REPORT_TOTAL_HISTORY = ""
    static let TRADING_PROFIT_HISTORY = ""
    static let LOT_REBATE_HISTORY = ""
    static let LOT_REBATE_COMMISSION_HISTORY = ""
    static let LOT_REBATE_COMMISSION_BREAKDOWN = ""
    static let LEADERSHIP_BONUS_HISTORY = ""
    static let LEADERSHIP_BONUS_BREAKDOWN = ""
    static let PROFIT_SHARING_HISTORY = ""
    static let PROFIT_SHARING_BREAKDOWN = ""
    
    static let REPORTS = ""
    
    //STOCK MARKET
    static let GETMARKETLIST = ""
    static let MARKET_DETAIL = ""
    static let INVEST = ""
    static let CLOSE_INVESTMENT = ""
    static let MARKET_DETAIL_STATS = ""
    static let MARKET_DETAIL_INVESTMENT_HISTORY = ""
    static let MARKET_DETAIL_PORTFOLIO = ""
    static let MARKET_DETAIL_CHARTS = ""
    
    //STOCK WALLET
    static let STOCK_WALLET_DATA = ""
    static let STOCK_WALLET_HISTORY = ""
    static let STOCK_WALLET_TOPUP = ""
    static let STOCK_WALLET_TRANSFER_MONEY = ""
    static let CANCEL_STOCK_FUND_REQUEST = ""
    static let INVESTMENT_LIST = ""
    static let CHANGE_INVESTMENT = ""
}

//MARK:- COLOR
struct Colors {
    static let themeColor               = UIColor.init(hexString: "6E7F8D")!
    static let dashboardSeperatorColor  = UIColor.init(hexString: "1DAFBB")!
    static let textPinkColor            = UIColor.init(hexString: "D71D38")!
    static let termColor                = UIColor.init(hexString: "888888")!
    static let blueColor                = UIColor.init(hexString: "006DFF")!
    static let evenRowColor             = UIColor.init(hexString: "F7F7F9")!
    static let oddRowColor              = UIColor.init(hexString: "FFFFFF")!
    static let openTicketColor          = UIColor.init(hexString: "55CC48")!
    static let closeTicketColor         = UIColor.init(hexString: "FF3131")!
    static let ticketDateColor          = UIColor.init(hexString: "17B978")!
    static let seperatorColor           = UIColor.init(hexString: "6F6F78")!
    
    static let pendingColor             = UIColor.init(hexString: "F8AC59")!
    static let approvedColor            = UIColor.init(hexString: "00CE7D")!
    static let cellRedColor             = UIColor.init(hexString: "E55541")!
    static let announcementTextBGColor  = UIColor.init(hexString: "00969E")!
    
    static let buttonRedColor               = UIColor.init(hexString: "E0242F")!
    static let collectionCurrentItemColor   = UIColor.init(hexString: "1BADB8")!
    static let navigationBGColor        = UIColor.init(hexString: "081D25")!
    static let viewBGColor              = UIColor.init(hexString: "151618")!
    static let labelShadowColor         = UIColor.init(hexString: "00DDF9")!
    
    static let reportsCellColor         = UIColor.init(hexString: "1D2024")!
    
    static let barColor                 = UIColor.init(hexString: "45AAF2")!
    static let riskScoreMaxColor        = UIColor.init(hexString: "434348")!
}

//MARK:- FONT
struct Fonts {
    static let PoppinsBold          = "Poppins-Bold"
    static let PoppinsLight         = "Poppins-Light"
    static let PoppinsMedium        = "Poppins-Medium"
    static let PoppinsRegular       = "Poppins-Regular"
}

struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_11_PRO_MAX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
}

enum REQUEST : Int {
    case notStarted = 0
    case started
    case failedORNoMoreData
}

//MARK:- NOTIFICATIONCENTER KEY
let selectDashboardOption = "selectDashboardOption"
let clearSelectionOption = "clearSelectionOption"
let refreshCapitalWithdrawalScreen = "refreshCapitalWithdrawalDetail"
let selectTopupFundOption = "selectTopupFundOption"
let selectReportSubOption = "selectReportSubOption"

//MARK:- LANGUAGE
enum Language: String {
    case English            = "English"
    case Chinese            = "中文(Chinese)"
    case ChineseTraditional = "中文(Chinese Traditional)"
    case Korean             = "한국어(Korean)"
    case Thai               = "ไทย(Thai)"
    case Vietnam            = "Việt Nam(Vietnam)"
}

struct Document {
    let uploadParameterKey: String
    let data: Data
    let name: String
    let fileName: String
    let mimeType: String
    var image: UIImage?
}

//MARK:- DEVICE
enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone
    case pad
}

//NOTIFICATIONCENTER KEYS
let kCurrentLanguage = "userLanguage"


