//
//  DoubleExtension.swift
//  BeMobile
//
//  Created by Carlota Prat on 19/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation

extension Double {
    
    func bankersRounding() -> Double {
        
        var finalNumber: Double = 0.0

        let thirdDigit: Int = Int(self * 1000) % Int(self * 100)
        
        if thirdDigit == 5 {
            
            let secondDigit: Int = Int(self * 100) % Int(self * 10)
            
            if secondDigit % 2 == 0 {
                finalNumber = Double(Double(Int(self * 100)) / 100)
            } else {
                finalNumber = Double(Double(Int((self * 100) + 1)) / 100)
            }
            
        } else {
            
            finalNumber = (self * 100).rounded(.toNearestOrEven) / 100
            
        }
        
        return finalNumber

    }
    
}
