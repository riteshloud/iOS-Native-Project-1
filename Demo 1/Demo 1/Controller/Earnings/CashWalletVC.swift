//
//  CashWalletVC.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftValidators
import DropDown
import LocalAuthentication

class CashWalletVC: UIViewController {

    enum HistoryType {
        case walletHistory
        
        var title: String {
            switch self {
            case .walletHistory:
                return "Cash Wallet History".localized()
            }
        }
    }
    var selectedHistoryType: HistoryType = .walletHistory
    var historyTypes: [HistoryType] {
        return [.walletHistory]
    }
    
    enum TopUpFundType: Equatable {
        case transferYourFunds
        case mt5Request
        
        var title: String {
            switch self {
            case .transferYourFunds:
                return "Transfer Your Funds".localized()
            case .mt5Request:
                return "MT5 Request".localized()
            }
        }
    }
    
    var selectedFundTransferType: TopUpFundType = .transferYourFunds
//    var transferTypes: [TopUpFundType] = [.transferYourFunds, .mt5Request]
    var arrFundTransferType: [FundOptionObject] = []
    var objSelectedTopupFund: FundOptionObject!
    
    //HEADER VIEW
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var lblFundBalanceTitle: UILabel!
    @IBOutlet weak var lblFundBalance: UILabel!
    @IBOutlet weak var vwInnerContent: UIView!
    @IBOutlet weak var lblTopupFundTitle: UILabel!
    @IBOutlet weak var collectionStackVW: UIStackView!
    @IBOutlet weak var collectionVW: UICollectionView!
    
    @IBOutlet var headerContainerStackView: UIStackView!
    
    @IBOutlet weak var stackVWTermsAndCondition: UIStackView!
    @IBOutlet weak var lblTermsAndConditionTitle: UILabel!
    @IBOutlet weak var lblTermsAndConditionDescription: UILabel!
    
    @IBOutlet weak var vwCollectionContainer: UIView!
    @IBOutlet weak var collectionViewHistory: UICollectionView!
    
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var tblVW: UITableView!
    
    //TRANSFER YOUR FUNDS
    enum FundsType {
        case selectWallet
        case FundsWallet
        case WithdrawalWallet
        case StockWallet
        
        var title: String {
            switch self {
            case .selectWallet:
                return "Select Funds Type".localized()
            case .FundsWallet:
                return "Funds Wallet".localized()
            case .WithdrawalWallet:
                return "Withdrawal Wallet".localized()
            case .StockWallet:
                return "Stock Wallet".localized()
            }
        }
    }
    
    @IBOutlet weak var vwTransferYourFunds: UIView!
    @IBOutlet weak var vwFundType: UIView!
    @IBOutlet weak var txtSelectedFund: UITextField!
    @IBOutlet weak var btnFundTypeDropDown: UIButton!
    
    @IBOutlet weak var txtTYFAmountUSD: UITextField!
    @IBOutlet weak var radioButtonTYFStackView: UIStackView!
    @IBOutlet weak var btnTYFSecurityPassword: UIButton!
    @IBOutlet weak var btnTYFBiometric: UIButton!
    
    @IBOutlet weak var securityPasswordTYFStackView: UIStackView!
    @IBOutlet weak var txtTYFSecurityPassword: UITextField!
    @IBOutlet weak var btnSubmitTYFRequest: UIButton!
    
    //SECURITY PASSWORD
    var nTYFSecuritySelectedOption: Int = 0
    var arrTYFRadioButtons = [UIButton]()
    
    var selectedFundType: FundsType = .selectWallet
    var selectedCellTab : Int = 0
    
    var fundsDropDown = DropDown()
    var arrFundTypes: [String] = ["Select Funds Type".localized(), "Funds Wallet".localized(), "Withdrawal Wallet".localized(), "Stock Wallet".localized()]
    
    
    //MT5 REQUEST
    @IBOutlet weak var vwMT5Request: UIView!
    @IBOutlet weak var txtMT5AmountUSD: UITextField!
    @IBOutlet weak var radioButtonMT5StackView: UIStackView!
    @IBOutlet weak var btnMT5SecurityPassword: UIButton!
    @IBOutlet weak var btnMT5Biometric: UIButton!
    
