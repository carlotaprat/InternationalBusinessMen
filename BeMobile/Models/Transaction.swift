//
//  Transaction.swift
//  BeMobile
//
//  Created by Carlota Prat on 18/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation

class Transaction: Decodable {
    
    var sku: String
    var amount: Double
    var currency: String
    
    enum TransactionCodingKeys: String, CodingKey {
        case sku
        case amount
        case currency
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: TransactionCodingKeys.self)
        
        self.sku = try container.decode(String.self, forKey: .sku)
        self.currency = try container.decode(String.self, forKey: .currency)

        let amountString = try container.decode(String.self, forKey: .amount)
        self.amount = Double(amountString) ?? 0
      
    }
    
}
