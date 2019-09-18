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
    
    var mySales: [Sale] = []
    var myRates: [Rate] = []
    
    var pickerData: [String] = ["Loading"]
    
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
            
            self.mySales = self.viewModel.newSale(sales: &self.mySales, newTransaction: transaction, rates: self.myRates)
            print("coucou")
            
        }, onError: { (error) in

            print(error)
 
        }, onCompleted: {
            
            //selfloadPicker()
            
            self.productPicker.reloadAllComponents()
            print(self.mySales)
            
        }).disposed(by: disposeBag)
        
    }
    
    func loadRates() {
        
        let rates = viewModel.getRates()
        
        rates.subscribe(onNext: { (rate) in
            
            self.myRates.append(rate)
            
        }, onError: { (error) in
            
            print(error)
            
        }, onCompleted: {
            
            self.myRates = self.viewModel.calculateRates(rates: self.myRates)
            self.loadProducts()
            
        }).disposed(by: disposeBag)
        

        
    }
    
    func loadPicker() {
        
        // self.productPicker.dataSource = self.mySales.map({$0.sku})

    }

}

extension TradesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.mySales.isEmpty {
            return 1
        } else {
            return self.mySales.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if self.mySales.isEmpty {
            return "Loading"
        } else {
            return self.mySales[row].sku ?? ""
        }
    }
    
}
