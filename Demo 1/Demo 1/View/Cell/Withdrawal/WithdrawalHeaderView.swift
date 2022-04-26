//
//  WithdrawalHeaderView.swift
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

enum WithdrawalType: Equatable {
    case bankTransfer
    case usdtErc
    case usdtTrc
    case usdcErc
    
    var title: String {
        switch self {
        case .bankTransfer:
            return "Bank Transfer".localized()
        case .usdtErc:
            return "USDT(ERC-20)".localized()
        case .usdtTrc:
            return "USDT(TRC-20)".localized()
        case .usdcErc:
            return "USDC (ERC-20)".localized()
        }
    }
}

class WithdrawalHeaderView: UITableViewHeaderFooterView {
    
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
    
    @IBOutlet weak var vwBalanceDetail: UIView!
    @IBOutlet weak var lblAccountBalanceTitle: UILabel!
    @IBOutlet weak var lblAccountBalance: UILabel!
    
    
    @IBOutlet weak var vwBottomDetails: UIView!
    @IBOutlet weak var lblWithdrawalTitle: UILabel!
    @IBOutlet weak var collectionVW: UICollectionView!
    @IBOutlet weak var lblTermsAndConditionTitle: UnderlinedLabel!
    @IBOutlet weak var lblTermsAndConditionDescription: UILabel!
    
    @IBOutlet weak var txtAmountUSD: UITextField!
    @IBOutlet weak var radioButtonStackView: UIStackView!
    @IBOutlet weak var btnSecurityPassword: UIButton!
    @IBOutlet weak var btnBiometric: UIButton!
    @IBOutlet weak var securityPasswordStackView: UIStackView!
    @IBOutlet weak var txtSecurityPassword: UITextField!
    
    //USDT ERC-20
    @IBOutlet weak var stackViewUSDTErcAddress: UIStackView!
    @IBOutlet weak var txtUSDTErcAddress: UITextField!
    @IBOutlet weak var stackViewUSDTErcPhoto: UIStackView!
//    @IBOutlet weak var usdtErcPhotoView: UIView!
    @IBOutlet var lblUSDTErcPhoto: UILabel!
    @IBOutlet var imageViewUSDTErcProof: UIImageView!
    @IBOutlet var iconUSDTErcUpload: UIImageView!
    @IBOutlet var lblDragandDropUSDTErc: UILabel!
    @IBOutlet var uploadUSDTErcProofButton: UIButton!
    
    //USDT TRC-20
    @IBOutlet weak var stackViewUSDTTrcAddress: UIStackView!
    @IBOutlet weak var txtUSDTTrcAddress: UITextField!
    @IBOutlet weak var stackViewUSDTTrcPhoto: UIStackView!
    @IBOutlet var lblUSDTTrcPhoto: UILabel!
    @IBOutlet var imageViewUSDTTrcProof: UIImageView!
    @IBOutlet var iconUSDTTrcUpload: UIImageView!
    @IBOutlet var lblDragandDropUSDTTrc: UILabel!
    @IBOutlet var uploadUSDTTrcProofButton: UIButton!
    
    //USDC ERC-20
    @IBOutlet weak var stackViewUSDCErcAddress: UIStackView!
    @IBOutlet weak var txtUSDCErcAddress: UITextField!
    @IBOutlet weak var stackViewUSDCErcPhoto: UIStackView!
//    @IBOutlet weak var usdcErcPhotoView: UIView!
    @IBOutlet var lblUSDCErcPhoto: UILabel!
    @IBOutlet var imageViewUSDCErcProof: UIImageView!
    @IBOutlet var iconUSDCErcUpload: UIImageView!
    @IBOutlet var lblDragandDropUSDCErc: UILabel!
    @IBOutlet var uploadUSDCErcProofButton: UIButton!
    
    @IBOutlet weak var btnRequestForWithdrawal: UIButton!
    @IBOutlet weak var vwCollectionContainer: UIView!
    @IBOutlet weak var collectionViewHistory: UICollectionView!
    
    var transferTypes: [WithdrawalType] = []
    
    //SECURITY PASSWORD
    var nSecuritySelectedOption: Int = 0
    var arrSecurityRadioButtons = [UIButton]()
    var onSecurityRadioButtonValueChange: (()->Void)?
    var onWithdrawalTypeValueChange: (()->Void)?
    
    var selectedFundTransferType: WithdrawalType = .bankTransfer
    var onHistoryTypeChange: ((HistoryType)->Void)?

    var onBankTransferTap: ((String, String, String)->Void)?
    var onUSDTErcTransferTap: ((String, String, String, String)->Void)?
    var onUSDTTrcTransferTap: ((String, String, String, String)->Void)?
    var onUSDCErcTransferTap: ((String, String, String, String)->Void)?
    
    var selectedCellTab : Int = 0
    
    var arrFundTypes: [String] = ["Select Funds Type".localized(), "Funds Wallet".localized(), "Withdrawal Wallet".localized()]
    var usdtErcProofLink: String = String()
    var usdtErcProofDocument: Document?
    
