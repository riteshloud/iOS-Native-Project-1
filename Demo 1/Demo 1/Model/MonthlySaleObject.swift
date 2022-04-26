//
//  MonthlySaleObject.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class MonthlySaleObject: NSObject {
    var date: String        = ""
    var group_sales: Double = 0.0
    
    init(_ dictionary: [String: Any]) {
        self.date           = dictionary["date"] as? String ?? ""
        self.group_sales    = dictionary["group_sales"] as? Double ?? 0.0
    }
}
