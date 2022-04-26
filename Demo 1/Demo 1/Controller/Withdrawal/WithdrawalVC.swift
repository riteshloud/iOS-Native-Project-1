//
//  WithdrawalVC.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftValidators
import SwiftyJSON
import Photos
import DropDown
import LocalAuthentication
import AVFoundation
import MobileCoreServices
import JTSImageViewController

class WithdrawalVC: UIViewController {
    
    enum HistoryType {
        case withdrawal
        
        var title: String {
            switch self {
            case .withdrawal:
                return "Withdrawal History".localized()
            }
        }
    }
    var selectedHistoryType: HistoryType = .withdrawal
    var historyTypes: [HistoryType] {
        return [.withdrawal]
    }
    
    private var requestState: REQUEST = .notStarted
    var OFFSET :Int = 0
    var PAGING_LIMIT :Int = 20
    
    var withdrawalDropDown = DropDown()
    var selectedCellTab: Int = 0
    
    var objWithdrawalWalletDetail = WithdrawalWalletDetailObject.init([:])
    var arrHistory: [WithdrawalWalletHistoryObject] = []
    
    @IBOutlet weak var tblVW: UITableView!
    var isNeedToReload : Bool = true
    
    var withdrawalWalletBalance: Double = 0.0
    var localHeaderView: WithdrawalHeaderView!
    private var clearFields: Bool = false
    private var apiRefreshed: Bool = false
    var arrData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVW.register(UINib(nibName: "NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
        
        let headerNib = UINib(nibName: "WithdrawalHeaderView", bundle: nil)
        self.tblVW.register(headerNib, forHeaderFooterViewReuseIdentifier: "WithdrawalHeaderView")
        
        self.tblVW.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpNavigationBar()
        
        if self.isNeedToReload {
            self.getWithdrawalWalletHistory()
        }
        else {
            self.isNeedToReload = true
        }
    }
    
    //MARK:- SetUp Navigation Bar
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.clipsToBounds = true
        
        let btnMenu = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        btnMenu.setImage(UIImage(named: "ic_side_menu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(self.menuAction), for: .touchUpInside)
        let btnBarMenu = UIBarButtonItem(customView: btnMenu)
        let btnTitle = UIButton()
        btnTitle.setTitle("Withdrawal".localized(), for: .normal)
        btnTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        btnTitle.titleLabel?.font = UIFont(name: Fonts.PoppinsMedium, size: 18)!
        btnTitle.titleLabel?.textColor = UIColor.white
        btnTitle.isUserInteractionEnabled = false
        let btnBarTitle = UIBarButtonItem(customView: btnTitle)
        navigationItem.leftBarButtonItems = [btnBarMenu, btnBarTitle]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- UIButton Action
    @IBAction func menuAction() {
        self.view.endEditing(true)
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    @objc func resendEmailAction(sender: UIButton!) {
        self.view.endEditing(true)
        
        let objHistory = self.arrHistory[sender.tag]
        self.callResendEmailAPI(refID: objHistory.id)
    }
    
    //MARK:- Pagination Call
    private func nextPageForWithdrawalWalletHistoryHistoryIfNeeded(at indexPath: IndexPath) {
        if self.arrHistory.count >= 20 {
            if indexPath.item == (self.arrHistory.count - 1) {
                if requestState != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.arrHistory.count
                    self.PAGING_LIMIT = 20
                    self.getWithdrawalWalletHistory()
                }
            }
        }
    }
}

//MARK:- UITableView Delegate & DataSource
extension WithdrawalVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedHistoryType {
        case .withdrawal:
            if self.arrHistory.count <= 0 {
                return 1
            }
            else {
                return self.arrHistory.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedHistoryType {
        case .withdrawal:
            if self.arrHistory.count <= 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! NoDataCell
                cell.configure()
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WithdrawalTableViewCell") as! WithdrawalTableViewCell
                
                let history = self.arrHistory[indexPath.row]
                cell.configure(with: history, indexPath: indexPath, countOfArray: self.arrHistory.count)
                nextPageForWithdrawalWalletHistoryHistoryIfNeeded(at: indexPath)
                
                cell.btnResendEmail.tag = indexPath.row
                cell.btnResendEmail.addTarget(self, action: #selector(resendEmailAction(sender:)), for: .touchUpInside)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WithdrawalHeaderView") as? WithdrawalHeaderView
        
        
        headerView?.onBankTransferTap = { [weak self] amount, password, authType in
            self?.callBankTransferWithdrawalAPI(amount: amount, password: password, authType: authType)
        }
        
        headerView?.onUSDTErcTransferTap = { [weak self] amount, password, authType, usdtAddress in
            self?.callUSDTErcWithdrawalAPI(amount: amount, password: password, authType: authType, usdtAddress: usdtAddress)
        }
        
        headerView?.onUSDTTrcTransferTap = { [weak self] amount, password, authType, usdtAddress in
            self?.callUSDTTrcWithdrawalAPI(amount: amount, password: password, authType: authType, usdtAddress: usdtAddress)
        }
        
        headerView?.onUSDCErcTransferTap = { [weak self] amount, password, authType, usdcAddress in
            self?.callUSDCErcWithdrawalAPI(amount: amount, password: password, authType: authType, usdcAddress: usdcAddress)
        }
        
        headerView?.configure(with: self.objWithdrawalWalletDetail, cashBalance: self.withdrawalWalletBalance, shouldClearFields: clearFields, cont: self, isApiRefresh: apiRefreshed)
        apiRefreshed = false
        clearFields = false
        
        headerView?.checkBiometricEnrolledOrAvailable()
        localHeaderView = headerView
        headerView?.onSecurityRadioButtonValueChange = { [weak self] in
            self?.tblVW.reloadData()
        }
        
        headerView?.onWithdrawalTypeValueChange = { [weak self] in
            self?.tblVW.reloadData()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 1133
    }
}

//MARK:- API Call
extension WithdrawalVC {
    func getWithdrawalWalletHistory() {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["offset"] = self.OFFSET
        params["limit"] = self.PAGING_LIMIT
        
        self.requestState = REQUEST.started
        
        GlobalData.showDefaultProgress()
        AFWrapper.requestPOSTURL(BASE_URL + URLS.WITHDRAWAL_WALLET_HISTORY, params: params as [String : AnyObject], headers: nil, success: { [weak self]
            (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            guard let self = self else { return }
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        self.requestState = REQUEST.notStarted
                        
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            self.objWithdrawalWalletDetail = WithdrawalWalletDetailObject.init(payload)
                            
                            if self.OFFSET == 0 {
                                if self.objWithdrawalWalletDetail.enable_bank_option == "1" {
                                    GlobalData.shared.selectedWithdrawalType = .bankTransfer
                                } else {
                                    GlobalData.shared.selectedWithdrawalType = .usdtErc
                                }
                            }
                            
                            self.withdrawalWalletBalance = self.objWithdrawalWalletDetail.withdrawal_balance
                            let newHistory = self.objWithdrawalWalletDetail.arrHistory
                            self.arrHistory.append(contentsOf: newHistory)
                            
                            if self.PAGING_LIMIT >= 20 {
                                if newHistory.count < self.PAGING_LIMIT {
                                    self.requestState = REQUEST.failedORNoMoreData
                                }
                            }
                            
                            if (self.objWithdrawalWalletDetail.proof_status == "0" && self.objWithdrawalWalletDetail.upload_status == "0") || (self.objWithdrawalWalletDetail.proof_status == "0" && self.objWithdrawalWalletDetail.upload_status == "1") {
                                //PROOF NOT UPLOADED YET
                                let alertController = UIAlertController(title: nil, message: "Please upload your proofs to withdraw amount.".localized(), preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK".localized(), style: .default) { (action:UIAlertAction!) in
                                    let controller = GlobalData.withdrawalStoryBoard().instantiateViewController(withIdentifier: "UploadProofVC") as! UploadProofVC
                                    
                                    controller.objWithdrawalWalletDetail = self.objWithdrawalWalletDetail
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }
                                
                                alertController.addAction(OKAction)
                                self.navigationController?.present(alertController, animated: true, completion: nil)
                            }
                            
                            self.apiRefreshed = true
                            self.tblVW.isHidden = false
                            self.tblVW.delegate = self
                            self.tblVW.dataSource = self
                            self.tblVW.reloadData()
                        }
                    }
                    else if response["code"] as! Int == 301 {
                        self.requestState = REQUEST.failedORNoMoreData
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else {
                        self.requestState = REQUEST.failedORNoMoreData
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }) { (error) in
            GlobalData.hideProgress()
            self.requestState = REQUEST.failedORNoMoreData
            GlobalData.shared.showLightStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    func callBankTransferWithdrawalAPI(amount: String, password: String, authType: String) {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["amount"] = amount
        params["auth_type"] = authType
        params["security_password"] = password
        params["request_type"] = "bank"
        
        let strJSONParam = GlobalData.shared.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        GlobalData.showDefaultProgress()
        AFWrapper.requestPOSTURL(BASE_URL + URLS.WITHDRAWAL_WALLET_REQUEST, params: params as [String: AnyObject], headers: nil, success: { (JSONResponse) in
            
            GlobalData.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                        
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let withdrawal_balance = payload["withdrawal_balance"] as? Double {
                                self.objWithdrawalWalletDetail.withdrawal_balance = withdrawal_balance
                                //                                self.lblAccountBalance.text = String.init(format: "$%.2f", self.objWithdrawalWalletDetail.withdrawal_balance)
                            }
                            
                            if let newHistory = payload["history"] as? Dictionary<String, Any> {
                                let objNewHistory = WithdrawalWalletHistoryObject.init(newHistory)
                                self.arrHistory.insert(objNewHistory, at: 0)
                            }
                            
                            self.apiRefreshed = true
                            self.clearFields = true
                            self.tblVW.reloadData()
                            self.tblVW.reloadSections(IndexSet(0..<1), with: .automatic)
                        }
                    }
                    else if response["code"] as! Int == 301 {
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else if response["code"] as! Int == 305 {
                        GlobalData.shared.removeUUIDFromUserDefault()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.localHeaderView.checkBiometricEnrolledOrAvailable()
                            self.localHeaderView.nSecuritySelectedOption = 0
                            self.localHeaderView.showSecurityPasswordSection()
                        }
                        
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                    else {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }) { (error) in
            GlobalData.hideProgress()
            GlobalData.shared.showLightStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    func callUSDTErcWithdrawalAPI(amount: String, password: String, authType: String, usdtAddress: String) {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["amount"] = amount
        params["auth_type"] = authType
        params["security_password"] = password
        if self.localHeaderView.txtUSDTErcAddress.isEnabled {
            params["usdt_address"] = usdtAddress
        }
        
        /*
         var files: [Document] = []
         if self.usdtProofDocument != nil {
         files.append(self.usdtProofDocument!)
         }
         */
        
        var files: [Document] = []
        if self.localHeaderView.usdtErcProofDocument != nil {
            files.append(self.localHeaderView.usdtErcProofDocument!)
        }
        
        params["request_type"] = "USDT"
        
        let strJSONParam = GlobalData.shared.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        GlobalData.showDefaultProgress()
        
        AFWrapper.postWithUploadMultipleFiles(files, strURL: BASE_URL + URLS.WITHDRAWAL_WALLET_REQUEST, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let withdrawal_balance = payload["withdrawal_balance"] as? Double {
                                self.objWithdrawalWalletDetail.withdrawal_balance = withdrawal_balance
                            }
                            
                            if let newHistory = payload["history"] as? Dictionary<String, Any> {
                                let objNewHistory = WithdrawalWalletHistoryObject.init(newHistory)
                                self.arrHistory.insert(objNewHistory, at: 0)
                                
                                if self.localHeaderView.usdtErcProofDocument != nil {
                                    self.localHeaderView.usdtErcProofLink = objNewHistory.payment_proof
                                    //UPDATE UDST ERC VALUE TO DISABLE THE USER INTERACTION IF ALREADY REQUESTED
                                    self.objWithdrawalWalletDetail.usdtErc_address = objNewHistory.payment_address
                                    self.localHeaderView.usdtErcProofDocument = nil
                                    self.localHeaderView.iconUSDTErcUpload.isHidden = true
                                    self.localHeaderView.lblDragandDropUSDTErc.isHidden = true
                                }
                            }
                            
                            self.apiRefreshed = true
                            self.clearFields = true
                            self.tblVW.reloadData()
                            self.tblVW.reloadSections(IndexSet(0..<1), with: .automatic)
                            GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                        }
                    }
                    else if response["code"] as! Int == 301 {
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else if response["code"] as! Int == 305 {
                        GlobalData.shared.removeUUIDFromUserDefault()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.localHeaderView.checkBiometricEnrolledOrAvailable()
                            self.localHeaderView.nSecuritySelectedOption = 0
                            self.localHeaderView.showSecurityPasswordSection()
                        }
                        
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                    else {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }, failure: { (error) in
            GlobalData.hideProgress()
            GlobalData.shared.showLightStyleToastMesage(message: NETWORK_ERROR)
        })
    }
    
    func callUSDTTrcWithdrawalAPI(amount: String, password: String, authType: String, usdtAddress: String) {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["amount"] = amount
        params["auth_type"] = authType
        params["security_password"] = password
        if self.localHeaderView.txtUSDTTrcAddress.isEnabled {
            params["usdt_trc_address"] = usdtAddress
        }
        
        var files: [Document] = []
        if self.localHeaderView.usdtTrcProofDocument != nil {
            files.append(self.localHeaderView.usdtTrcProofDocument!)
        }
        
        params["request_type"] = "usdt_trc"
        
        let strJSONParam = GlobalData.shared.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        GlobalData.showDefaultProgress()
        
        AFWrapper.postWithUploadMultipleFiles(files, strURL: BASE_URL + URLS.WITHDRAWAL_WALLET_REQUEST, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let withdrawal_balance = payload["withdrawal_balance"] as? Double {
                                self.objWithdrawalWalletDetail.withdrawal_balance = withdrawal_balance
                            }
                            
                            if let newHistory = payload["history"] as? Dictionary<String, Any> {
                                let objNewHistory = WithdrawalWalletHistoryObject.init(newHistory)
                                self.arrHistory.insert(objNewHistory, at: 0)
                                
                                if self.localHeaderView.usdtTrcProofDocument != nil {
                                    self.localHeaderView.usdtTrcProofLink = objNewHistory.payment_proof
                                    //UPDATE UDST TRC VALUE TO DISABLE THE USER INTERACTION IF ALREADY REQUESTED
                                    self.objWithdrawalWalletDetail.usdtTrc_address = objNewHistory.payment_address
                                    self.localHeaderView.usdtTrcProofDocument = nil
                                    self.localHeaderView.iconUSDTTrcUpload.isHidden = true
                                    self.localHeaderView.lblDragandDropUSDTTrc.isHidden = true
                                }
                            }
                            
                            self.apiRefreshed = true
                            self.clearFields = true
                            self.tblVW.reloadData()
                            self.tblVW.reloadSections(IndexSet(0..<1), with: .automatic)
                            GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                        }
                    }
                    else if response["code"] as! Int == 301 {
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else if response["code"] as! Int == 305 {
                        GlobalData.shared.removeUUIDFromUserDefault()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.localHeaderView.checkBiometricEnrolledOrAvailable()
                            self.localHeaderView.nSecuritySelectedOption = 0
                            self.localHeaderView.showSecurityPasswordSection()
                        }
                        
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                    else {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }, failure: { (error) in
            GlobalData.hideProgress()
            GlobalData.shared.showLightStyleToastMesage(message: NETWORK_ERROR)
        })
    }
    
    func callUSDCErcWithdrawalAPI(amount: String, password: String, authType: String, usdcAddress: String) {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["amount"] = amount
        params["auth_type"] = authType
        params["security_password"] = password
        if self.localHeaderView.txtUSDCErcAddress.isEnabled {
            params["usdc_erc_address"] = usdcAddress
        }
        
        /*
         var files: [Document] = []
         if self.usdcProofDocument != nil {
         files.append(self.usdcProofDocument!)
         }
         */
        
        var files: [Document] = []
        if self.localHeaderView.usdcErcProofDocument != nil {
            files.append(self.localHeaderView.usdcErcProofDocument!)
        }
        
        params["request_type"] = "usdc_erc"
        
        let strJSONParam = GlobalData.shared.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        GlobalData.showDefaultProgress()
        
        AFWrapper.postWithUploadMultipleFiles(files, strURL: BASE_URL + URLS.WITHDRAWAL_WALLET_REQUEST, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let withdrawal_balance = payload["withdrawal_balance"] as? Double {
                                self.objWithdrawalWalletDetail.withdrawal_balance = withdrawal_balance
                            }
                            
                            if let newHistory = payload["history"] as? Dictionary<String, Any> {
                                let objNewHistory = WithdrawalWalletHistoryObject.init(newHistory)
                                self.arrHistory.insert(objNewHistory, at: 0)
                                
                                if self.localHeaderView.usdcErcProofDocument != nil {
                                    self.localHeaderView.usdcErcProofLink = objNewHistory.payment_proof
                                    //UPDATE UDST ERC VALUE TO DISABLE THE USER INTERACTION IF ALREADY REQUESTED
                                    self.objWithdrawalWalletDetail.usdcErc_address = objNewHistory.payment_address
                                    self.localHeaderView.usdcErcProofDocument = nil
                                    self.localHeaderView.iconUSDCErcUpload.isHidden = true
                                    self.localHeaderView.lblDragandDropUSDCErc.isHidden = true
                                }
                            }
                            
                            self.apiRefreshed = true
                            self.clearFields = true
                            self.tblVW.reloadData()
                            self.tblVW.reloadSections(IndexSet(0..<1), with: .automatic)
                            GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                        }
                    }
                    else if response["code"] as! Int == 301 {
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else if response["code"] as! Int == 305 {
                        GlobalData.shared.removeUUIDFromUserDefault()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.localHeaderView.checkBiometricEnrolledOrAvailable()
                            self.localHeaderView.nSecuritySelectedOption = 0
                            self.localHeaderView.showSecurityPasswordSection()
                        }
                        
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                    else {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }, failure: { (error) in
            GlobalData.hideProgress()
            GlobalData.shared.showLightStyleToastMesage(message: NETWORK_ERROR)
        })
    }
    
    func callResendEmailAPI(refID: Int) {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["ref_id"] = refID
        
        GlobalData.showDefaultProgress()
        
        AFWrapper.requestPOSTURL(BASE_URL + URLS.SEND_MAIL_WITHDRAWAL_REQUEST, params: params as [String : AnyObject], headers: nil, success: {
            (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                    else if response["code"] as! Int == 301 {
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }) { (error) in
            GlobalData.hideProgress()
            GlobalData.shared.showLightStyleToastMesage(message: NETWORK_ERROR)
        }
    }
}
