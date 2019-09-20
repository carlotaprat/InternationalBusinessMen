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

    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var previousView: UIView!
    
    let productPicker = UIPickerView()
    
    var disposeBag = DisposeBag()
    var viewModel = TradesViewModel()
    
    var mySales: [Sale] = []
    var myRates: [Rate] = []
    
    var selectedSale: Sale?
    
    var pickerData: [String] = ["Loading"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        loadRates()
        
    }

    func setupView() {
        
        self.productPicker.delegate = self
        self.productPicker.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupPicker()
        textField.inputView = productPicker
        
        bottomView.setupBottom()
        
    }
    
    func loadTransactions() {
        
        let transactions = viewModel.getTransactions()
        // self.present(UIAlertController.genericError(), animated: true)

        transactions.subscribe(onNext: { (transaction) in
            
            self.mySales = self.viewModel.newSale(sales: &self.mySales, newTransaction: transaction, rates: self.myRates)
            
        }, onError: { (error) in

            self.present(UIAlertController.genericError(), animated: true)
 
        }, onCompleted: {
            
            self.pickerData = self.mySales.map({ (sale) -> String in
                sale.sku
            })
            
            self.productPicker.reloadAllComponents()
            
        }).disposed(by: disposeBag)
        
    }
    
    func loadRates() {
        
        let rates = viewModel.getRates()
        
        rates.subscribe(onNext: { (rate) in
            
            self.myRates.append(rate)
            
        }, onError: { (error) in
            
            self.present(UIAlertController.genericError(), animated: true)

        }, onCompleted: {
            
            self.myRates = self.viewModel.calculateRates(rates: self.myRates)
            self.loadTransactions()
            
        }).disposed(by: disposeBag)
        
    }
    
    func setupPicker() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        doneButton.tintColor = UIColor.DeepPurple
        cancelButton.tintColor = UIColor.DeepPurple
        
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
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "es_ES")
        
        if let priceString = currencyFormatter.string(from: selectedSale.amount as NSNumber) {
            amountLabel.text = priceString

        } else {
            amountLabel.text = String(selectedSale.amount)
            
        }
        
        self.selectedSale = selectedSale
        
        tableView.reloadData()
        self.saleView.alpha = 1
        self.previousView.alpha = 0

        
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
        
        cell.setupCell(transaction: ss.transactions[indexPath.row], eurTransaction: ss.eurTransactions[indexPath.row])
        
        return cell
        
    }
    
    
}
