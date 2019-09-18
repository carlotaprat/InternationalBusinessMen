//
//  Sale.swift
//  BeMobile
//
//  Created by Carlota Prat on 18/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation

class Sale {
    
    var sku: String = ""
    var amount: Double = 0
    var transactions: [Transaction] = []
    
    init(sku: String, amount: Double) {
        self.sku = sku
        self.amount = amount
    }
    
}
