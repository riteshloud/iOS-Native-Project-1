//
//  LoginVC.swift
//  Demo 1
//
//  Created by Demo on 21/04/22.
//  Copyright © 2022 Demo. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import Localize_Swift
import SwiftValidators

class LoginVC: UIViewController {
    
    @IBOutlet weak var scrollVW: UIScrollView!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwInnerContent: UIView!
    @IBOutlet weak var lblLoginTopYourPortal: UILabel!
    @IBOutlet weak var vwLanguage: UIView!
    @IBOutlet weak var lblLanguage: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var ivRemeber: UIImageView!
    @IBOutlet weak var lblRemeberme: UILabel!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var vwBiometric: UIView!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblBiometricInfo: UILabel!
    @IBOutlet weak var btnFingerprint: UIButton!
    
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var btnSignUpNow: UIButton!
    
    @IBOutlet weak var lblRead: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var lblDot: UILabel!
    
    @IBOutlet weak var lblCopyrightText: UILabel!
    
    var languageDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "rememberEnable") {
            self.ivRemeber.image = UIImage(named: "ic_checkbox")
            self.txtUsername.text = (defaults.object(forKey: "rememberUsername") as! String)
            self.txtPassword.text = (defaults.object(forKey: "rememberPassword") as! String)
        }
        self.lblLanguage.text = (defaults.value(forKey: kCurrentLanguage) as! String)
        self.setupLanguageDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavitationBar()
        self.lblLanguage.text = (defaults.value(forKey: kCurrentLanguage) as! String)
        self.setupLanguageDropDown()
        self.setupLayout()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if let strPreviousUUID = defaults.value(forKey: randomUUID) as? String  {
            if strPreviousUUID.isEmpty {
                self.vwBiometric.isHidden = true
            }
            else {
                self.vwBiometric.isHidden = false
            }
        }
        else {
            self.vwBiometric.isHidden = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Setup NavigationBar
    func setUpNavitationBar() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.clipsToBounds = true
        
        let logo = #imageLiteral(resourceName: "ic_logo_small")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        let btnBack = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_white"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = btnBack
    }
    
    func setupLayout() {
        self.lblLoginTopYourPortal.text = "Login to Your Portal".localized()
        self.txtUsername.placeholder = "Username".localized()
        self.txtUsername.placeHolderColor = .white
        self.txtPassword.placeholder = "Password".localized()
        self.txtPassword.placeHolderColor = .white
        self.lblRemeberme.text = "Remember me".localized()
        self.btnLogin.setTitle("Login".localized(), for: [])
        self.lblOr.text = "Or".localized()
        self.lblBiometricInfo.text = "Tap to login using biometric authentication.".localized()
        self.lblForgotPassword.text = "Forgot Your Password?".localized()
        self.lblDontHaveAccount.text = "Don't have an account?".localized()
        self.btnSignUpNow.setTitle("Signup now".localized(), for: [])
        
        self.lblRead.text = "Read".localized()
        self.lblAnd.text = "and".localized()
        let attrs = [
            NSAttributedString.Key.font : UIFont.init(name: Fonts.PoppinsRegular, size: 14)!,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
        let termsAttributedString = NSMutableAttributedString(string: "terms".localized(), attributes:attrs)
        self.btnTerms.setAttributedTitle(termsAttributedString, for: .normal)
        
        let privacyAttributedString = NSMutableAttributedString(string: "privacy policy".localized(), attributes:attrs)
        self.btnPrivacyPolicy.setAttributedTitle(privacyAttributedString, for: .normal)
        
        self.lblDot.text = "."
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let strCurrentYear = formatter.string(from: Date())
        
        self.lblCopyrightText.text = "Copyright".localized() + " " + "©" + "\(strCurrentYear)" + " " + "Demo 1".localized() + " | " + "All Right Reserved".localized()
    }
    
    //MARK:- SETUP DropDown
    func setupLanguageDropDown() {
        self.languageDropDown = DropDown()
        
        self.languageDropDown.cellHeight = 44
        self.languageDropDown.backgroundColor = .white
        self.languageDropDown.selectionBackgroundColor = Colors.evenRowColor
        self.languageDropDown.textColor = .black
        self.languageDropDown.selectedTextColor = .black
        
        self.languageDropDown.anchorView = self.vwLanguage
        self.languageDropDown.direction = .any
        self.languageDropDown.dataSource = GlobalData.shared.arrLanguages
        
        self.languageDropDown.bottomOffset = CGPoint(x: 0, y:(self.languageDropDown.anchorView?.plainView.bounds.height)!)
        self.languageDropDown.textFont = UIFont(name: Fonts.PoppinsRegular, size: 14)!
        
        guard let index = GlobalData.shared.arrLanguages.firstIndex(of: self.lblLanguage.text ?? GlobalData.shared.arrLanguages[0]) else { return }
        self.languageDropDown.selectRow(index)
        
        self.languageDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.lblLanguage.text = item
            defaults.set(self.lblLanguage.text!, forKey: kCurrentLanguage)
            defaults.synchronize()
            appDelegate.setupUserLanguage()
            self.setupLayout()
            
            self.getConfigData()
        }
    }
    
    //MARK:- UIButton Action
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLanguageTapped(_ sender: UIButton) {
        self.languageDropDown.show()
    }
    
    @IBAction func btnRememberMeTapped(_ sender: Any) {
        self.view.endEditing(true)
        if self.ivRemeber.image == UIImage(named: "ic_checkbox") {
            self.ivRemeber.image = UIImage(named: "ic_uncheckbox")
        } else {
            self.ivRemeber.image = UIImage(named: "ic_checkbox")
        }
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let usertrimmedString = self.txtUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordtrimmedString = self.txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Validator.required().apply(usertrimmedString) {
            GlobalData.shared.showLightStyleToastMesage(message: "Please provide username!".localized())
        }
        else if !Validator.required().apply(passwordtrimmedString) {
            GlobalData.shared.showLightStyleToastMesage(message: "Please provide password!".localized())
        }
        else {
            self.loginUser(username: self.txtUsername.text!, password: self.txtPassword.text!, isLoginWithBiometric: false)
        }
    }
    
    @IBAction func btnFingerprintTapped(_ sender: UIButton) {
        self.authenticationWithTouchID()
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: Any) {
    }
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
    }
    
    @IBAction func btnTermsTapped(_ sender: UIButton) {

    }
    
    @IBAction func btnPrivacyPolicyTapped(_ sender: UIButton) {
    }
}