    @IBOutlet weak var securityPasswordMT5StackView: UIStackView!
    @IBOutlet weak var txtMT5SecurityPassword: UITextField!
    @IBOutlet weak var btnSubmitMT5Request: UIButton!
    
    //SECURITY PASSWORD
    var nMT5SecuritySelectedOption: Int = 0
    var arrMT5RadioButtons = [UIButton]()
    
    
    private var OFFSET: Int = 0
    private var PAGING_LIMIT: Int = 20
    
    private var clearFields: Bool = false
    
    private var walletHistoryRequestState: REQUEST = .notStarted
    var objCashWalletDetail = CashWalletDetailObject.init([:])
    var arrHistory: [CashWalletHistoryObject] = []
    
    var cashWalletBalance: Double = 0.0
    var localHeaderView: CashWalletHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVW.register(UINib(nibName: "CashWalletHistoryCell", bundle: nil), forCellReuseIdentifier: "CashWalletHistoryCell")

        self.tblVW.register(UINib(nibName: "NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
        
//        let nib = UINib(nibName: "CashWalletHeaderView", bundle: nil)
//        self.tblVW.register(nib, forHeaderFooterViewReuseIdentifier: "CashWalletHeaderView")
        
        self.tblVW.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpNavigationBar()
        self.vwMessage.isHidden = true
        self.tblVW.isHidden = true
        self.checkBiometricEnrolledOrAvailable()
        self.getCashWalletWalletHistory()
    }
    
    //MARK:- Check Biometric Availibility
    func checkBiometricEnrolledOrAvailable() {
        let currentType = LAContext().biometricType
        if currentType == .none && GlobalData.shared.nBiometricErrorCode != -8 {
            self.radioButtonTYFStackView.isHidden = true
            self.radioButtonMT5StackView.isHidden = true
        }
        else {
            if GlobalData.shared.isUUIDExistInUserDefault() {
                self.radioButtonTYFStackView.isHidden = false
                self.radioButtonMT5StackView.isHidden = false
            }
            else {
                self.radioButtonTYFStackView.isHidden = true
                self.radioButtonMT5StackView.isHidden = true
            }
        }
    }
    
    //MARK:- Calculate UITableView HeaderView Height
    func calculateAndSetTableHeaderViewHeight() {
        let width = self.tblVW.frame.width
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let systemLayoutSize = self.tblVW.tableHeaderView?.systemLayoutSizeFitting(size)
        self.tblVW.tableHeaderView?.frame.size.height = systemLayoutSize?.height ?? 0
        self.tblVW.reloadData()
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
        btnTitle.setTitle("Cash Wallet".localized(), for: .normal)
        btnTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        btnTitle.titleLabel?.font = UIFont(name: Fonts.PoppinsMedium, size: 18)!
        btnTitle.titleLabel?.textColor = UIColor.white
        btnTitle.isUserInteractionEnabled = false
        let btnBarTitle = UIBarButtonItem(customView: btnTitle)
        navigationItem.leftBarButtonItems = [btnBarMenu, btnBarTitle]
        
        
        self.lblFundBalanceTitle.text = "Account Balance".localized()
        self.lblTopupFundTitle.text = "Transfer Your Funds".localized()
        self.lblTermsAndConditionTitle.text = "Terms & Conditions".localized()
        
        //TRANSFER YOUR FUNDS
        self.txtTYFAmountUSD.placeholder = "Amount USD".localized()
        self.txtTYFAmountUSD.placeHolderColor = .white
        self.txtTYFAmountUSD.delegate = self
        self.txtTYFSecurityPassword.placeholder = "Security Password".localized()
        self.txtTYFSecurityPassword.placeHolderColor = .white
        self.btnSubmitTYFRequest.setTitle("Submit".localized(), for: [])
        
        self.btnTYFSecurityPassword.titleLabel?.numberOfLines = 0
        self.btnTYFSecurityPassword.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnTYFSecurityPassword.setTitle("Security Password".localized(), for: [])
        self.btnTYFSecurityPassword.sizeToFit()
        
        self.btnTYFBiometric.setTitle("Biometric".localized(), for: [])
        
        self.setupCollectionViews()
        
        //SECURITY PASSWORD
        arrTYFRadioButtons.removeAll()
        arrTYFRadioButtons.append(self.btnTYFSecurityPassword)
        arrTYFRadioButtons.append(self.btnTYFBiometric)
        self.btnTYFSecurityPassword.isSelected = true
        self.btnTYFBiometric.isSelected = false
        
        self.setupFundsDropDown()
        
        //MT5 REQUEST
        self.txtMT5AmountUSD.placeholder = "Amount USD".localized()
        self.txtMT5AmountUSD.placeHolderColor = .white
        self.txtMT5AmountUSD.delegate = self
        self.txtMT5SecurityPassword.placeholder = "Security Password".localized()
        self.txtMT5SecurityPassword.placeHolderColor = .white
        self.btnSubmitMT5Request.setTitle("Submit".localized(), for: [])
        
        self.btnMT5SecurityPassword.titleLabel?.numberOfLines = 0
        self.btnMT5SecurityPassword.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnMT5SecurityPassword.setTitle("Security Password".localized(), for: [])
        self.btnMT5SecurityPassword.sizeToFit()
        
        self.btnMT5Biometric.setTitle("Biometric".localized(), for: [])
        
        //SECURITY PASSWORD
        arrMT5RadioButtons.removeAll()
        arrMT5RadioButtons.append(self.btnMT5SecurityPassword)
        arrMT5RadioButtons.append(self.btnMT5Biometric)
        self.btnMT5SecurityPassword.isSelected = true
        self.btnMT5Biometric.isSelected = false
    }
    
    //MARK:- SetUp UICollectionView
    func setupCollectionViews() {
        self.collectionViewHistory.delegate = self
        self.collectionViewHistory.dataSource = self
        
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        self.collectionViewHistory.register(nib, forCellWithReuseIdentifier: "HistoryCell")
        
        let optionNib = UINib(nibName: "OptionsCell", bundle: nil)
        self.collectionVW.register(optionNib, forCellWithReuseIdentifier: "OptionsCell")
        
        if arrHistory.count > 0 {
            DispatchQueue.main.async {
                self.collectionViewHistory.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
            }
        }
    }
    
    //MARK:- SETUP DropDown
    func setupFundsDropDown() {
        self.fundsDropDown = DropDown()
        
        self.fundsDropDown.cellHeight = 40
        self.fundsDropDown.backgroundColor = .white
        self.fundsDropDown.selectionBackgroundColor = Colors.evenRowColor
        self.fundsDropDown.textColor = .black
        self.fundsDropDown.selectedTextColor = .black
        
        self.fundsDropDown.anchorView = self.btnFundTypeDropDown
        self.fundsDropDown.direction = .bottom
        self.fundsDropDown.dataSource = arrFundTypes
        self.fundsDropDown.selectRow(0)
        self.txtSelectedFund.text = arrFundTypes[0].localized()
        self.fundsDropDown.bottomOffset = CGPoint(x: 0, y:(self.fundsDropDown.anchorView?.plainView.bounds.height)!)
        self.fundsDropDown.textFont = UIFont(name: Fonts.PoppinsRegular, size: 14)!
        self.fundsDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtSelectedFund.text = item
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- UIButton Action
    @IBAction func btnFundTypeDropdownTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.fundsDropDown.show()
    }
    
    func resetTYFSecurityButtonStates() {
        for button in arrTYFRadioButtons {
            button.isSelected = false
        }
    }
    
    @IBAction func btnTYFRadioAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let isAlreadySelected = sender.isSelected == true
        if !isAlreadySelected {
            resetTYFSecurityButtonStates()
            
            sender.isSelected = true
            self.nTYFSecuritySelectedOption = sender.tag
            debugPrint(self.nTYFSecuritySelectedOption)
            
            if self.nTYFSecuritySelectedOption == 0 {
                self.showTYFSecurityPasswordSection()
            }
            else {
                self.txtTYFSecurityPassword.resignFirstResponder()
                self.hideTYFSecurityPasswordSection()
            }
            
//            self.onSecurityRadioButtonValueChange?()
        }
        else {
        }
    }
    
