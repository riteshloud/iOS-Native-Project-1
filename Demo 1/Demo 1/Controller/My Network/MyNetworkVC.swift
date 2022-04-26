//
//  MyNetworkVC.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MyNetworkVC: UIViewController {
    
    @IBOutlet weak var collectionVW: UICollectionView!
    
    var sponsor_id: String = ""
    var name = String()
    
    private var requestStatus: REQUEST = .notStarted
    private var searchRequestStatus: REQUEST = .notStarted
    
    var userName: String = ""
    private var OFFSET: Int = 0
    private var PAGING_LIMIT: Int = 500
    
    private var ROW_HEIGHT: CGFloat = 137
    private var LEADING_CONSTRAINT: CGFloat = 15.0
    private var TRAILING_CONSTRAINT: CGFloat = 15.0
    
    private var currentSearchKeyword: String?
    
    var arrRankList: [MyNetowrkRankObject] = []
    var arrUserList: [MyNetowrkUserObject] = []
    
    var isBackAllowed: Bool = false
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet var treeView: CITreeView!

    @IBOutlet var treeViewHeight: NSLayoutConstraint!
    @IBOutlet var treeViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var vwSearchBG: UIView!
    var userTreeArr: [AnyObject] = []
    
    var maxLevel: Int = 0
    
    var count = 0
    
    var noOfCells = 0
    
    //Search
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var vwOverlay: UIView!
    var isExpandedAll: Bool = false
    
    var seachedSelectedIndex:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchView()
        userName = self.name
        let nibCol = UINib(nibName: "NetworkTreeRankCell", bundle: nil)
        self.collectionVW.register(nibCol, forCellWithReuseIdentifier: "NetworkTreeRankCell")
        
        self.vwOverlay.isHidden = false
        GlobalData.showDefaultProgress()
        self.perform(#selector(self.getMyNetwork), with: nil, afterDelay: 0.5)
        self.treeView.contentInset.bottom = 15
        DispatchQueue.main.async() {
            self.vwSearchBG.roundCorners(corners: [.topLeft, .topRight], radius: 4.0)
            self.collectionVW.reloadData()
        }
        self.lblNoData.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Setup NavigationBar
    func setupNavigationBar()  {
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.clipsToBounds = true
        
        let btnMenu = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        if self.isBackAllowed == false {
            btnMenu.setImage(UIImage(named: "ic_side_menu"), for: .normal)
        } else {
            btnMenu.setImage(UIImage(named: "ic_back_white"), for: .normal)
        }
        btnMenu.addTarget(self, action: #selector(self.leftMenuAction), for: .touchUpInside)
        let btnBarMenu = UIBarButtonItem(customView: btnMenu)
        let btnTitle = UIButton()
        btnTitle.setTitle("Network Tree".localized(), for: .normal)
        btnTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        btnTitle.titleLabel?.font = UIFont(name: Fonts.PoppinsMedium, size: 18)!
        btnTitle.titleLabel?.textColor = UIColor.white
        btnTitle.isUserInteractionEnabled = false
        let btnBarTitle = UIBarButtonItem(customView: btnTitle)
        navigationItem.leftBarButtonItems = [btnBarMenu, btnBarTitle]
    }
    
    func setupSearchView() {
        self.searchTextField.placeholder = "Search username".localized()
        self.searchTextField.placeHolderColor = .white
        self.searchTextField.tintColor = .white
        self.searchTextField.delegate = self
    }
    
    //MARK:- UIButton Action
    @IBAction func leftMenuAction() {
        self.view.endEditing(true)
        if self.isBackAllowed == false {
            self.sideMenuViewController?.presentLeftMenuViewController()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnExpandCollapseAllTapped() {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.isExpandedAll {
                self.isExpandedAll = false
                self.maxLevel = 0
//                self.noOfCells = 0
                self.treeView.collapseAllRows()
            } else {
                self.isExpandedAll = true
                self.treeView.expandAllRows()
            }
        }
    }
    
    private func callApiOnSearch() {
        self.view.endEditing(true)
        if !searchTextField.text!.isEmpty {
            self.currentSearchKeyword = searchTextField.text!
        } else {
            self.currentSearchKeyword = nil
        }
        self.OFFSET = 0
        self.PAGING_LIMIT = 500
        self.maxLevel = 0
        self.noOfCells = 0
        GlobalData.showDefaultProgress()
        self.treeView.contentOffset = .zero
        self.arrUserList.removeAll()
        self.userTreeArr.removeAll()
//        self.treeView.reloadData()
        self.getMyNetwork(keyword: !searchTextField.text!.isEmpty ? searchTextField.text! : nil)
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        if self.searchButton.isSelected {
            self.seachedSelectedIndex = -1
            self.searchTextField.text = ""
            self.searchButton.isSelected = false
            self.treeViewHeight.constant = 0
            self.callApiOnSearch()
        } else {
            if searchTextField.text!.isEmpty {
                self.view.endEditing(true)
                GlobalData.shared.showLightStyleToastMesage(message: "Please provide username!".localized())
            } else {
                self.searchButton.isSelected = true
                self.callApiOnSearch()
            }
            self.view.endEditing(true)
        }
    }
    
    //MARK:- Pagination
    private func nextPageForNetworkIfNeeded(at indexPath: IndexPath) {
        if self.arrUserList.count >= 500 {
            if indexPath.item == (self.arrUserList.count - 1) {
                var status: REQUEST = .notStarted
                
                if currentSearchKeyword != nil {
                    status = self.searchRequestStatus
                }
                else {
                    status = self.requestStatus
                }
                
                if status != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.arrUserList.count
                    self.PAGING_LIMIT = 500
                    GlobalData.showDefaultProgress()
                    self.getMyNetwork(keyword: !searchTextField.text!.isEmpty ? searchTextField.text! : nil)
                }
            }
        }
    }
}

// MARK: - API Calls
extension MyNetworkVC {
    @objc func getMyNetwork(keyword: String?) {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
            GlobalData.hideProgress()
            return
        }
        
        var params : [String:Any] = [:]
        params["sponsor_id"] = self.sponsor_id
        params["offset"] = self.OFFSET
        params["limit"] = self.PAGING_LIMIT
        
        if let keyword = keyword {
            self.searchRequestStatus = REQUEST.started
            params["keyword"] = keyword
        }
        else {
            self.requestStatus = REQUEST.started
        }
        
        let strParam = GlobalData.shared.convertParameter(inJSONString: params)
        debugPrint(strParam)
        
        GlobalData.showDefaultProgress()
        
        AFWrapper.requestPOSTURL(BASE_URL + URLS.GET_MYNETWORK, params: params as [String : AnyObject], headers: nil, success: {
            (JSONResponse) -> Void in
            
//            GlobalData.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if keyword != nil {
                            self.searchRequestStatus = REQUEST.notStarted
                        }
                        else {
                            self.requestStatus = REQUEST.notStarted
                        }
                        
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let users = payload["rank_detail"] as? [Dictionary<String, Any>] {
                                self.arrRankList.removeAll()

                                for i in 0..<users.count  {
                                    let objNetworkUser = MyNetowrkRankObject.init(users[i])
                                    self.arrRankList.append(objNetworkUser)
                                }
                                
                                self.collectionVW.reloadData()
                            }
                            
                            if let users = payload["user_detail"] as? [Dictionary<String, Any>] {
                                if keyword != nil && self.OFFSET == 0 {
                                    self.arrUserList.removeAll()
                                    self.userTreeArr.removeAll()
                                }
                                
                                for i in 0..<users.count  {
                                    let objNetworkUser = MyNetowrkUserObject.init(users[i])
                                    self.arrUserList.append(objNetworkUser)
                                    self.userTreeArr.append(users[i] as AnyObject)
                                }
                                
                                if self.PAGING_LIMIT == 500 {
                                    if users.count < self.PAGING_LIMIT {
                                        if keyword != nil {
                                            self.searchRequestStatus = REQUEST.failedORNoMoreData
                                        }
                                        else {
                                            self.requestStatus = REQUEST.failedORNoMoreData
                                        }
                                    }
                                }
                            }
                            
                            if self.arrUserList.count > 0 {
                                self.lblNoData.isHidden = true
                            } else {
                                self.lblNoData.isHidden = false
                            }
                            self.treeView.isHidden = false
                            
                            self.treeView.collapseNoneSelectedRows = true
                            self.treeView.register(UINib(nibName: "CITreeViewCell", bundle: nil), forCellReuseIdentifier: "treeViewCell")
                            self.treeView.reloadData()
                            
                            self.vwOverlay.isHidden = true
                            
                            if keyword != nil {
                                self.isExpandedAll = true
                                self.treeView.expandAllRows()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    let indexPath = IndexPath(row: self.seachedSelectedIndex, section: 0)
                                    let rectOfCellInTableView = self.treeView.rectForRow(at: indexPath)
                                    let rectOfCellInSuperview = self.treeView.convert(rectOfCellInTableView, to: self.treeView.superview)
                                                                        
                                    //SCROLL WITH ANIMATION
                                    DispatchQueue.main.async {
                                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                                             self.scrollView.contentOffset = CGPoint.init(x: 0, y: rectOfCellInSuperview.origin.y)
                                        }) { (success) in
                                            GlobalData.hideProgress()
                                        }
                                    }
                                }
                            } else {
                                GlobalData.hideProgress()
                            }
                        }
                    }
                    else if response["code"] as! Int == 301 {
                        GlobalData.hideProgress()

                        if keyword != nil {
                            self.searchRequestStatus = REQUEST.failedORNoMoreData
                        }
                        else {
                            self.requestStatus = REQUEST.failedORNoMoreData
                        }
                        
                        GlobalData.shared.showInvalidToken(message: response["message"] as! String)
                    }
                    else {
                        GlobalData.hideProgress()

                        if keyword != nil {
                            self.searchRequestStatus = REQUEST.failedORNoMoreData
                        }
                        else {
                            self.requestStatus = REQUEST.failedORNoMoreData
                        }
                        GlobalData.shared.showLightStyleToastMesage(message: response["message"] as! String)
                    }
                }
            }
        }) { (error) in
            GlobalData.hideProgress()
            if keyword != nil {
                self.searchRequestStatus = REQUEST.failedORNoMoreData
            }
            else {
                self.requestStatus = REQUEST.failedORNoMoreData
            }
            GlobalData.shared.showLightStyleToastMesage(message:NETWORK_ERROR)
        }
    }
    
    @objc func showUserDetail(sender:UIButton!) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.showLightStyleToastMesage(message:INTERNET_UNAVAILABLE)
            return
        }
        
        var params : [String:Any] = [:]
        params["sponsor_id"] = "\(sender.tag)"
        
        GlobalData.showDefaultProgress()
        
        AFWrapper.requestPOSTURL(BASE_URL + URLS.GET_GROUP_SALES, params: params as [String : AnyObject], headers: nil, success: {
            (JSONResponse) -> Void in
            
            GlobalData.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        var arrSalesData = [MonthlySaleObject]()
                        if let payload = response["payload"] as? Dictionary<String,Any> {
                            if let salesData = payload["group_sales"] as? [Dictionary<String,Any>] {
                                for i in 0..<salesData.count  {
                                    let objMonthlySale = MonthlySaleObject.init(salesData[i])
                                    arrSalesData.append(objMonthlySale)
                                }
                            }
                        }
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
            GlobalData.shared.showLightStyleToastMesage(message:NETWORK_ERROR)
        }
    }
}

