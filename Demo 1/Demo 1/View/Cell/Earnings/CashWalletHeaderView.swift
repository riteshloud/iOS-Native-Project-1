//
//  CashWalletHeaderView.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import DropDown
import SwiftValidators
import LocalAuthentication

class CashWalletHeaderView: UITableViewHeaderFooterView {
    
    enum HistoryType {
        case walletHistory
        
        var title: String {
            switch self {
            case .walletHistory:
                return "Wallet History".localized()
            }
        }
    }
    
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
    
    @IBOutlet weak var lblAccountBalanceTitle: UILabel!
    @IBOutlet weak var lblAccountBalanceValue: UILabel!
    @IBOutlet weak var vwFundType: UIView!
    @IBOutlet weak var txtSelectedFund: UITextField!
    @IBOutlet weak var btnFundTypeDropDown: UIButton!
    
    @IBOutlet weak var vwOtherDetails: UIView!
    @IBOutlet weak var txtAmountUSD: UITextField!
    
    @IBOutlet weak var radioButtonStackView: UIStackView!
    @IBOutlet weak var btnSecurityPassword: UIButton!
    @IBOutlet weak var btnBiometric: UIButton!
    
    @IBOutlet weak var securityPasswordStackView: UIStackView!
    @IBOutlet weak var txtSecurityPassword: UITextField!
    @IBOutlet weak var lblTermsAndConditionTitle: UILabel!
    @IBOutlet weak var lblTermsAndConditionDescription: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var vwCollectionContainer: UIView!
    @IBOutlet weak var collectionVWHistory: UICollectionView!
    
    //SECURITY PASSWORD
    var nSecuritySelectedOption: Int = 0
    var arrSecurityRadioButtons = [UIButton]()
    var onSecurityRadioButtonValueChange: (()->Void)?
    
    //var arrFundTypes: [FundsType] = [.selectWallet, .FundsWallet, .WithdrawalWallet]
    var selectedFundType: FundsType = .selectWallet
    
    var historyTypes: [HistoryType] = [.walletHistory]
    var arrHistory: [String] = ["Cash Wallet History".localized()]
    var onHistoryTypeChange: ((HistoryType)->Void)?
    var onSubmitTap: ((String, String, String, String)->Void)?
    
    var selectedCellTab : Int = 0
    
    var fundsDropDown = DropDown()
    var arrFundTypes: [String] = ["Select Funds Type".localized(), "Funds Wallet".localized(), "Withdrawal Wallet".localized(), "Stock Wallet".localized()]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblAccountBalanceTitle.text = "Account Balance".localized()
        self.txtAmountUSD.placeholder = "Amount USD".localized()
        self.txtAmountUSD.placeHolderColor = .white
        self.txtAmountUSD.delegate = self
        self.txtSecurityPassword.placeholder = "Security Password".localized()
        self.txtSecurityPassword.placeHolderColor = .white
        self.lblTermsAndConditionTitle.text = "Terms & Conditions".localized()
        self.btnSubmit.setTitle("Submit".localized(), for: [])
        
        self.btnSecurityPassword.titleLabel?.numberOfLines = 0
        self.btnSecurityPassword.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnSecurityPassword.setTitle("Security Password".localized(), for: [])
        self.btnSecurityPassword.sizeToFit()
        
        self.btnBiometric.setTitle("Biometric".localized(), for: [])
        
        self.setupCollectionViews()
        
        //SECURITY PASSWORD
        arrSecurityRadioButtons.removeAll()
        arrSecurityRadioButtons.append(self.btnSecurityPassword)
        arrSecurityRadioButtons.append(self.btnBiometric)
        self.btnSecurityPassword.isSelected = true
        self.btnBiometric.isSelected = false
        
