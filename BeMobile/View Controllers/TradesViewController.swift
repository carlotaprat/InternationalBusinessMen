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

    @IBOutlet weak var textField: UITextField!
    // @IBOutlet weak var productPicker: UIPickerView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let productPicker = UIPickerView()
    
    var disposeBag = DisposeBag()
    var viewModel = TradesViewModel()
    
    var mySales: [Sale] = []
    var myRates: [Rate] = []
    
    var selectedSale: Sale?
    
    var pickerData: [String] = ["Loading"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productPicker.delegate = self
        self.productPicker.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")

        setupPicker()

        textField.inputView = productPicker
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
            
            self.pickerData = self.mySales.map({ (sale) -> String in
                sale.sku
            })
            
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
    
    func setupPicker() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        // toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar

    }
    
    @objc func donePicker() {
        textField.resignFirstResponder()
        let sku = pickerData[productPicker.selectedRow(inComponent: 0)]
        textField.text = sku
        
        guard let selectedSale = self.mySales.first(where: {$0.sku == sku}) else {
            return
        }
        
        productLabel.text = selectedSale.sku
        amountLabel.text = String(selectedSale.amount)
        
        self.selectedSale = selectedSale
        
        tableView.reloadData()
        
    }
    
    @objc func cancelPicker() {
        textField.resignFirstResponder()
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
            return self.mySales[row].sku
        }
    }
    
}

extension TradesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ss = selectedSale else {
            return 0
            
        }
        
        return ss.transactions.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        
        guard let ss = selectedSale else {
            return UITableViewCell()
        }
        
        cell.setupCell(transaction: ss.transactions[indexPath.row])
        
        return cell
        
    }
    
    
}