    func hideTYFSecurityPasswordSection() {
        self.securityPasswordTYFStackView.isHidden = true
        
        self.checkBiometricEnrolledOrAvailable()
        self.calculateAndSetTableHeaderViewHeight()
    }
    
    func showTYFSecurityPasswordSection() {
        self.securityPasswordTYFStackView.isHidden = false
        
        self.checkBiometricEnrolledOrAvailable()
        self.calculateAndSetTableHeaderViewHeight()
    }
    
    private func validateTYF() -> (String, String, String)? {
        let securitypasswordtrimmedString = self.txtTYFSecurityPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let amounttrimmedString = self.txtTYFAmountUSD.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
        if self.nTYFSecuritySelectedOption == 0 {
            if self.txtSelectedFund.text == "Select Funds Type".localized() {
                GlobalData.shared.showLightStyleToastMesage(message: "Please select funds type!".localized())
                return nil
            }
            else if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == nil {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else if !Validator.required().apply(securitypasswordtrimmedString) {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide security password!".localized())
                    return nil
                }
                else {
                    return (amounttrimmedString!, securitypasswordtrimmedString!, "normal")
                }
            }
        }
        else {
            if self.txtSelectedFund.text == "Select Funds Type".localized() {
                GlobalData.shared.showLightStyleToastMesage(message: "Please select funds type!".localized())
                return nil
            }
            else if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == nil {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else {
                    return (amounttrimmedString!, GlobalData.shared.getSavedUUIDFromUserDefault(), "finger")
                }
            }
        }
    }
    