        self.setupFundsDropDown()
    }
    
    //MARK:- Set HeaderView Data
    func configure(with detail: CashWalletDetailObject, cashBalance: Double, shouldClearFields: Bool) {
        DispatchQueue.main.async {
            self.vwCollectionContainer.roundCorners(corners: [.topLeft, .topRight], radius: 6)
        }
        
        if shouldClearFields {
            self.txtAmountUSD.text = ""
            self.txtSecurityPassword.text = ""
        }

        self.lblAccountBalanceValue.text = "$" + String(format: "%.2f", cashBalance)
        self.lblTermsAndConditionDescription.attributedText = detail.terms_and_condition.html2Attributed
        self.lblTermsAndConditionDescription.textColor = .white
        self.lblTermsAndConditionDescription.font = UIFont(name: Fonts.PoppinsLight, size: 13)
        self.lblTermsAndConditionDescription.textAlignment = .left
    }
    
    //MARK:- Check Biometric Availibility
    func checkBiometricEnrolledOrAvailable() {
        let currentType = LAContext().biometricType
        if currentType == .none && GlobalData.shared.nBiometricErrorCode != -8 {
            self.radioButtonStackView.isHidden = true
        }
        else {
            if GlobalData.shared.isUUIDExistInUserDefault() {
                self.radioButtonStackView.isHidden = false
            }
            else {
                self.radioButtonStackView.isHidden = true
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
    
    //MARK:- SetUp UICollectionView
    private func setupCollectionViews() {
        self.collectionVWHistory.delegate = self
        self.collectionVWHistory.dataSource = self
        
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        self.collectionVWHistory.register(nib, forCellWithReuseIdentifier: "HistoryCell")
        
        if arrHistory.count > 0 {
            DispatchQueue.main.async {
                self.collectionVWHistory.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
            }
        }
    }
    
    //MARK:- UIButton Action
    @IBAction func btnFundTypeDropdownTapped(_ sender: UIButton) {
        self.endEditing(true)
        self.fundsDropDown.show()
    }
    
    func resetSecurityButtonStates() {
        for button in arrSecurityRadioButtons {
            button.isSelected = false
        }
    }
    
    @IBAction func btnRadioAction(_ sender: UIButton) {
        self.endEditing(true)
        let isAlreadySelected = sender.isSelected == true
        if !isAlreadySelected {
            resetSecurityButtonStates()
            
            sender.isSelected = true
            self.nSecuritySelectedOption = sender.tag
            debugPrint(self.nSecuritySelectedOption)
            
            if self.nSecuritySelectedOption == 0 {
                self.showSecurityPasswordSection()
            }
            else {
                self.txtSecurityPassword.resignFirstResponder()
                self.hideSecurityPasswordSection()
            }
            
            self.onSecurityRadioButtonValueChange?()
        }
        else {
        }
    }
    
    func hideSecurityPasswordSection() {
        self.securityPasswordStackView.isHidden = true
    }
    
    func showSecurityPasswordSection() {
        self.securityPasswordStackView.isHidden = false
    }
    
    
    private func validate() -> (String, String, String)? {
        let securitypasswordtrimmedString = self.txtSecurityPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let amounttrimmedString = self.txtAmountUSD.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
        if self.nSecuritySelectedOption == 0 {
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
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        self.endEditing(true)
        
        guard let (amount, password, authType) = validate() else { return }
        
        if self.nSecuritySelectedOption == 0 {
            if self.txtSelectedFund.text == "Funds Wallet".localized() {
                self.onSubmitTap?(amount, password, authType, "0")
            } else if self.txtSelectedFund.text == "Withdrawal Wallet".localized() {
                self.onSubmitTap?(amount, password, authType, "1")
            } else if self.txtSelectedFund.text == "Stock Wallet".localized() {
                self.onSubmitTap?(amount, password, authType, "2")
            }
        }
        else {
            if self.txtSelectedFund.text == "Funds Wallet".localized() {
                self.authenticationWithTouchID(amount: amount, password: password, strAuthType: authType, fundType: "0")
            } else if self.txtSelectedFund.text == "Withdrawal Wallet".localized() {
                self.authenticationWithTouchID(amount: amount, password: password, strAuthType: authType, fundType: "1")
            } else if self.txtSelectedFund.text == "Stock Wallet".localized() {
                self.authenticationWithTouchID(amount: amount, password: password, strAuthType: authType, fundType: "2")
            }
        }
    }
}

//MARK:- UICollectionView Delegate & DataSource
extension CashWalletHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        
        cell.nameLabel.text = arrHistory[indexPath.item]
        cell.topIndicator.isHidden = true
        cell.nameLabel.textColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.endEditing(true)
        let selectedHistoryType = self.historyTypes[indexPath.item]
        selectedCellTab = indexPath.item
        self.onHistoryTypeChange?(selectedHistoryType)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: Fonts.PoppinsMedium, size: 16)!
        let height = collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
        var width: CGFloat = 0
        let item = self.arrHistory[indexPath.item]
        width = NSString(string: item).size(withAttributes: [NSAttributedString.Key.font : font]).width
        return CGSize(width: width + 32, height: height)
    }
}

//MARK:- BioMetric Authentication
extension CashWalletHeaderView {
    func authenticationWithTouchID(amount: String, password: String, strAuthType: String, fundType: String) {
        GlobalData.shared.authenticateTouchIDGlobally { (success) in
            if success == true {
                self.onSubmitTap?(amount, password, strAuthType, fundType)
            }
        }
    }
}

//MARK:- UITextField Delegate
extension CashWalletHeaderView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var returnValue = true
        if textField == self.txtAmountUSD {
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