//MARK:- BioMetric Authentication
extension LoginVC {
    func authenticationWithTouchID() {
        GlobalData.shared.authenticateTouchIDGlobally { (success) in
            if success == true {
                var userName: String = ""
                var password: String = ""
                
                if let uName = defaults.object(forKey: "rememberUsername") as? String {
                    userName = uName
                }
                
                if let pass = defaults.object(forKey: "rememberPassword") as? String {
                    password = pass
                }
                
                self.loginUser(username: userName, password: password, isLoginWithBiometric: true)
            }
        }
    }
}

//MARK:- API Call
extension LoginVC {
    func getConfigData() {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            return
        }
        
        AFWrapper.requestGETURL(BASE_URL + URLS.GET_COMMON_LIST, success: { (JSONResponse) in
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        let payloadData = response["payload"]  as! [String : Any]
                        
                        GlobalData.shared.objConfiguration = ConfigDataObject.init(payloadData)
                        GlobalData.shared.configData = payloadData
                    }
                }
            }
        }) { (error) in
        }
    }
    
    func loginUser(username: String, password: String, isLoginWithBiometric: Bool) {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["username"] = username
        params["password"] = password
        params["device_type"] = DEVICE_TYPE
        params["device_token"] = defaults.value(forKey: "deviceToken") != nil ? defaults.value(forKey: "deviceToken") : ""
        
        if isLoginWithBiometric {
            params["finger_uuid"] = defaults.value(forKey: randomUUID)
        }
        
        let strJSONParam = GlobalData.shared.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        GlobalData.showDefaultProgress()
        AFWrapper.requestPOSTURL(BASE_URL + URLS.LOGIN, params: params as [String : AnyObject], headers: nil, success: {
            (JSONResponse) -> Void in
            GlobalData.hideProgress()
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                        
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let userData = payload["user"] as? Dictionary<String, Any> {
                                
                                let payloadData = NSKeyedArchiver.archivedData(withRootObject: userData)
                                defaults.set(payloadData, forKey: "userPayloadData")
                                defaults.set(payload["token"]! as! String, forKey: "_token")
                                
                                
                                let objLoginUser: UserObject = UserObject.saveUserData(dict: userData)
                                GlobalData.shared.currrentUser = objLoginUser
                                
                                if let data = try? JSONEncoder().encode(objLoginUser) {
                                    defaults.set(data, forKey: kLoggedInUserData)
                                    defaults.set(true, forKey: kIsUserLoggedIn)
                                    defaults.synchronize()
                                }
                            }
                        }
                        
                        if self.ivRemeber.image == UIImage(named: "ic_checkbox") {
                            defaults.set(true, forKey: "rememberEnable")
                        } else {
                            defaults.set(false, forKey: "rememberEnable")
                        }
                        defaults.set(self.txtUsername.text, forKey: "rememberUsername")
                        defaults.set(self.txtPassword.text, forKey: "rememberPassword")
                        defaults.synchronize()
                        
                        if !GlobalData.shared.currrentUser.finger_uuid.isEmpty {
                            var previousUUID: String = ""
                            if let strPreviousUUID = defaults.value(forKey: randomUUID) as? String  {
                                if !strPreviousUUID.isEmpty {
                                    previousUUID = strPreviousUUID
                                }
                            }
                            if GlobalData.shared.currrentUser.finger_uuid == previousUUID {
                                
                            }
                            else {
                                GlobalData.shared.removeUUIDFromUserDefault()
                            }
                        }
                        else {
                            //Biometric not Integrated yet
                            GlobalData.shared.removeUUIDFromUserDefault()
                        }
                    }
                    else if response["code"] as! Int == 301 {
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else if response["code"] as! Int == 305 {
                        GlobalData.shared.removeUUIDFromUserDefault()
                        self.vwBiometric.isHidden = true
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                    else {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }) { (error) in
            GlobalData.hideProgress()
            GlobalData.shared.showLightStyleToastMesage(message:NETWORK_ERROR)
        }
    }
}

//MARK:- UITextField Delegate
extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtUsername {
            self.vwBiometric.isHidden = true
        }
        return true
    }
}
