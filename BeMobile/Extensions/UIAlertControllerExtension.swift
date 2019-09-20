//
//  UIAlertError.swift
//  BeMobile
//
//  Created by Carlota Prat on 20/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func genericError() -> UIAlertController {
        
        let errorAlert = UIAlertController(title: NSLocalizedString("alert_title", comment: ""), message: NSLocalizedString("alert_body", comment: ""), preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("alert_done", comment: ""), style: .cancel, handler: nil)
        
        errorAlert.addAction(doneAction)
        errorAlert.view.tintColor = UIColor.DeepPurple
        
        return errorAlert
        
    }
    
}
