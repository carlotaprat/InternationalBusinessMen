//
//  StringExtension.swift
//  BeMobile
//
//  Created by Carlota Prat on 20/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
