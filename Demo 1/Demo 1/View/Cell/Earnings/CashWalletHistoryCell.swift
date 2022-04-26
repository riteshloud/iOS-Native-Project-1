//
//  CashWalletHistoryCell.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class CashWalletHistoryCell: UITableViewCell {

    @IBOutlet var cellBackViewTop: NSLayoutConstraint!
    @IBOutlet var cellBackView: UIView!
    @IBOutlet var cellBackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var cellInnerBackView: UIView!
    @IBOutlet weak var cellInnerViewBottom: NSLayoutConstraint!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var statusButton: UIButton!
    @IBOutlet var lblTicketName: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.statusButton.layer.cornerRadius = self.statusButton.frame.size.height/2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with history: CashWalletHistoryObject, indexPath: IndexPath, countOfArray: Int) {
        
        self.cellBackViewTop.constant = 0
        self.cellBackViewBottom.constant = 0
        self.cellInnerViewBottom.constant = 0
        self.cellBackView.layer.cornerRadius = 0.0
        self.cellBackView.layer.maskedCorners = []
        self.cellInnerBackView.layer.cornerRadius = 0.0
        self.cellInnerBackView.layer.maskedCorners = []
        
        if indexPath.row == 0 {
            self.cellInnerBackView.layer.cornerRadius = 6.0
            self.cellInnerBackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        if indexPath.row == countOfArray - 1 {
            self.cellInnerViewBottom.constant = 35
            self.lblSeperator.isHidden = true
            
            self.cellBackView.layer.cornerRadius = 6.0
            self.cellBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            self.cellInnerBackView.layer.cornerRadius = 6.0
            self.cellInnerBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        else {
            self.lblSeperator.isHidden = false
        }
        
        if history.final_amount <= 0.0 {
            self.amountLabel.text = "$" + String(format: "%.2f", history.amount)
        } else {
            self.amountLabel.text = "$" + String(format: "%.2f ($%.2f)", history.final_amount, history.amount)
        }
        
        self.dateLabel.text = GlobalData.shared.fullStringDateToSmallStringDate(strDate: history.created_at)
        
        self.lblTicketName.text = history.description
        
        var statusString = String()
        let status = history.type
        /*
        switch status {
        case "0":
            statusString = "Reduced".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
        case "1":
            statusString = "Added".localized()
            self.statusButton.backgroundColor = Colors.approvedColor
        case "2":
            statusString = "Admin Added".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
        default: break
        }
        */
        
        self.lblRemark.text = history.remarks
        self.lblRemark.isHidden = true
        
        switch status {
        case "0":
            statusString = "Reduced".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
        case "2":
            statusString = "Pending".localized()
            self.statusButton.backgroundColor = Colors.pendingColor
        case "3":
            self.lblRemark.isHidden = false
            statusString = "Rejected".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
        case "4":
            statusString = "Admin Added".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
        default:
            statusString = "Added".localized()
            self.statusButton.backgroundColor = Colors.approvedColor
            break
        }
        self.statusButton.setTitle(statusString, for: [])
    }
    
    func configureStockTransferHistory(with history: StockWalletTransferHistoryObject, indexPath: IndexPath, countOfArray: Int) {
        self.cellBackViewTop.constant = 0
        self.cellBackViewBottom.constant = 0
        self.cellInnerViewBottom.constant = 0
        self.cellBackView.layer.cornerRadius = 0.0
        self.cellBackView.layer.maskedCorners = []
        self.cellInnerBackView.layer.cornerRadius = 0.0
        self.cellInnerBackView.layer.maskedCorners = []
        
        if indexPath.row == 0 {
            self.cellInnerBackView.layer.cornerRadius = 6.0
            self.cellInnerBackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        if indexPath.row == countOfArray - 1 {
            self.cellInnerViewBottom.constant = 35
            self.lblSeperator.isHidden = true
            
            self.cellBackView.layer.cornerRadius = 6.0
            self.cellBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            self.cellInnerBackView.layer.cornerRadius = 6.0
            self.cellInnerBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        else {
            self.lblSeperator.isHidden = false
        }
        
        self.amountLabel.text = "$" + String(format: "%.2f", history.amount)
//        self.dateLabel.text = GlobalData.shared.fullStringDateToSmallStringDate(strDate: history.created_at)
        self.dateLabel.text = history.created_at
        
        self.lblTicketName.text = history.description_stock
        
        var statusString = String()
        let status = history.type
        switch status {
        case "0":
            statusString = "Reduced".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
        case "1":
            statusString = "Added".localized()
            self.statusButton.backgroundColor = Colors.approvedColor
        case "2":
            statusString = "Admin Added".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
        default: break
        }
        self.statusButton.setTitle(statusString, for: [])
    }
    
}
