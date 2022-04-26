//
//  NoDataCell.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class NoDataCell: UITableViewCell {

    @IBOutlet var cellBackViewTop: NSLayoutConstraint!
    @IBOutlet var cellBackView: UIView!
    @IBOutlet var cellBackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var cellInnerBackView: UIView!
    @IBOutlet weak var cellInnerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblNoDataFound.text = "No data found".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure() {
        self.selectionStyle = .none
        self.cellInnerViewBottom.constant = 25.0
        
        self.cellBackView.layer.cornerRadius = 0.0
        self.cellBackView.layer.maskedCorners = []
        
        self.cellBackView.layer.cornerRadius = 6.0
        self.cellBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

    }
}
