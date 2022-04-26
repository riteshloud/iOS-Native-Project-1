//
//  CITreeViewCell.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//


import UIKit

class CITreeViewCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTotalSales: UILabel!
    @IBOutlet var lblTotalSalesValue: UILabel!
    @IBOutlet var lblTotalGroupSalesValue: UILabel!
    @IBOutlet var lblTotalGroupSales: UILabel!
    @IBOutlet var lblMonthlyGroupSalesValue: UILabel!
    @IBOutlet var lblMonthlyGroupSales: UILabel!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var imgViewRank: UIImageView!
    @IBOutlet var imgViewExpandCollapse: UIImageView!
    @IBOutlet var viewHistoryButton: UIButton!
    @IBOutlet var lblSeparator: UILabel!
    @IBOutlet var lblViewHistory: UnderlinedLabel!
    @IBOutlet weak var cellInnerBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblViewHistory.text = "View History".localized()
    }
}