//MARK:- UICollectionView Delegate & DataSource
extension MyNetworkVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrRankList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkTreeRankCell", for: indexPath) as! NetworkTreeRankCell
        
        
        cell.imgViewRank.sd_setImage(with: URL.init(string: self.arrRankList[indexPath.row].icon), completed: nil)
        cell.lblName.text = self.arrRankList[indexPath.row].name
        cell.lblName.textColor = UIColor.white
        
        cell.vwDecorate.backgroundColor = .clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        return
    }
}

// MARK: - CITreeViewDelegate -
extension MyNetworkVC: CITreeViewDelegate {
    
    func willExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
        debugPrint(#function)
        if let cellExpanded = treeView.cellForRow(at: atIndexPath) as? CITreeViewCell {
            cellExpanded.imgViewExpandCollapse.image = #imageLiteral(resourceName: "ic_collapse")
        }
    }
    
    func didExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
        debugPrint(#function)
    }
    
    func willCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
        debugPrint(#function)
        if let cellExpanded = treeView.cellForRow(at: atIndexPath) as? CITreeViewCell {
            cellExpanded.imgViewExpandCollapse.image = #imageLiteral(resourceName: "ic_expand")
        }
        self.maxLevel = treeViewNode.level
    }
    
    func didCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
        debugPrint(#function)
        let totalWidth = (LEADING_CONSTRAINT * CGFloat(self.maxLevel + 1)) + (ScreenSize.SCREEN_WIDTH - (2 * (LEADING_CONSTRAINT + TRAILING_CONSTRAINT)))//(ROW_HEIGHT * CGFloat(self.maxLevel + 1)) + 200
        self.treeViewWidth.constant = totalWidth < (ScreenSize.SCREEN_WIDTH - (LEADING_CONSTRAINT + TRAILING_CONSTRAINT)) ? (ScreenSize.SCREEN_WIDTH - (LEADING_CONSTRAINT + TRAILING_CONSTRAINT)) : totalWidth
//        debugPrint("self.treeViewWidth.constant: \(self.treeViewWidth.constant)")
    }
    
