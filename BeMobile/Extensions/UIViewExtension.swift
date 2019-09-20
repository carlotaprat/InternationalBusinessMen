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
        
        self.layer.shadowColor = UIColor.DeepPurple.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: -5)
        self.layer.shadowRadius = 5
        
        
    }
}
