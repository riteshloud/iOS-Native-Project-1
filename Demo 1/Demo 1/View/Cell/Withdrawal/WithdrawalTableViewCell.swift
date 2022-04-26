//
//  WithdrawalTableViewCell.swift
//  OTM Trade
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class WithdrawalTableViewCell: UITableViewCell {

    @IBOutlet var cellBackViewTop: NSLayoutConstraint!
    @IBOutlet var cellBackView: UIView!
    @IBOutlet var cellBackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var cellInnerBackView: UIView!
    @IBOutlet weak var cellInnerViewBottom: NSLayoutConstraint!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var statusButton: UIButton!
    @IBOutlet var lblFees: UILabel!
    @IBOutlet var lblBank: UILabel!
    @IBOutlet weak var stackViewResendEmail: UIStackView!
    @IBOutlet var btnResendEmail: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with history: WithdrawalWalletHistoryObject, indexPath: IndexPath, countOfArray: Int) {
        
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
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatterGet.date(from: history.created_at)
        self.dateLabel.text = "\(dateFormatterPrint.string(from: date ?? Date()))"
        self.lblFees.text = "($\(String(format: "%.2f", history.withdrawal_fees)))"
        self.amountLabel.text = "$\(String(format: "%.2f", history.withdrawal_amount))"
        
        self.lblDescription.text = history.remarks
        if history.remarks.count <= 0 {
            self.lblDescription.isHidden = true
        }
        else {
            self.lblDescription.isHidden = false
        }
        
        var bankValue = String()
        if history.type == "0" {
            bankValue = "Bank".localized()
        }
        else if history.type == "1" {
            bankValue = "USDT(ERC)".localized()
        }
        else if history.type == "4" {
            bankValue = "USDT(TRC)".localized()
        }
        else if history.type == "5" {
            bankValue = "USDC (ERC-20)".localized()
        }
        self.lblBank.text = bankValue
        self.btnResendEmail.setTitle("Resend Email".localized(), for: .normal)
        
        var statusTitle = String()
        if history.status == 0 {
            statusTitle = "Pending".localized()
            self.statusButton.backgroundColor = Colors.pendingColor
            self.stackViewResendEmail.isHidden = true
        }
        else if history.status == 1 {
            statusTitle = "Approved".localized()
            self.statusButton.backgroundColor = Colors.approvedColor
            self.stackViewResendEmail.isHidden = true
        }
        else if history.status == 2 {
            statusTitle = "Rejected".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
            self.stackViewResendEmail.isHidden = true
        }
        else if history.status == 3 {
            statusTitle = "Verifying".localized()
            self.statusButton.backgroundColor = Colors.cellRedColor
            self.stackViewResendEmail.isHidden = false
        }

        self.statusButton.setTitle(statusTitle, for: .normal)
        
    }
}
