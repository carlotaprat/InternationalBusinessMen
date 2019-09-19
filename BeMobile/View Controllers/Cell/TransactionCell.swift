//
//  TransactionCell.swift
//  BeMobile
//
//  Created by Carlota Prat on 18/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var eurCurrencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var eurAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(transaction: Transaction, eurTransaction: Transaction) {
        
        amountLabel.text = String(transaction.amount)
        currencyLabel.text = transaction.currency
                
        eurAmountLabel.text = String(eurTransaction.amount)
        eurCurrencyLabel.text = String(eurTransaction.currency)
        
    }

}