    var usdtTrcProofLink: String = String()
    var usdtTrcProofDocument: Document?
    
    var usdcErcProofLink: String = String()
    var usdcErcProofDocument: Document?
    
    var usdtErcTitle = String()
    var usdtTrcTitle = String()
    var usdcErcTitle = String()
    
    var localUSDTErcValue = String()
    var localUSDTTrcValue = String()
    var localUSDCErcValue = String()
    
    var controller: WithdrawalVC!
    var imagePicker = UIImagePickerController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblAccountBalanceTitle.text = "Account Balance".localized()
        self.lblWithdrawalTitle.text = "Withdrawal".localized()
        
        self.txtAmountUSD.placeholder = "Amount USD".localized()
        self.txtAmountUSD.placeHolderColor = .white
        self.txtAmountUSD.delegate = self
        self.txtSecurityPassword.placeholder = "Security Password".localized()
        self.txtSecurityPassword.placeHolderColor = .white
        self.txtUSDTErcAddress.placeholder = "USDT Address".localized()
        self.txtUSDTErcAddress.placeHolderColor = .white
        self.txtUSDTTrcAddress.placeholder = "USDT Address".localized()
        self.txtUSDTTrcAddress.placeHolderColor = .white
        self.txtUSDCErcAddress.placeholder = "USDC Address".localized()
        self.txtUSDCErcAddress.placeHolderColor = .white
        
        self.lblUSDTErcPhoto.text = "USDT Photo".localized()
        self.lblUSDTTrcPhoto.text = "USDT Photo".localized()
        self.lblUSDCErcPhoto.text = "USDC Photo".localized()
        self.lblDragandDropUSDTErc.text = "Drag and drop a file here or click".localized()
        self.lblDragandDropUSDTTrc.text = "Drag and drop a file here or click".localized()
        self.lblDragandDropUSDCErc.text = "Drag and drop a file here or click".localized()
        self.lblTermsAndConditionTitle.text = "Terms & Conditions".localized()
        self.btnRequestForWithdrawal.setTitle("Request for Withdrawal".localized(), for: [])
        
        self.btnSecurityPassword.titleLabel?.numberOfLines = 0
        self.btnSecurityPassword.setTitleColor(.white, for: [])
        self.btnSecurityPassword.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnSecurityPassword.setTitle("Security Password".localized(), for: [])
        self.btnSecurityPassword.sizeToFit()
        
        self.btnBiometric.setTitleColor(.white, for: [])
        self.btnBiometric.setTitle("Biometric".localized(), for: [])
        
        self.setupCollectionViews()
        
        self.arrSecurityRadioButtons.append(self.btnSecurityPassword)
        self.arrSecurityRadioButtons.append(self.btnBiometric)
        self.btnSecurityPassword.isSelected = true
        self.btnBiometric.isSelected = false
        
        
        //USDT ERC-20
        self.stackViewUSDTErcAddress.isHidden = true
        self.stackViewUSDTErcPhoto.isHidden = true
        
        //USDT TRC-20
        self.stackViewUSDTTrcAddress.isHidden = true
        self.stackViewUSDTTrcPhoto.isHidden = true
        
