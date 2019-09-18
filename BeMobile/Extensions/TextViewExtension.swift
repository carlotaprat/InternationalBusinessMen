//
//  TextViewExtension.swift
//  BeMobile
//
//  Created by Carlota Prat on 18/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setupBottom() {
        
        self.layer.shadowColor = #colorLiteral(red: 0.2032110674, green: 0.1601976473, blue: 0.2601841518, alpha: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: -5)
        self.layer.shadowRadius = 3
        
        
    }
}
