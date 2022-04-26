//
//  UploadProofVC.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import SwiftyJSON

class UploadProofVC: UIViewController {
    
    enum PickerOption {
        case idProof
        case residentProof
        case bankProof
    }
    
    var messageDisplay: String = ""
    var uploadStatus: String = ""
    var proofStatus: String = ""
    
    var pickerOption: PickerOption?
    var idProofDocument: Document?
    var residentProofDocument: Document?
    var bankProofDocument: Document?

    @IBOutlet var messageView: UIView!
    @IBOutlet var personalDetailStackView: UIStackView!
    
    @IBOutlet var lblPersonalDetail: UILabel!
    @IBOutlet var lblMessage: UILabel!
    
    @IBOutlet var lblIdProof: UILabel!
    @IBOutlet var lblProofOfResidence: UILabel!
    @IBOutlet var lblBankAccountProof: UILabel!
    
    @IBOutlet var lblIdProofFile: UILabel!
    @IBOutlet var lblResidentProofFile: UILabel!
    @IBOutlet var lblBankProofFile: UILabel!
    
    @IBOutlet var btnChooseFile: [UIButton]!
    @IBOutlet var btnSubmitKYC: UIButton!
    
    var objWithdrawalWalletDetail: WithdrawalWalletDetailObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageDisplay = self.objWithdrawalWalletDetail.message_display
        self.proofStatus    = self.objWithdrawalWalletDetail.proof_status
        self.uploadStatus   = self.objWithdrawalWalletDetail.upload_status
        
        setupViews()
        self.setUpNavigationBar()
    }
    
    //MARK:- SetUp Navigation Bar
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.clipsToBounds = true
        
        let btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        btnBack.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        let btnBarMenu = UIBarButtonItem(customView: btnBack)
        let btnTitle = UIButton()
        btnTitle.setTitle("Upload Proofs".localized(), for: .normal)
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
    
    //MARK:- Set Default Values
    private func setupViews() {
        let messageCondition = self.messageDisplay.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        self.messageView.isHidden = messageCondition
        self.messageView.layer.cornerRadius = 8
        self.messageView.layer.masksToBounds = true
        
        if self.proofStatus == "0" && self.uploadStatus == "0" {
            self.messageView.backgroundColor = GlobalData.shared.hexStringToUIColor(hex: "#f2dede")
            self.lblMessage.textColor = GlobalData.shared.hexStringToUIColor(hex: "#a94543")
            
            self.personalDetailStackView.isHidden = false
        }
        else if self.proofStatus == "0" && self.uploadStatus == "1" {
            self.messageView.backgroundColor = GlobalData.shared.hexStringToUIColor(hex: "#fcf8e3")
            self.lblMessage.textColor = GlobalData.shared.hexStringToUIColor(hex: "#917647")
            
            self.personalDetailStackView.isHidden = true
        }
        
        self.lblMessage.text = self.messageDisplay
        self.lblPersonalDetail.text = "Personal Details".localized()
        self.lblIdProof.text = "ID proof (Identity Card/Passport):*".localized()
        self.lblProofOfResidence.text = "Proof of residence:*".localized()
        self.lblBankAccountProof.text = "Bank account proof:*".localized()
        
        [lblIdProofFile, lblResidentProofFile, lblBankProofFile].forEach {$0.text = "No file chosen".localized()}
        self.btnChooseFile.forEach({
            $0.setTitle("Choose file".localized(), for: [])
            $0.layer.cornerRadius = 4
        })
        
        self.btnSubmitKYC.setTitle("Submit KYC".localized(), for: [])
    }
    
    //MARK:- UIButton Action
    @IBAction func backAction() {
        self.view.endEditing(true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: selectDashboardOption), object: nil, userInfo: nil)
        
//        let controller = GlobalData.dashboardStoryBoard().instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    private func validate() -> [Document]? {
        guard let idProofDocument = self.idProofDocument else {
            GlobalData.shared.showLightStyleToastMesage(message: "Please provide id proof!".localized())
            return nil
        }
        guard let residentProofDocument = self.residentProofDocument else {
            GlobalData.shared.showLightStyleToastMesage(message: "Please provide residence proof!".localized())
            return nil
        }
        guard let bankProofDocument = self.bankProofDocument else {
            GlobalData.shared.showLightStyleToastMesage(message: "Please provide bank account proof!".localized())
            return nil
        }
        return [idProofDocument, residentProofDocument, bankProofDocument]
    }
    
    @IBAction func idProofChooseFileAction(_ sender: UIButton) {
        self.pickerOption = .idProof
        self.showMediaPickerOptions()
    }
    
    @IBAction func residentProofChooseFileAction(_ sender: UIButton) {
        self.pickerOption = .residentProof
        self.showMediaPickerOptions()
    }
    
    @IBAction func bankProofChooseFileAction(_ sender: UIButton) {
        self.pickerOption = .bankProof
        self.showMediaPickerOptions()
    }
    
    @IBAction func btnSubmitKYCTapped(_ sender: UIButton) {
        guard let documents = self.validate() else { return }
        self.submitKYC(documents: documents)
    }
    
    //MARK:- Update View
    private func updateViews() {
        if let idProofDocument = self.idProofDocument {
            self.lblIdProofFile.text = idProofDocument.name
        }
        if let residentProofDocument = self.residentProofDocument {
            self.lblResidentProofFile.text = residentProofDocument.name
        }
        if let bankProofDocument = self.bankProofDocument {
            self.lblBankProofFile.text = bankProofDocument.name
        }
    }
}

