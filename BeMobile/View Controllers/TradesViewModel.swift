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
    
    func calculateRates(rates: [Rate]) -> [Rate] {
        
        var directRates = rates.filter{$0.to == euro}
        var indirectRates = rates.filter{$0.to != euro && $0.from != euro}
        return calc(directRates: &directRates, indirectRates: &indirectRates)

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
    func newSale(sales: inout [Sale], newTransaction: Transaction, rates: [Rate]) -> [Sale] {
        
        var conversion: Double = 1.0
        
        if newTransaction.currency != euro {
            conversion = rates.first(where: {$0.from == newTransaction.currency})?.rate ?? 0
        }
        
        if let existingSale = sales.first(where: {$0.sku == newTransaction.sku}) {
            
            existingSale.transactions.append(newTransaction)
            existingSale.amount += newTransaction.amount * conversion
            
        } else {
            
            let sale = Sale(sku: newTransaction.sku, amount: newTransaction.amount * conversion)
            sale.transactions.append(newTransaction)
            sales.append(sale)
            
        }
        
        return sales
    }

    /*func newTransaction(transactions: inout [Transaction], newTransaction: Transaction, rates: [Rate]) -> [Transaction] {
        
        var conversion: Double = 1.0
        
        if newTransaction.currency != euro {
            conversion = rates.first(where: {$0.from == newTransaction.currency})?.rate ?? 0
        }
        
        if let existingTransaction = transactions.first(where: {$0.sku == newTransaction.sku}) {
            
            existingTransaction.amount += newTransaction.amount * conversion
            
        } else {
            
            newTransaction.
            transactions.append(<#T##newElement: Transaction##Transaction#>)
            
        }
        
    }*/
    
    func calculateTrades(transactions: [Transaction], rates: [Rate]) -> [Sale] {
        
        return []
        
    }

    
}