    @IBAction func btnTYFRequestTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard let (amount, password, authType) = validateTYF() else { return }
        
        if self.nTYFSecuritySelectedOption == 0 {
            if self.txtSelectedFund.text == "Funds Wallet".localized() {
                self.transferMoney(amount: amount, password: password, authType: authType, fundType: "0")
            } else if self.txtSelectedFund.text == "Withdrawal Wallet".localized() {
                self.transferMoney(amount: amount, password: password, authType: authType, fundType: "1")
            } else if self.txtSelectedFund.text == "Stock Wallet".localized() {
                self.transferMoney(amount: amount, password: password, authType: authType, fundType: "2")
            }
        }
        else {
            if self.txtSelectedFund.text == "Funds Wallet".localized() {
                self.authenticateTYFWithTouchID(amount: amount, password: password, strAuthType: authType, fundType: "0")
            } else if self.txtSelectedFund.text == "Withdrawal Wallet".localized() {
                self.authenticateTYFWithTouchID(amount: amount, password: password, strAuthType: authType, fundType: "1")
            } else if self.txtSelectedFund.text == "Stock Wallet".localized() {
                self.authenticateTYFWithTouchID(amount: amount, password: password, strAuthType: authType, fundType: "2")
            }
        }
    }
    
    func resetMT5SecurityButtonStates() {
        for button in arrMT5RadioButtons {
            button.isSelected = false
        }
    }
    
    @IBAction func btnMT5RadioAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let isAlreadySelected = sender.isSelected == true
        if !isAlreadySelected {
            resetMT5SecurityButtonStates()
            
            sender.isSelected = true
            self.nMT5SecuritySelectedOption = sender.tag
            debugPrint(self.nMT5SecuritySelectedOption)
            
            if self.nMT5SecuritySelectedOption == 0 {
                self.showMT5SecurityPasswordSection()
            }
            else {
                self.txtMT5SecurityPassword.resignFirstResponder()
                self.hideMT5SecurityPasswordSection()
            }
            
//            self.onSecurityRadioButtonValueChange?()
        }
        else {
        }
    }
    
    func hideMT5SecurityPasswordSection() {
        self.securityPasswordMT5StackView.isHidden = true
        
        self.checkBiometricEnrolledOrAvailable()
        self.calculateAndSetTableHeaderViewHeight()
    }
    
    func showMT5SecurityPasswordSection() {
        self.securityPasswordMT5StackView.isHidden = false
        
        self.checkBiometricEnrolledOrAvailable()
        self.calculateAndSetTableHeaderViewHeight()
    }
    
    private func validateMT5() -> (String, String, String)? {
        let securitypasswordtrimmedString = self.txtMT5SecurityPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let amounttrimmedString = self.txtMT5AmountUSD.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
        if self.nMT5SecuritySelectedOption == 0 {
           if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == nil {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else if !Validator.required().apply(securitypasswordtrimmedString) {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide security password!".localized())
                    return nil
                }
                else {
                    return (amounttrimmedString!, securitypasswordtrimmedString!, "normal")
                }
            }
        }
        else {
            if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == nil {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else {
                    return (amounttrimmedString!, GlobalData.shared.getSavedUUIDFromUserDefault(), "finger")
                }
            }
        }
    }
    
    @IBAction func btnMT5RequestTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard let (amount, password, authType) = validateMT5() else { return }
        
        if self.nMT5SecuritySelectedOption == 0 {
            self.transferMT5Money(amount: amount, password: password, authType: authType)
        }
        else {
            self.authenticateMT5WithTouchID(amount: amount, password: password, strAuthType: authType)
        }
    }
    
    @IBAction func menuAction() {
        self.view.endEditing(true)
    }
    
    //MARK:- Pagination Call
    private func nextPageForWalletHistoryIfNeeded(at indexPath: IndexPath) {
        if self.arrHistory.count >= 20 {
            if indexPath.item == (self.arrHistory.count - 1) {
                if walletHistoryRequestState != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.arrHistory.count
                    self.PAGING_LIMIT = 20
                    self.getCashWalletWalletHistory()
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate
extension CashWalletVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrHistory.count <= 0 {
            return 1
        }
        else {
            return self.arrHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.arrHistory.count <= 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! NoDataCell
            cell.configure()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CashWalletHistoryCell", for: indexPath) as! CashWalletHistoryCell
            
            let history = self.arrHistory[indexPath.row]
            cell.configure(with: history, indexPath: indexPath, countOfArray: self.arrHistory.count)
            nextPageForWalletHistoryIfNeeded(at: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 119.0
    }
        
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CashWalletHeaderView") as? CashWalletHeaderView
        
        headerView?.onSubmitTap = { [weak self] amount, password, authType, fundType in
            self?.transferMoney(amount: amount, password: password, authType: authType, fundType: fundType)
        }
        
        headerView?.configure(with: self.objCashWalletDetail, cashBalance: self.cashWalletBalance, shouldClearFields: clearFields)
        clearFields = false
        
        headerView?.checkBiometricEnrolledOrAvailable()
        localHeaderView = headerView
        headerView?.onSecurityRadioButtonValueChange = { [weak self] in
            self?.tblVW.reloadData()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 900
    }
    */
}

//MARK:- UICollectionView Delegate & DataSource
extension CashWalletVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewHistory {
            return self.historyTypes.count
        } else {
            return self.arrFundTransferType.count
//            return self.transferTypes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewHistory {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
           
           cell.nameLabel.text = self.historyTypes[indexPath.item].title
           cell.topIndicator.isHidden = true
           cell.nameLabel.textColor = .white
           
           return cell
        }
        else {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCell", for: indexPath) as! OptionsCell

            let item = self.arrFundTransferType[indexPath.item]
            cell.lblTitle.text = item.text
            cell.lblTitle.textColor = UIColor.white
            
            if self.selectedFundTransferType.title == item.text {
               cell.vwDecorate.backgroundColor = Colors.collectionCurrentItemColor
            } else {
                cell.vwDecorate.backgroundColor = .clear
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if collectionView == self.collectionViewHistory {
            selectedCellTab = indexPath.row
            self.selectedHistoryType = self.historyTypes[indexPath.item]
            
            switch selectedHistoryType {
            case .walletHistory:
                debugPrint("Tapped")
            }
            self.collectionViewHistory.reloadSections(NSIndexSet(index: 0) as IndexSet)
        }
        else {
            self.objSelectedTopupFund = self.arrFundTransferType[indexPath.item]
            self.lblTopupFundTitle.text = self.objSelectedTopupFund.text
            if self.objSelectedTopupFund.text == "Transfer Your Funds".localized() {
                self.selectedFundTransferType = .transferYourFunds
                self.headerContainerStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                
                self.lblTermsAndConditionDescription.attributedText = self.objCashWalletDetail.terms_and_condition.html2Attributed
                self.lblTermsAndConditionDescription.textColor = .white
                self.lblTermsAndConditionDescription.font = UIFont.init(name: Fonts.PoppinsRegular, size: self.lblTermsAndConditionDescription.font.pointSize)!
                self.lblTermsAndConditionDescription.textAlignment = .left
                self.lblTermsAndConditionDescription.backgroundColor = .clear
                
                self.headerContainerStackView.addArrangedSubview(self.vwTransferYourFunds)
                
                self.stackVWTermsAndCondition.isHidden = false
            }
            else if self.objSelectedTopupFund.text == "MT5 Request".localized() {
                self.selectedFundTransferType = .mt5Request
                self.headerContainerStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                
                self.lblTermsAndConditionDescription.attributedText = self.objCashWalletDetail.terms_and_condition_mt5.html2Attributed
                self.lblTermsAndConditionDescription.textColor = .white
                self.lblTermsAndConditionDescription.font = UIFont.init(name: Fonts.PoppinsRegular, size: self.lblTermsAndConditionDescription.font.pointSize)!
                self.lblTermsAndConditionDescription.textAlignment = .left
                self.lblTermsAndConditionDescription.backgroundColor = .clear
                
                self.headerContainerStackView.addArrangedSubview(self.vwMT5Request)
                
                self.stackVWTermsAndCondition.isHidden = false
            }
            
            /*
            self.selectedFundTransferType = self.transferTypes[indexPath.item]
            self.lblTopupFundTitle.text = self.selectedFundTransferType.title.localized()
            
            if self.selectedFundTransferType.title == "Transfer Your Funds".localized() {
                self.selectedFundTransferType = .transferYourFunds
                self.headerContainerStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                self.headerContainerStackView.addArrangedSubview(self.vwTransferYourFunds)
                
                self.stackVWTermsAndCondition.isHidden = false
            }
            else if self.selectedFundTransferType.title == "MT5 Request".localized() {
                self.selectedFundTransferType = .mt5Request
                self.headerContainerStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                self.headerContainerStackView.addArrangedSubview(self.vwMT5Request)
                
                self.stackVWTermsAndCondition.isHidden = false
            }
            */
            self.checkBiometricEnrolledOrAvailable()
            self.calculateAndSetTableHeaderViewHeight()
            self.collectionVW.reloadSections(IndexSet(integer: 0))
            self.collectionVW.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewHistory {
           let font = UIFont(name: Fonts.PoppinsMedium, size: 16)!
           let height = collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
           var width: CGFloat = 0
           let item = historyTypes[indexPath.item].title
           width = NSString(string: item).size(withAttributes: [NSAttributedString.Key.font : font]).width
           return CGSize(width: width + 32, height: height)
        }
        else {
            /*
             let item = self.transferTypes[indexPath.item]
             let label = UILabel(frame: CGRect.zero)
             label.text = item.title
             label.sizeToFit()
             return CGSize(width: label.frame.width + 50, height: 49)
             */
            let item = self.arrFundTransferType[indexPath.item]
            let label = UILabel(frame: CGRect.zero)
            label.text = item.text
            label.sizeToFit()
            return CGSize(width: label.frame.width + 50, height: 49)
       }
    }
}

//MARK:- UITextField Delegate
extension CashWalletVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var returnValue = true
        if textField == self.txtTYFAmountUSD || textField == self.txtMT5AmountUSD {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                if updatedText.contains(".") {
                    let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
                    let arrString = updatedText.components(separatedBy: ".")
                    let valueBeforeDot = arrString[0]
                    let valueAfterDot = arrString[1]
                    if valueBeforeDot.count > 9 || valueAfterDot.count > 2 {
                        returnValue = false
                    } else if countdots > 0 && string == "." {
                        returnValue = false
                    } else {
                        returnValue = true
                    }
                }
                else {
                    if updatedText.count > 9 {
                        returnValue = false
                    } else {
                        returnValue = true
                    }
                }
            }
        }
        return returnValue
    }
}

//MARK:- BioMetric Authentication
extension CashWalletVC {
    func authenticateTYFWithTouchID(amount: String, password: String, strAuthType: String, fundType: String) {
        GlobalData.shared.authenticateTouchIDGlobally { (success) in
            if success == true {
                self.transferMoney(amount: amount, password: password, authType: strAuthType, fundType: fundType)
            }
        }
    }
    
    func authenticateMT5WithTouchID(amount: String, password: String, strAuthType: String) {
        GlobalData.shared.authenticateTouchIDGlobally { (success) in
            if success == true {
                self.transferMT5Money(amount: amount, password: password, authType: strAuthType)
            }
        }
    }
}

// MARK: - API Calls
extension CashWalletVC {
    func getCashWalletWalletHistory() {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["offset"] = self.OFFSET
        params["limit"] = self.PAGING_LIMIT
        
        self.walletHistoryRequestState = REQUEST.started
        
        GlobalData.showDefaultProgress()
        AFWrapper.requestPOSTURL(BASE_URL + URLS.CASH_WALLET_HISTORY, params: params as [String : AnyObject], headers: nil, success: { [weak self]
            (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            guard let self = self else { return }
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        self.walletHistoryRequestState = REQUEST.notStarted
                        
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            self.objCashWalletDetail = CashWalletDetailObject.init(payload)
                            
                            self.cashWalletBalance = self.objCashWalletDetail.cash_wallet_balance
                            self.lblFundBalance.text = "$" + String(format: "%.2f", self.cashWalletBalance)
                            
                            let newHistory = self.objCashWalletDetail.arrHistory
                            self.arrHistory.append(contentsOf: newHistory)
                            
                            if self.PAGING_LIMIT >= 20 {
                                if newHistory.count < self.PAGING_LIMIT {
                                    self.walletHistoryRequestState = REQUEST.failedORNoMoreData
                                }
                            }
                            
                            self.selectedFundTransferType = .transferYourFunds
                            self.lblTermsAndConditionDescription.attributedText = self.objCashWalletDetail.terms_and_condition.html2Attributed
                            self.lblTermsAndConditionDescription.textColor = .white
                            self.lblTermsAndConditionDescription.font = UIFont.init(name: Fonts.PoppinsRegular, size: self.lblTermsAndConditionDescription.font.pointSize)!
                            self.lblTermsAndConditionDescription.textAlignment = .left
                            self.lblTermsAndConditionDescription.backgroundColor = .clear

                            if self.objCashWalletDetail.arrFundOptions.count > 0 {
                                self.collectionStackVW.isHidden = false
                                self.objSelectedTopupFund = self.objCashWalletDetail.arrFundOptions[0]
                            }
                            else {
                                self.collectionStackVW.isHidden = true
                            }
                            
                            self.arrFundTransferType = self.objCashWalletDetail.arrFundOptions
                            
                            self.lblTopupFundTitle.text = "Transfer Your Funds".localized()
                            if self.objCashWalletDetail.proof_status == "0" {
                                self.tblVW.isHidden = true
                                self.lblMessage.text = self.objCashWalletDetail.proof_pending_msg
                                self.vwMessage.isHidden = false
                            }
                            else {
                                self.vwMessage.isHidden = true
                                
                                self.headerContainerStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                                self.headerContainerStackView.addArrangedSubview(self.vwTransferYourFunds)

                                self.calculateAndSetTableHeaderViewHeight()
                                self.collectionVW.reloadData()
                                self.tblVW.reloadData()
                                self.collectionViewHistory.reloadData()
                                
                                self.collectionVW.reloadSections(IndexSet(integer: 0))
                                //self.collectionVW.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                                self.collectionVW.contentOffset = .zero
                                
                                DispatchQueue.main.async {
                                    self.tblVW.isHidden = false
                                }
                            }
                        }
                    }
                    else if response["code"] as! Int == 301 {
                        self.walletHistoryRequestState = REQUEST.failedORNoMoreData
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else {
                        self.walletHistoryRequestState = REQUEST.failedORNoMoreData
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }) { (error) in
            GlobalData.hideProgress()
            self.walletHistoryRequestState = REQUEST.failedORNoMoreData
            GlobalData.shared.showLightStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    func transferMoney(amount: String, password: String, authType: String, fundType: String) {
        self.view.endEditing(true)
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String: Any] = [:]
        params["amount"] = amount
        params["auth_type"] = authType
        params["security_password"] = password
        params["fund_type"] = fundType
        
        let strParam = GlobalData.shared.convertParameter(inJSONString: params)
        debugPrint(strParam)
        
        GlobalData.showDefaultProgress()
        AFWrapper.requestPOSTURL(BASE_URL + URLS.TRANSFER_MONEY, params: params as [String : AnyObject], headers: nil, success: { [weak self]
            (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            guard let self = self else { return }
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                        
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let cashBalance = payload["cash_wallet_balance"] as? Double {
                                self.cashWalletBalance = cashBalance
                                self.lblFundBalance.text = "$" + String(format: "%.2f", self.cashWalletBalance)
                            }
                            if let newHistory = payload["history"] as? Dictionary<String, Any> {
                                let objNewHistory = CashWalletHistoryObject.init(newHistory)
                                self.arrHistory.insert(objNewHistory, at: 0)
                                //self.objCashWalletDetail.arrHistory.insert(objNewHistory, at: 0)
                            }
                        }
                        
                        self.txtSelectedFund.text = "Select Funds Type".localized()
                        self.txtTYFAmountUSD.text = ""
                        self.txtTYFSecurityPassword.text = ""
//                        self.clearFields = true
                        self.tblVW.isHidden = false
                        self.tblVW.reloadData()
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
    
    func transferMT5Money(amount: String, password: String, authType: String) {
        self.view.endEditing(true)
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String: Any] = [:]
        params["amount"] = amount
        params["auth_type"] = authType
        params["security_password"] = password
        
        let strParam = GlobalData.shared.convertParameter(inJSONString: params)
        debugPrint(strParam)
        
        GlobalData.showDefaultProgress()
        AFWrapper.requestPOSTURL(BASE_URL + URLS.TRANSFER_MT5_MONEY, params: params as [String : AnyObject], headers: nil, success: { [weak self]
            (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            guard let self = self else { return }
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                        
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let cashBalance = payload["cash_wallet_balance"] as? Double {
                                self.cashWalletBalance = cashBalance
                                self.lblFundBalance.text = "$" + String(format: "%.2f", self.cashWalletBalance)
                            }
                            if let newHistory = payload["history"] as? Dictionary<String, Any> {
                                let objNewHistory = CashWalletHistoryObject.init(newHistory)
                                self.arrHistory.insert(objNewHistory, at: 0)
                                //self.objCashWalletDetail.arrHistory.insert(objNewHistory, at: 0)
                            }
                        }
                        
                        self.txtMT5AmountUSD.text = ""
                        self.txtMT5SecurityPassword.text = ""
//                        self.clearFields = true
                        self.tblVW.isHidden = false
                        self.tblVW.reloadData()
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
}
