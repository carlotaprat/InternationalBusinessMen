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
    
    let euro = "EUR"
    
    func getTransactions() -> Observable<Transaction> {
        
        return APIService().getTransactions()
        
    }
    
    func getRates() -> Observable<Rate> {
        
        return APIService().getRates()
        
    }
    
    func calculateRates(rates: [Rate]) {
        
        var directRates = rates.filter{$0.to == euro}
        var indirectRates = rates.filter{$0.to != euro && $0.from != euro}
        calc(directRates: &directRates, indirectRates: &indirectRates)

    }
    func calc(directRates: inout [Rate], indirectRates: inout [Rate]) -> [Rate] {
        
        if indirectRates.isEmpty {
            
            return directRates
            
        } else {
            
            indirectRates.forEach { (ir) in
                
                if directRates.contains(where: {$0.from == ir.to}) {
                    
                    if let dr = directRates.first(where: {$0.from == ir.to}) {
                        let rate = Rate(from: ir.from, to: dr.to, rate: dr.rate * ir.rate)
                        directRates.append(rate)
                    }
                }
            }
            indirectRates = indirectRates.filter { (ir) -> Bool in
                !directRates.contains(where: {$0.from == ir.to})
            }
            
            return calc(directRates: &directRates, indirectRates: &indirectRates)
            
        }
        
    }
    
    func calculateTrades(transactions: [Transaction], rates: [Rate]) -> [Sale] {
        
        return []
        
    }

    
}
