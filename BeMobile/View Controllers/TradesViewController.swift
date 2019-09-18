//
//  ViewController.swift
//  BeMobile
//
//  Created by Carlota Prat on 18/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import UIKit
import RxSwift

class TradesViewController: UIViewController {

    @IBOutlet weak var productPicker: UIPickerView!
    @IBOutlet weak var amountLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var viewModel = TradesViewModel()
    
    var myTransactions: [Transaction] = []
    var myRates: [Rate] = []
    
    var pickerData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productPicker.delegate = self
        self.productPicker.dataSource = self
        
        //loadProducts()
        
        loadRates()
    }

    
    func loadProducts() {
        
        let transactions = viewModel.getTransactions()
        
        transactions.subscribe(onNext: { (transaction) in
            
            self.myTransactions.append(transaction)
            
            // FER ALGO AMB INTERFAÇ, o guardarme el producte...
            
        }, onError: { (error) in
            
            print(error)
 
        }, onCompleted: {
            
            // CRIDAR
            
        }).disposed(by: disposeBag)
        
    }
    
    func loadRates() {
        
        let rates = viewModel.getRates()
        
        rates.subscribe(onNext: { (rate) in
            
            self.myRates.append(rate)
            //self.viewModel.addRate(rate: rate)
            
        }, onError: { (error) in
            
            print(error)
            
        }, onCompleted: {
            
            // CRIDAR
            self.viewModel.calculateRates(rates: self.myRates)
           // self.viewModel.calc(directRates: &<#T##[Rate]#>, indirectRates: &<#T##[Rate]#>)
            //self.viewModel.calculateRates(rates: self.myRates)
            print(self.myRates)
            
        }).disposed(by: disposeBag)
        

        
    }
    
    func loadPicker() {
        
        var sales = viewModel.calculateTrades(transactions: myTransactions, rates: myRates)
        
        //pickerData.map{sales.name}

    }

}

extension TradesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    
}