//MARK:- API Call
extension UploadProofVC {
    func submitKYC(documents: [Document]) {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            return
        }
        
        GlobalData.showDefaultProgress()
        AFWrapper.postWithUploadMultipleFiles(documents, strURL: BASE_URL + URLS.UPLOAD_USER_PROOF, params: nil, headers: nil, success: { (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String:Any] {
                    if response["code"] as! Int == 200 {
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            
                            if let proof_status = payload["proof_status"] as? String {
                                self.proofStatus = proof_status
                            }
                            
                            if let upload_status = payload["upload_status"] as? String {
                                self.uploadStatus = upload_status
                            }
                            
                            if let message_display = payload["message_display"] as? String {
                                self.messageDisplay = message_display
                            }
                        }
                        self.setupViews()
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

//MARK:- UIImagePickerController Delegate
extension UploadProofVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let pickerOption = self.pickerOption else { return }
        
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
        
        switch pickerOption {
        case .idProof:
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_idProofPhoto.jpg"
            let document = Document(
                uploadParameterKey: "id_proof",
                data: data,
                name: name ?? filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.idProofDocument = document
            self.updateViews()
            picker.dismiss(animated: true, completion: nil)
            break
        case .residentProof:
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_residentProofPhoto.jpg"
            let document = Document(
                uploadParameterKey: "proof_residence",
                data: data,
                name: name ?? filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.residentProofDocument = document
            self.updateViews()
            picker.dismiss(animated: true, completion: nil)
            break
        case .bankProof:
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_bankProofPhoto.jpg"
            let document = Document(
                uploadParameterKey: "bank_proof",
                data: data,
                name: name ?? filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.bankProofDocument = document
            self.updateViews()
            picker.dismiss(animated: true, completion: nil)
            break
        }
    }
}

//MARK:- Show Media Picker
extension UploadProofVC {
    func showMediaPickerOptions() {
        let fromCameraAction = UIAlertAction(title: "Capture photo from camera".localized(), style: .default) { (_) in
            self.pickerAction(sourceType: .camera)
        }
        
        let fromPhotoLibraryAction = UIAlertAction(title: "Select from photo library".localized(), style: .default) { (_) in
            self.pickerAction(sourceType: .photoLibrary)
        }
        
        let documentPickerAction = UIAlertAction(title: "Select from Documents".localized(), style: .default) { (_) in
            self.documentPickerAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(fromCameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(fromPhotoLibraryAction)
        }
        alert.addAction(cancelAction)
        alert.addAction(documentPickerAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickerAction(sourceType : UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            if sourceType == .camera {
                self.cameraAccessPermissionCheck(completion: { (success) in
                    if success {
                        self.present(picker, animated: true, completion: nil)
                    } else {
                        self.alertForPermissionChange(forFeature: "Camera".localized(), library: "Camera".localized(), action: "take")
                    }
                })
            }
            if sourceType == .photoLibrary {
                self.photosAccessPermissionCheck(completion: { (success) in
                    if success {
                        self.present(picker, animated: true, completion: nil)
                    } else {
                        self.alertForPermissionChange(forFeature: "Photos".localized(), library: "Photo Library".localized(), action: "select")
                    }
                })
            }
        }
    }
    
    func documentPickerAction() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func alertForPermissionChange(forFeature feature: String, library: String, action: String) {
        let settingsAction = UIAlertAction(title: "Open Settings".localized(), style: .default) { (_) in
            UIApplication.shared.openSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        
        // Please enable camera access from Settings > reiwa.com > Camera to take photos
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "App".localized()
        
        let title = "\"\(appName)\" " + "Would Like to Access the".localized() + " \(library)"
        let message = "Please enable".localized() + " \(library) " + "access from Settings".localized() + " > \(appName) > \(feature) " + "to".localized() + " \(action) " + "photos".localized()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func cameraAccessPermissionCheck(completion: @escaping (Bool) -> Void) {
        let cameraMediaType = AVMediaType.video
        let cameraAutherisationState = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAutherisationState {
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            AVCaptureDevice.requestAccess(for: cameraMediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            break
        }
    }
    
    func photosAccessPermissionCheck(completion: @escaping (Bool)->Void) {
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        switch photosStatus {
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        completion(true)
                    default:
                        completion(false)
                    }
                }
            })
        @unknown default:
            break
        }
    }
    
}

//MARK:- UIDocumentPicker Delegate
extension UploadProofVC: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        debugPrint("Canceled")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        defer { self.updateViews() }
        do {
            let data = try Data(contentsOf: url)
            let name = url.lastPathComponent
            
            switch pickerOption {
            case .idProof:
                let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_idProofPhoto.pdf"
                let document = Document(
                    uploadParameterKey: "id_proof",
                    data: data,
                    name: name,
                    fileName: filename,
                    mimeType: "application/pdf"
                )
                self.idProofDocument = document
                break
            case .residentProof:
                let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_residentProofPhoto.pdf"
                let document = Document(
                    uploadParameterKey: "proof_residence",
                    data: data,
                    name: name,
                    fileName: filename,
                    mimeType: "application/pdf"
                )
                self.residentProofDocument = document
                break
            case .bankProof:
                let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_bankProofPhoto.pdf"
                let document = Document(
                    uploadParameterKey: "bank_proof",
                    data: data,
                    name: name,
                    fileName: filename,
                    mimeType: "application/pdf"
                )
                self.bankProofDocument = document
                break
            case .none:
                break
            }

            
        } catch {
            debugPrint(error)
        }
    }
}
