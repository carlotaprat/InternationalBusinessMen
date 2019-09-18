//
//  TradesViewModel.swift
//  BeMobile
//
//  Created by Carlota Prat on 18/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation
import RxSwift

struct TradesViewModel {
    
    func getTransactions() -> Observable<Transaction> {
        
        return APIService().getTransactions()
        
    }
    
    func calculateTrades(transactions: [Transaction], rates: [Rate]) -> [Sale] {
        
        return []
        
    }

    
}