    func treeView(_ treeView: CITreeView, heightForRowAt indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> CGFloat {
        return ROW_HEIGHT
    }
    
    func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
        debugPrint(#function)
    }
    
    func treeView(_ treeView: CITreeView, didSelectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
        debugPrint(#function)
        self.view.endEditing(true)
    }
    
    func treeViewNoOfNodes(intNoOfNodes: Int) {
        debugPrint(#function)
        self.noOfCells = intNoOfNodes
        self.treeViewHeight.constant = CGFloat(CGFloat(self.noOfCells) * ROW_HEIGHT)
    }
}

// MARK: - CITreeViewDataSource -
extension MyNetworkVC: CITreeViewDataSource {
    
    func treeViewSelectedNodeChildren(for treeViewNodeItem: AnyObject) -> [AnyObject] {
        var countObj = [AnyObject]()
        if let dataObj = treeViewNodeItem as? [String:Any] {
            if let childObj = dataObj["child"] as? [AnyObject] {
                countObj = childObj
            }
        }
        return countObj
    }
    
    func treeViewDataArray() -> [AnyObject] {
        return self.userTreeArr
    }
    
    func treeView(_ treeView: CITreeView, atIndexPath indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> UITableViewCell {
        let cell = treeView.dequeueReusableCell(withIdentifier: "treeViewCell") as! CITreeViewCell
        var objData: MyNetworkUserDetail = MyNetworkUserDetail.init([:])
        if let dictObj = treeViewNode.item as? [String:Any] {
            objData = MyNetworkUserDetail.init(dictObj)
        }
        
        cell.imgViewExpandCollapse.isHidden = false
        
        self.count = 1
        self.getChildCount(arr: objData.child)
        
        if indexPath.row == self.userTreeArr.count - 1 {
            cell.lblSeparator.isHidden = true
        } else {
            cell.lblSeparator.isHidden = false
        }
        
        if treeViewNode.level == 0 {
            if self.count > 1 {
                cell.imgViewExpandCollapse.isHidden = false
                cell.imgViewExpandCollapse.image = treeViewNode.expand ? #imageLiteral(resourceName: "ic_collapse") : #imageLiteral(resourceName: "ic_expand")
            } else {
                cell.imgViewExpandCollapse.isHidden = true
            }
            
            cell.lblTitle.textColor = Colors.labelShadowColor
        } else {
            
            let dataObjParent = treeViewNode.parentNode?.item as! [String:Any]
            let parentChildArr = dataObjParent["child"] as! [[String:Any]]
            let parentChildCount = parentChildArr.count
            
            if parentChildCount == 1 {
                if self.count == 1 {
                    cell.imgViewExpandCollapse.isHidden = true
                } else {
                    cell.imgViewExpandCollapse.isHidden = false
                    cell.imgViewExpandCollapse.image = treeViewNode.expand ? #imageLiteral(resourceName: "ic_collapse") : #imageLiteral(resourceName: "ic_expand")
                }
            } else {
                if self.count == 1 {
                    cell.imgViewExpandCollapse.isHidden = true
                } else {
                    cell.imgViewExpandCollapse.isHidden = false
                    cell.imgViewExpandCollapse.image = treeViewNode.expand ? #imageLiteral(resourceName: "ic_collapse") : #imageLiteral(resourceName: "ic_expand")
                }
            }
            
            cell.lblTitle.textColor = .white
        }
        
        let investmentAmount = "\(objData.stock_investment_amount)"
        print(investmentAmount)
        
        if objData.package_amount == 0 {
            let strPackageAmount = "No package".localized()
            
            if investmentAmount.isEmpty || investmentAmount == "0" || investmentAmount == "0.0" || investmentAmount == "0.00" {
                let strMt4UserId = !objData.mt4_user_id.isEmpty ? "(\(objData.mt4_user_id))" : ""
                cell.lblTitle.text = "\(objData.username) \(strMt4UserId)(\(GlobalData.shared.fullStringDateToSmallStringDate(strDate: objData.created_at))) [\(strPackageAmount)] \(objData.rank_detail.name)"
            } else {
                let strMt4UserId = !objData.mt4_user_id.isEmpty ? "(\(objData.mt4_user_id))" : ""
                cell.lblTitle.text = "\(objData.username) \(strMt4UserId)(\(GlobalData.shared.fullStringDateToSmallStringDate(strDate: objData.created_at))) [\(strPackageAmount)](\(investmentAmount)) \(objData.rank_detail.name)"
            }
        } else {
            if investmentAmount.isEmpty || investmentAmount == "0" || investmentAmount == "0.0" || investmentAmount == "0.00" {
                let strMt4UserId = !objData.mt4_user_id.isEmpty ? "(\(objData.mt4_user_id))" : ""
                cell.lblTitle.text = "\(objData.username) \(strMt4UserId)(\(GlobalData.shared.fullStringDateToSmallStringDate(strDate: objData.created_at))) [\(objData.package_amount)] \(objData.rank_detail.name)"
            } else {
                let strMt4UserId = !objData.mt4_user_id.isEmpty ? "(\(objData.mt4_user_id))" : ""
                cell.lblTitle.text = "\(objData.username) \(strMt4UserId)(\(GlobalData.shared.fullStringDateToSmallStringDate(strDate: objData.created_at))) [\(objData.package_amount)](\(investmentAmount)) \(objData.rank_detail.name)"
            }
        }
        if objData.username.lowercased().contains(self.searchTextField.text!.lowercased()) {
            cell.lblTitle.textColor = Colors.buttonRedColor
            
            if self.seachedSelectedIndex == -1 {
                self.seachedSelectedIndex = indexPath.row
            }
        }
        
        cell.lblTotalSales.text = "Total personal sales".localized() + ": "
        cell.lblTotalSalesValue.text = "$\(objData.total_dir_sales)"
        cell.lblTotalGroupSales.text = "Total group sales".localized() + ": ".localized()
        cell.lblTotalGroupSalesValue.text = "$\(objData.total_group_sales)"
        cell.lblMonthlyGroupSales.text = "Monthly group sales".localized() + "(\(GlobalData.shared.getMonthOnly(date: Date())))" + ": ".localized()
        cell.lblMonthlyGroupSalesValue.text = "$\(objData.month_group_sales)"
        
        cell.imgViewRank.sd_setImage(with: URL.init(string: objData.rank_detail.image_url), completed: nil)
        
        if treeViewNode.level > self.maxLevel {
            self.maxLevel = treeViewNode.level
        }
        
        let totalWidth = (LEADING_CONSTRAINT * CGFloat(self.maxLevel + 1)) + (ScreenSize.SCREEN_WIDTH - (2 * (LEADING_CONSTRAINT + TRAILING_CONSTRAINT)))//(ROW_HEIGHT * CGFloat(self.maxLevel + 1)) + 200
        self.treeViewWidth.constant = totalWidth < (ScreenSize.SCREEN_WIDTH - (LEADING_CONSTRAINT + TRAILING_CONSTRAINT)) ? (ScreenSize.SCREEN_WIDTH - (LEADING_CONSTRAINT + TRAILING_CONSTRAINT)) : totalWidth
        
        if treeViewNode.level == 0 {
            cell.leadingConstraint.constant = (LEADING_CONSTRAINT * CGFloat(treeViewNode.level + 1))
        } else {
            cell.leadingConstraint.constant = (LEADING_CONSTRAINT * CGFloat(treeViewNode.level + 1))
        }
        
        cell.viewHistoryButton.tag = objData.id
        cell.viewHistoryButton.addTarget(self, action: #selector(showUserDetail(sender:)), for: .touchUpInside)
        
        nextPageForNetworkIfNeeded(at: indexPath)
        
        return cell
    }
    
    func getChildCount(arr: [MyNetworkUserDetail]) {
        var i = 0
        while i < arr.count {
            let obj = arr[i]
            self.getChildCount(arr: obj.child)
            self.count = self.count + 1
            i = i + 1
        }
    }
}

//MARK:- UITextField Delegate
extension MyNetworkVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            self.view.endEditing(true)
            GlobalData.shared.showLightStyleToastMesage(message: "Please provide username!".localized())
        } else {
            self.callApiOnSearch()
            self.searchButton.isSelected = true
        }
        return true
    }
}