        //USDT ERC-20
        self.stackViewUSDCErcAddress.isHidden = true
        self.stackViewUSDCErcPhoto.isHidden = true
    }
    
    //MARK:- Set HeaderView Data
    func configure(with detail: WithdrawalWalletDetailObject, cashBalance: Double, shouldClearFields: Bool, cont: WithdrawalVC, isApiRefresh: Bool) {
        self.controller = cont
        DispatchQueue.main.async {
            self.vwCollectionContainer.roundCorners(corners: [.topLeft, .topRight], radius: 6)
        }
        
        self.selectedFundTransferType = GlobalData.shared.selectedWithdrawalType
        
        if isApiRefresh {
            //USDT ERC-20
            self.stackViewUSDTErcAddress.isHidden = true
            self.stackViewUSDTErcPhoto.isHidden = true
            
            //USDT TRC-20
            self.stackViewUSDTTrcAddress.isHidden = true
            self.stackViewUSDTTrcPhoto.isHidden = true
            
            //USDC ERC-20
            self.stackViewUSDCErcAddress.isHidden = true
            self.stackViewUSDCErcPhoto.isHidden = true
            
            if self.selectedFundTransferType != .bankTransfer {
                if self.selectedFundTransferType == .usdcErc {
                    //USDT ERC-20
                    self.stackViewUSDTErcAddress.isHidden = true
                    self.stackViewUSDTErcPhoto.isHidden = true
                    
                    //USDT TRC-20
                    self.stackViewUSDTTrcAddress.isHidden = true
                    self.stackViewUSDTTrcPhoto.isHidden = true
                    
                    //USDC ERC-20
                    self.stackViewUSDCErcAddress.isHidden = false
                    self.stackViewUSDCErcPhoto.isHidden = false
                } else {
                    //USDT ERC-20
                    self.stackViewUSDTErcAddress.isHidden = false
                    self.stackViewUSDTErcPhoto.isHidden = false
                    
                    //USDT TRC-20
                    self.stackViewUSDTTrcAddress.isHidden = true
                    self.stackViewUSDTTrcPhoto.isHidden = true
                    
                    //USDC ERC-20
                    self.stackViewUSDCErcAddress.isHidden = true
                    self.stackViewUSDCErcPhoto.isHidden = true
                }
                
                self.onWithdrawalTypeValueChange?()
            }
        }
        
        debugPrint("isApiRefresh: \(isApiRefresh)");
        debugPrint("self.selectedFundTransferType: \(self.selectedFundTransferType)");
        
        if shouldClearFields {
            self.txtAmountUSD.text = ""
            self.txtSecurityPassword.text = ""
        }
        
        self.lblAccountBalance.text = "$" + String(format: "%.2f", cashBalance)
        self.usdtErcTitle = detail.usdt_text
        self.usdtTrcTitle = detail.usdt_trc_text
        self.usdcErcTitle = detail.usdc_erc_text
        
        self.lblUSDTErcPhoto.text = "USDT Photo".localized()
        self.lblUSDTTrcPhoto.text = "USDT Photo".localized()
        self.lblUSDCErcPhoto.text = "USDC Photo".localized()
        
        //USDT ERC-20
        let ercCondition = detail.usdtErc_address.isEmpty
        self.txtUSDTErcAddress.isEnabled = ercCondition
        if !ercCondition {
            self.txtUSDTErcAddress.textColor = GlobalData.shared.hexStringToUIColor(hex: "#8E8E93")
        } else {
            self.txtUSDTErcAddress.textColor = .white
        }
        
        if detail.usdtErc_address.isEmpty && !self.localUSDTErcValue.isEmpty {
            self.txtUSDTErcAddress.text = self.localUSDTErcValue
        } else {
            self.txtUSDTErcAddress.text = detail.usdtErc_address
        }
        self.loadImage(from: detail.usdtErc_proof, isUSDTErc: true, isUSDTTrc: false, isUSDCErc: false)
        
        //USDT TRC-20
        let trcCondition = detail.usdtTrc_address.isEmpty
        self.txtUSDTTrcAddress.isEnabled = trcCondition
        if !trcCondition {
            self.txtUSDTTrcAddress.textColor = GlobalData.shared.hexStringToUIColor(hex: "#8E8E93")
        } else {
            self.txtUSDTTrcAddress.textColor = .white
        }
        
        if detail.usdtTrc_address.isEmpty && !self.localUSDTTrcValue.isEmpty {
            self.txtUSDTTrcAddress.text = self.localUSDTTrcValue
        } else {
            self.txtUSDTTrcAddress.text = detail.usdtTrc_address
        }
        self.loadImage(from: detail.usdtTrc_proof, isUSDTErc: false, isUSDTTrc: true, isUSDCErc: false)
        
        //USDC ERC-20
        let usdcErcCondition = detail.usdcErc_address.isEmpty
        self.txtUSDCErcAddress.isEnabled = usdcErcCondition
        if !usdcErcCondition {
            self.txtUSDCErcAddress.textColor = GlobalData.shared.hexStringToUIColor(hex: "#8E8E93")
        } else {
            self.txtUSDCErcAddress.textColor = .white
        }
        
        if detail.usdcErc_address.isEmpty && !self.localUSDCErcValue.isEmpty {
            self.txtUSDCErcAddress.text = self.localUSDCErcValue
        } else {
            self.txtUSDCErcAddress.text = detail.usdcErc_address
        }
        self.loadImage(from: detail.usdcErc_proof, isUSDTErc: false, isUSDTTrc: false, isUSDCErc: true)
        
        if detail.enable_bank_option == "1" {
//            self.selectedFundTransferType = .bankTransfer
//            self.stackViewUSDTAddress.isHidden = true
//            self.usdtPhotoView.isHidden = true
            self.transferTypes = [.bankTransfer, .usdtErc, .usdtTrc, .usdcErc]
        }
        else {
//            self.selectedFundTransferType = .usdt
//            self.stackViewUSDTAddress.isHidden = false
//            self.usdtPhotoView.isHidden = false
            self.transferTypes = [.usdtErc, .usdtTrc, .usdcErc]
        }
        
        self.collectionVW.reloadData()
        self.lblTermsAndConditionDescription.attributedText = detail.terms_and_condition.html2Attributed
        self.lblTermsAndConditionDescription.textColor = .white
        self.lblTermsAndConditionDescription.font = UIFont(name: Fonts.PoppinsLight, size: 13)
        self.lblTermsAndConditionDescription.textAlignment = .left
    }
    
    private func loadImage(from urlString: String, isUSDTErc: Bool, isUSDTTrc: Bool, isUSDCErc: Bool) {
        guard let url = URL(string: urlString) else { return }
        
        if isUSDTErc {
            self.usdtErcProofLink = urlString
            if url.pathExtension == "pdf" {
                self.imageViewUSDTErcProof.image = #imageLiteral(resourceName: "pdfreceipt")
                self.imageViewUSDTErcProof.contentMode = .topLeft
                self.imageViewUSDTErcProof.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 223/255.0, alpha: 1.0)
                self.iconUSDTErcUpload.isHidden = true
                self.lblDragandDropUSDTErc.isHidden = true
                return
            }
            DispatchQueue.global(qos: .userInteractive).async {
                guard let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageViewUSDTErcProof.image = image
                    self.imageViewUSDTErcProof.contentMode = .scaleAspectFill
                    self.imageViewUSDTErcProof.backgroundColor = .clear
                    self.iconUSDTErcUpload.isHidden = true
                    self.lblDragandDropUSDTErc.isHidden = true
                }
            }
        } else if isUSDTTrc {
            self.usdtTrcProofLink = urlString
            if url.pathExtension == "pdf" {
                self.imageViewUSDTTrcProof.image = #imageLiteral(resourceName: "pdfreceipt")
                self.imageViewUSDTTrcProof.contentMode = .topLeft
                self.imageViewUSDTTrcProof.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 223/255.0, alpha: 1.0)
                self.iconUSDTTrcUpload.isHidden = true
                self.lblDragandDropUSDTTrc.isHidden = true
                return
            }
            DispatchQueue.global(qos: .userInteractive).async {
                guard let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageViewUSDTTrcProof.image = image
                    self.imageViewUSDTTrcProof.contentMode = .scaleAspectFill
                    self.imageViewUSDTTrcProof.backgroundColor = .clear
                    self.iconUSDTTrcUpload.isHidden = true
                    self.lblDragandDropUSDTTrc.isHidden = true
                }
            }
        } else {
            self.usdcErcProofLink = urlString
            if url.pathExtension == "pdf" {
                self.imageViewUSDCErcProof.image = #imageLiteral(resourceName: "pdfreceipt")
                self.imageViewUSDCErcProof.contentMode = .topLeft
                self.imageViewUSDCErcProof.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 223/255.0, alpha: 1.0)
                self.iconUSDCErcUpload.isHidden = true
                self.lblDragandDropUSDCErc.isHidden = true
                return
            }
            DispatchQueue.global(qos: .userInteractive).async {
                guard let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageViewUSDCErcProof.image = image
                    self.imageViewUSDCErcProof.contentMode = .scaleAspectFill
                    self.imageViewUSDCErcProof.backgroundColor = .clear
                    self.iconUSDCErcUpload.isHidden = true
                    self.lblDragandDropUSDCErc.isHidden = true
                }
            }
        }
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
    
    //MARK:- SetUp UICollectionView
    private func setupCollectionViews() {
        self.collectionViewHistory.delegate = self
        self.collectionViewHistory.dataSource = self
        
        self.collectionVW.delegate = self
        self.collectionVW.dataSource = self
        
        let optionNib = UINib(nibName: "OptionsCell", bundle: nil)
        self.collectionVW.register(optionNib, forCellWithReuseIdentifier: "OptionsCell")
        
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        self.collectionViewHistory.register(nib, forCellWithReuseIdentifier: "HistoryCell")
        
        if self.historyTypes.count > 0 {
            DispatchQueue.main.async {
                self.collectionViewHistory.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
            }
        }
    }
    
    //MARK:- UIButton Action
    @IBAction func actionUploadUSDTErcProof(_ sender: Any) {
        self.endEditing(true)
        if self.iconUSDTErcUpload.isHidden == true {
            if self.usdtErcProofLink.contains("pdf") {
                UIApplication.shared.open(URL(string: self.usdtErcProofLink)!, options: [:], completionHandler: nil)
            }
            else {
                let imageInfo :JTSImageInfo = JTSImageInfo()
                imageInfo.imageURL = URL(string: self.usdtErcProofLink)
                var imageViewer :JTSImageViewController = JTSImageViewController()
                imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions())
                imageViewer.modalPresentationStyle = .fullScreen
                self.controller.isNeedToReload = false
                imageViewer.show(from: self.controller, transition: JTSImageViewControllerTransition.fromOriginalPosition)
            }
        } else {
            self.showActionSheet()
        }
    }
    
    @IBAction func actionUploadUSDTTrcProof(_ sender: Any) {
        self.endEditing(true)
        if self.iconUSDTTrcUpload.isHidden == true {
            if self.usdtTrcProofLink.contains("pdf") {
                UIApplication.shared.open(URL(string: self.usdtTrcProofLink)!, options: [:], completionHandler: nil)
            }
            else {
                let imageInfo :JTSImageInfo = JTSImageInfo()
                imageInfo.imageURL = URL(string: self.usdtTrcProofLink)
                var imageViewer :JTSImageViewController = JTSImageViewController()
                imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions())
                imageViewer.modalPresentationStyle = .fullScreen
                self.controller.isNeedToReload = false
                imageViewer.show(from: self.controller, transition: JTSImageViewControllerTransition.fromOriginalPosition)
            }
        } else {
            self.showActionSheet()
        }
    }
    
    @IBAction func actionUploadUSDCErcProof(_ sender: Any) {
        self.endEditing(true)
        if self.iconUSDCErcUpload.isHidden == true {
            if self.usdcErcProofLink.contains("pdf") {
                UIApplication.shared.open(URL(string: self.usdcErcProofLink)!, options: [:], completionHandler: nil)
            }
            else {
                let imageInfo :JTSImageInfo = JTSImageInfo()
                imageInfo.imageURL = URL(string: self.usdcErcProofLink)
                var imageViewer :JTSImageViewController = JTSImageViewController()
                imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions())
                imageViewer.modalPresentationStyle = .fullScreen
                self.controller.isNeedToReload = false
                imageViewer.show(from: self.controller, transition: JTSImageViewControllerTransition.fromOriginalPosition)
            }
        } else {
            self.showActionSheet()
        }
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Capture photo from camera".localized(), style: .default) { action in
            self.openCamera()
        }
        actionSheet.addAction(cameraAction)
        let albumAction = UIAlertAction(title: "Select from photo library".localized(), style: .default) { action in
            self.openGallary()
        }
        actionSheet.addAction(albumAction)
        let pdfAction = UIAlertAction(title: "Select from Documents".localized(), style: .default) { action in
            self.openPDF()
        }
        actionSheet.addAction(pdfAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { action in }
        actionSheet.addAction(cancelAction)
        self.controller.present(actionSheet, animated: true, completion: nil)
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
    
    @IBAction func btnRequestForWithdrawalTapped(_ sender: UIButton) {
        switch selectedFundTransferType {
        case .bankTransfer:
            guard let (amount, password, authType) = validateBankTransferWithdrawalRequest() else { return }
            
            if self.nSecuritySelectedOption == 0 {
                self.onBankTransferTap?(amount, password, authType)
            }
            else {
                self.authenticateBankTransferWithTouchID(amount: amount, password: password, strAuthType: authType)
            }
        case .usdtErc:
            guard let (amount, password, authType, usdtAddress) = validateUSDTErcWithdrawalRequest() else { return }
            
            if self.nSecuritySelectedOption == 0 {
                self.onUSDTErcTransferTap?(amount, password, authType, usdtAddress)
            }
            else {
                self.authenticateUSDTTransferWithTouchID(amount: amount, password: password, strAuthType: authType, usdtAddress: usdtAddress, isUSDTErc: true, isUSDTTrc: false, isUSDCErc: false)
            }
        case .usdtTrc:
            guard let (amount, password, authType, usdtAddress) = validateUSDTTrcWithdrawalRequest() else { return }
            
            if self.nSecuritySelectedOption == 0 {
                self.onUSDTTrcTransferTap?(amount, password, authType, usdtAddress)
            }
            else {
                self.authenticateUSDTTransferWithTouchID(amount: amount, password: password, strAuthType: authType, usdtAddress: usdtAddress, isUSDTErc: false, isUSDTTrc: true, isUSDCErc: false)
            }
        case .usdcErc:
            guard let (amount, password, authType, usdcAddress) = validateUSDCErcWithdrawalRequest() else { return }
            
            if self.nSecuritySelectedOption == 0 {
                self.onUSDCErcTransferTap?(amount, password, authType, usdcAddress)
            }
            else {
                self.authenticateUSDTTransferWithTouchID(amount: amount, password: password, strAuthType: authType, usdtAddress: usdcAddress, isUSDTErc: false, isUSDTTrc: false, isUSDCErc: true)
            }
        }
    }
    
    //MARK:- Validation
    private func validateUSDTErcWithdrawalRequest() -> (String, String, String, String)? {
        let amounttrimmedString = self.txtAmountUSD.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let securitypasswordtrimmedString = self.txtSecurityPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let usdtAddresstrimmedString = self.txtUSDTErcAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
        if self.nSecuritySelectedOption == 0 {
            if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == 0 {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else if !Validator.required().apply(securitypasswordtrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide security password!".localized())
                return nil
            }
            else if !Validator.required().apply(usdtAddresstrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDT address!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else {
                    if self.imageViewUSDTErcProof.image == nil {
                        GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDT photo!".localized())
                        return nil
                    }
                    else {
                        return (amounttrimmedString!, securitypasswordtrimmedString!, "normal", usdtAddresstrimmedString!)
                    }
                }
            }
        }
        else {
            if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == 0 {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else if !Validator.required().apply(usdtAddresstrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDT address!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else {
                    if self.imageViewUSDTErcProof.image == nil {
                        GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDT photo!".localized())
                        return nil
                    }
                }
                
                return (amounttrimmedString!, GlobalData.shared.getSavedUUIDFromUserDefault(), "finger", usdtAddresstrimmedString!)
            }
        }
    }
    
    private func validateUSDTTrcWithdrawalRequest() -> (String, String, String, String)? {
        let amounttrimmedString = self.txtAmountUSD.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let securitypasswordtrimmedString = self.txtSecurityPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let usdtAddresstrimmedString = self.txtUSDTTrcAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
        if self.nSecuritySelectedOption == 0 {
            if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == 0 {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else if !Validator.required().apply(securitypasswordtrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide security password!".localized())
                return nil
            }
            else if !Validator.required().apply(usdtAddresstrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDT address!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else {
                    if self.imageViewUSDTTrcProof.image == nil {
                        GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDT photo!".localized())
                        return nil
                    }
                    else {
                        return (amounttrimmedString!, securitypasswordtrimmedString!, "normal", usdtAddresstrimmedString!)
                    }
                }
            }
        }
        else {
            if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == 0 {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else if !Validator.required().apply(usdtAddresstrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDT address!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else {
                    if self.imageViewUSDTTrcProof.image == nil {
                        GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDT photo!".localized())
                        return nil
                    }
                }
                
                return (amounttrimmedString!, GlobalData.shared.getSavedUUIDFromUserDefault(), "finger", usdtAddresstrimmedString!)
            }
        }
    }
    
    private func validateUSDCErcWithdrawalRequest() -> (String, String, String, String)? {
        let amounttrimmedString = self.txtAmountUSD.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let securitypasswordtrimmedString = self.txtSecurityPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let usdcAddresstrimmedString = self.txtUSDCErcAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
        if self.nSecuritySelectedOption == 0 {
            if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == 0 {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else if !Validator.required().apply(securitypasswordtrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide security password!".localized())
                return nil
            }
            else if !Validator.required().apply(usdcAddresstrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDC address!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else {
                    if self.imageViewUSDCErcProof.image == nil {
                        GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDC photo!".localized())
                        return nil
                    }
                    else {
                        return (amounttrimmedString!, securitypasswordtrimmedString!, "normal", usdcAddresstrimmedString!)
                    }
                }
            }
        }
        else {
            if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == 0 {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                return nil
            }
            else if !Validator.required().apply(usdcAddresstrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDC address!".localized())
                return nil
            }
            else {
                let amount = Double(amounttrimmedString!)!
                if amount <= 0 {
                    GlobalData.shared.showLightStyleToastMesage(message: "Please provide valid amount!".localized())
                    return nil
                }
                else {
                    if self.imageViewUSDCErcProof.image == nil {
                        GlobalData.shared.showLightStyleToastMesage(message: "Please provide USDC photo!".localized())
                        return nil
                    }
                }
                
                return (amounttrimmedString!, GlobalData.shared.getSavedUUIDFromUserDefault(), "finger", usdcAddresstrimmedString!)
            }
        }
    }
    
    private func validateBankTransferWithdrawalRequest() -> (String, String, String)? {
        let amounttrimmedString = self.txtAmountUSD.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let securitypasswordtrimmedString = self.txtSecurityPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
        if self.nSecuritySelectedOption == 0 {
            if !Validator.required().apply(amounttrimmedString) {
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == 0 {
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
                    if !Validator.required().apply(securitypasswordtrimmedString) {
                        GlobalData.shared.showLightStyleToastMesage(message: "Please provide security password!".localized())
                        return nil
                    }
                    else {
                        return (amounttrimmedString!, securitypasswordtrimmedString!, "normal")
                    }
                }
            }
        }
        else {
            if !Validator.required().apply(amounttrimmedString){
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide amount!".localized())
                return nil
            }
            else if Double(amounttrimmedString!) == 0 {
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
}

//MARK:- Show Bank Proof Image upload
extension WithdrawalHeaderView {
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.imagePicker.allowsEditing = false
                self.controller.present(self.imagePicker, animated: true, completion: {
                    self.controller.isNeedToReload = false
                })
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        DispatchQueue.main.async {
                            self.imagePicker.delegate = self
                            self.imagePicker.sourceType = .camera
                            self.imagePicker.mediaTypes = [kUTTypeImage as String]
                            self.imagePicker.allowsEditing = false
                            self.controller.present(self.imagePicker, animated: true, completion: {
                                self.controller.isNeedToReload = false
                            })
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Unable to access the Camera".localized(), message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.".localized())
                        }
                    }
                })
            }
        } else {
            let alert  = UIAlertController(title: "Warning".localized(), message: "You don't have camera".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
            self.controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.imagePicker.allowsEditing = false
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
        self.imagePicker.delegate = self
        
        self.controller.isNeedToReload = false
        self.controller.present(imagePicker, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings".localized(), style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        })
        alert.addAction(settingsAction)
        self.controller.present(alert, animated: true, completion: nil)
    }
    
    func openPDF() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        documentPickerController.delegate = self
        
        self.controller.isNeedToReload = false
        self.controller.present(documentPickerController, animated: true, completion: nil)
    }
}

//MARK:- UIImagePickerController Delegate
extension WithdrawalHeaderView: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        let data = image.jpegData(compressionQuality: 0.5)!
        
        var name: String?
        
        if #available(iOS 11.0, *) {
            if let imageUrl = info[.imageURL] as? URL {
                name = imageUrl.lastPathComponent
            }
        } else {
            if let imageURL = info[.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                if let firstObject = result.firstObject {
                    let assetResources = PHAssetResource.assetResources(for: firstObject)
                    name = assetResources.first?.originalFilename
                }
            }
        }
        
        //        if let imageURL = info[.referenceURL] as? URL {
        //            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
        //            let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
        //            name = assetResources.first?.originalFilename
        //        }
        
        let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_usdtProof.jpg"
        
        if self.selectedFundTransferType == .usdtErc {
            let document = Document(
                uploadParameterKey: "usdt_proof",
                data: data,
                name: name ?? filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.usdtErcProofDocument = document
        } else if self.selectedFundTransferType == .usdtTrc {
            let document = Document(
                uploadParameterKey: "usdt_trc_proof",
                data: data,
                name: name ?? filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.usdtTrcProofDocument = document
        } else if self.selectedFundTransferType == .usdcErc {
            let document = Document(
                uploadParameterKey: "usdc_erc_proof",
                data: data,
                name: name ?? filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.usdcErcProofDocument = document
        }
        
        self.updateViews()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }
    
    //MARK:- Update USDT/USDC Photo View
    func updateViews() {
        if self.selectedFundTransferType == .usdtErc {
            guard let selectedDocument = self.usdtErcProofDocument else { return }
            if selectedDocument.mimeType == "application/pdf" {
                self.imageViewUSDTErcProof.image = #imageLiteral(resourceName: "pdfreceipt")
                self.imageViewUSDTErcProof.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 223/255.0, alpha: 1.0)
                self.imageViewUSDTErcProof.contentMode = .topLeft
            } else {
                self.imageViewUSDTErcProof.image = UIImage(data: selectedDocument.data)
                self.imageViewUSDTErcProof.backgroundColor = .clear
                self.imageViewUSDTErcProof.contentMode = .scaleAspectFill
            }
        } else if self.selectedFundTransferType == .usdtTrc {
            guard let selectedDocument = self.usdtTrcProofDocument else { return }
            if selectedDocument.mimeType == "application/pdf" {
                self.imageViewUSDTTrcProof.image = #imageLiteral(resourceName: "pdfreceipt")
                self.imageViewUSDTTrcProof.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 223/255.0, alpha: 1.0)
                self.imageViewUSDTTrcProof.contentMode = .topLeft
            } else {
                self.imageViewUSDTTrcProof.image = UIImage(data: selectedDocument.data)
                self.imageViewUSDTTrcProof.backgroundColor = .clear
                self.imageViewUSDTTrcProof.contentMode = .scaleAspectFill
            }
        } else {
            guard let selectedDocument = self.usdcErcProofDocument else { return }
            if selectedDocument.mimeType == "application/pdf" {
                self.imageViewUSDCErcProof.image = #imageLiteral(resourceName: "pdfreceipt")
                self.imageViewUSDCErcProof.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 223/255.0, alpha: 1.0)
                self.imageViewUSDCErcProof.contentMode = .topLeft
            } else {
                self.imageViewUSDCErcProof.image = UIImage(data: selectedDocument.data)
                self.imageViewUSDCErcProof.backgroundColor = .clear
                self.imageViewUSDCErcProof.contentMode = .scaleAspectFill
            }
        }
    }
}

