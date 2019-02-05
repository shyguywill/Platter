//
//  StoreItemsViewCell.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 04/02/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import StoreKit

class StoreItemsViewCell: UITableViewCell{
    
    @IBOutlet weak var coinImage: UIImageView!
    
    @IBOutlet weak var packageDescription: UILabel!
    
    @IBOutlet weak var buyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func purchaseItem(_ sender: UIButton) {
        
        print(sender.tag)

        StoreViewController.purchaseIdentifier = sender.tag
        
        let payment = SKPayment(product: StoreViewController.product![sender.tag])
        SKPaymentQueue.default().add(payment)
        
        
    }
    
    
}



