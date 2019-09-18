//
//  Rate.swift
//  BeMobile
//
//  Created by Carlota Prat on 18/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation

class Rate: Decodable {
    
    var from: String = ""
    var to: String = ""
    var rate: Double = 0.0
    
    enum RateCodingKeys: String, CodingKey {
        case from
        case to
        case rate
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: RateCodingKeys.self)
        
        self.from = try container.decode(String.self, forKey: .from)
        self.to = try container.decode(String.self, forKey: .to)
        
        let rateString = try container.decode(String.self, forKey: .rate)
        self.rate = Double(rateString) ?? 0
        
    }
}