//MARK:- UIDocumentPickerController Delegate
extension WithdrawalHeaderView: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        defer { self.updateViews() }
        do {
            let data = try Data(contentsOf: url)
            let name = url.lastPathComponent
            
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_usdtProof.pdf"
            
            if self.selectedFundTransferType == .usdtErc {
                let document = Document(
                    uploadParameterKey: "usdt_proof",
                    data: data,
                    name: name,
                    fileName: filename,
                    mimeType: "application/pdf"
                )
                self.usdtErcProofDocument = document
            } else if self.selectedFundTransferType == .usdtTrc {
                let document = Document(
                    uploadParameterKey: "usdt_trc_proof",
                    data: data,
                    name: name,
                    fileName: filename,
                    mimeType: "application/pdf"
                )
                self.usdtTrcProofDocument = document
            } else {
                let document = Document(
                    uploadParameterKey: "usdc_erc_proof",
                    data: data,
                    name: name,
                    fileName: filename,
                    mimeType: "application/pdf"
                )
                self.usdcErcProofDocument = document
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UICollectionView Delegate & DataSource
extension WithdrawalHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewHistory {
            return self.historyTypes.count
        }
        else {
            return self.transferTypes.count
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
            
            let item = self.transferTypes[indexPath.item]
            if item.title == "USDT(ERC-20)" {
                cell.lblTitle.text = usdtErcTitle
            } else if item.title == "USDT(TRC-20)" {
                cell.lblTitle.text = usdtTrcTitle
            } else if item.title == "USDC (ERC-20)" {
                cell.lblTitle.text = usdcErcTitle
            } else {
                cell.lblTitle.text = item.title
            }
            
            cell.lblTitle.textColor = UIColor.white
            
            if self.selectedFundTransferType == item {
                cell.vwDecorate.backgroundColor = Colors.collectionCurrentItemColor
            } else {
                cell.vwDecorate.backgroundColor = .clear
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.endEditing(true)
        
        if collectionView == self.collectionViewHistory {
            let selectedHistoryType = self.historyTypes[indexPath.item]
            selectedCellTab = indexPath.item
            self.onHistoryTypeChange?(selectedHistoryType)
        }
        else {
            let item = self.transferTypes[indexPath.item]
            self.selectedFundTransferType = item
            GlobalData.shared.selectedWithdrawalType = item
            self.collectionVW.reloadData()
            
            if self.selectedFundTransferType == .bankTransfer {
                //USDT ERC-20
                self.stackViewUSDTErcAddress.isHidden = true
                self.stackViewUSDTErcPhoto.isHidden = true
                
                //USDT TRC-20
                self.stackViewUSDTTrcAddress.isHidden = true
                self.stackViewUSDTTrcPhoto.isHidden = true
                
                //USDC ERC-20
                self.stackViewUSDCErcAddress.isHidden = true
                self.stackViewUSDCErcPhoto.isHidden = true
            }
            else if self.selectedFundTransferType == .usdtErc {
                //USDT ERC-20
                self.stackViewUSDTErcAddress.isHidden = false
                self.stackViewUSDTErcPhoto.isHidden = false
                
                //USDT TRC-20
                self.stackViewUSDTTrcAddress.isHidden = true
                self.stackViewUSDTTrcPhoto.isHidden = true
                
                //USDC ERC-20
                self.stackViewUSDCErcAddress.isHidden = true
                self.stackViewUSDCErcPhoto.isHidden = true
            }
            else if self.selectedFundTransferType == .usdtTrc {
                //USDT TRC-20
                self.stackViewUSDTTrcAddress.isHidden = false
                self.stackViewUSDTTrcPhoto.isHidden = false
                
                //USDT ERC-20
                self.stackViewUSDTErcAddress.isHidden = true
                self.stackViewUSDTErcPhoto.isHidden = true
                
                //USDC ERC-20
                self.stackViewUSDCErcAddress.isHidden = true
                self.stackViewUSDCErcPhoto.isHidden = true
            }
            else if self.selectedFundTransferType == .usdcErc {
                //USDT ERC-20
                self.stackViewUSDTErcAddress.isHidden = true
                self.stackViewUSDTErcPhoto.isHidden = true
                
                //USDT TRC-20
                self.stackViewUSDTTrcAddress.isHidden = true
                self.stackViewUSDTTrcPhoto.isHidden = true
                
                //USDC ERC-20
                self.stackViewUSDCErcAddress.isHidden = false
                self.stackViewUSDCErcPhoto.isHidden = false
            }
            
            self.localUSDTErcValue = self.txtUSDTErcAddress.text ?? ""
            self.localUSDTTrcValue = self.txtUSDTTrcAddress.text ?? ""
            self.localUSDCErcValue = self.txtUSDCErcAddress.text ?? ""
            self.onSecurityRadioButtonValueChange?()
        }
        
        self.collectionVW.reloadSections(IndexSet(integer: 0))
        self.collectionVW.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewHistory {
            let font = UIFont(name: Fonts.PoppinsMedium, size: 16)!
            let height = collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
            var width: CGFloat = 0
            let item = self.historyTypes[indexPath.item].title
            width = NSString(string: item).size(withAttributes: [NSAttributedString.Key.font : font]).width
            return CGSize(width: width + 32, height: height)
        }
        else {
            let item = self.transferTypes[indexPath.item]
            let label = UILabel(frame: CGRect.zero)
            label.text = item.title
            label.sizeToFit()
            return CGSize(width: label.frame.width + 50, height: 49)
        }
    }
}

//MARK:- UITextField Delegate
extension WithdrawalHeaderView: UITextFieldDelegate {
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

//MARK:- BioMetric Authentication
extension WithdrawalHeaderView {
    func authenticateBankTransferWithTouchID(amount: String, password: String, strAuthType: String) {
        GlobalData.shared.authenticateTouchIDGlobally { (success) in
            if success == true {
                self.onBankTransferTap?(amount, password, strAuthType)
            }
        }
    }
    
    func authenticateUSDTTransferWithTouchID(amount: String, password: String, strAuthType: String, usdtAddress: String, isUSDTErc: Bool, isUSDTTrc: Bool, isUSDCErc: Bool) {
        GlobalData.shared.authenticateTouchIDGlobally { (success) in
            if success == true {
                if isUSDTErc {
                    self.onUSDTErcTransferTap?(amount, password, strAuthType, usdtAddress)
                }
                else if isUSDTTrc {
                    self.onUSDTTrcTransferTap?(amount, password, strAuthType, usdtAddress)
                } else {
                    self.onUSDCErcTransferTap?(amount, password, strAuthType, usdtAddress)
                }
            }
        }
    }
}

class UnderlinedLabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
