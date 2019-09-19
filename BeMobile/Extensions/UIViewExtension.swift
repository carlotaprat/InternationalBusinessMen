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
    
    func setupHeader() {
        

        let colorTop = UIColor(red:0.22, green:0.18, blue:0.46, alpha:1.0)
        let colorBottom = UIColor(red:0.18, green:0.22, blue:0.46, alpha:1.0)
        
        let gl = CAGradientLayer()
        gl.colors = [colorTop, colorBottom]
        gl.frame = self.bounds
        
        self.layer.insertSublayer(gl, at: 0)
        
    }
    
    func setupBottom() {
        
        self.layer.shadowColor = #colorLiteral(red: 0.1600870427, green: 0.05736182212, blue: 0.4068167098, alpha: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: -5)
        self.layer.shadowRadius = 3
        
        
    }
}
