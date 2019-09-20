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
    
    let euro = NSLocalizedString("euro", comment: "")
    
    func getTransactions() -> Observable<Transaction> {
        
        return APIService().getTransactions()
        
    }
    
    func getRates() -> Observable<Rate> {
        
        return APIService().getRates()
        
    }
    
    func calculateRates(rates: [Rate]) -> [Rate] {
        
        var directRates = rates.filter{$0.to == euro}
        var indirectRates = rates.filter{$0.to != euro && $0.from != euro}
        return recursiveRates(directRates: &directRates, indirectRates: &indirectRates)

    }
    
    func recursiveRates(directRates: inout [Rate], indirectRates: inout [Rate]) -> [Rate] {
        
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
            
            return recursiveRates(directRates: &directRates, indirectRates: &indirectRates)
            
        }
        
    }
    
    func newSale(sales: inout [Sale], newTransaction: Transaction, rates: [Rate]) -> [Sale] {
        
        var conversion: Double = 1.0
        
        if newTransaction.currency != euro {
            conversion = rates.first(where: {$0.from == newTransaction.currency})?.rate ?? 0
            
        }
        
        let eurTransaction: Transaction = Transaction(sku: newTransaction.sku,
                                                      amount: (newTransaction.amount * conversion).bankersRounding(),
                                                      currency: euro)
        
        if let existingSale = sales.first(where: {$0.sku == newTransaction.sku}) {
            
            existingSale.transactions.append(newTransaction)
            existingSale.eurTransactions.append(eurTransaction)

            existingSale.amount = round(((newTransaction.amount * conversion).bankersRounding() + existingSale.amount) * 100)/100
            
        } else {
            
            let sale = Sale(sku: newTransaction.sku, amount: (newTransaction.amount * conversion).bankersRounding())
            sale.transactions.append(newTransaction)
            sale.eurTransactions.append(eurTransaction)
            sales.append(sale)
            
        }
        
        return sales
    }
    
}
