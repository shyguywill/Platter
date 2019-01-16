//
//  StoreViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 15/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var pageTitle: UILabel!
    
    @IBOutlet weak var platBtn1Title: UILabel!
    @IBOutlet weak var platBtn2Title: UILabel!
    @IBOutlet weak var platBtn3Title: UILabel!
    
    @IBOutlet weak var platBtn1: UIButton!
    @IBOutlet weak var platBtn2: UIButton!
    @IBOutlet weak var platBtn3: UIButton!
    
    
    var purchaseIdentifier : Int?
    var product : [SKProduct]?
    var productID : Set = ["com.theplatterapp.Platter.10Tokens","com.theplatterapp.Platter.30Tokens","com.theplatterapp.Platter.turnOffTokens"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        platBtn1.isEnabled = false
        platBtn2.isEnabled = false
        platBtn3.isEnabled = false
        
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
        


        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func purchase(_ sender: UIButton) {
        
        let buttonPressed = sender.tag
        purchaseIdentifier = buttonPressed
        
        let payment = SKPayment(product: product![(buttonPressed - 1)])
        SKPaymentQueue.default().add(payment)
        
        print (purchaseIdentifier ?? "no identifier")
        
    }
    

    
    func getPurchaseInfo() {
        
        if SKPaymentQueue.canMakePayments(){
            
            let request = SKProductsRequest(productIdentifiers: Set(self.productID))
            request.delegate = self
            request.start()
            
            
        }else{
            pageTitle.text = "Please enable in app Purchaces"
        }
        
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        if (products.count < 3) {
            
            pageTitle.text = "One or more products not found"
        
        }else{
            
            self.product = products
            
            platBtn1.isEnabled = true
            platBtn2.isEnabled = true
            platBtn3.isEnabled = true
            
         
            }
        
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids{
            
            print ("This product is invalid \(product)")
            
        }
        
        
    }
    
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            
            switch transaction.transactionState{
                
            case SKPaymentTransactionState.purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                pageTitle.text = "Thank you"
                
                switch self.purchaseIdentifier{
                    
                case 1:
                    
                    var token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Float
                    token += 10
                    UserDefaults.standard.set(token, forKey: Keys.tokenNumber)
                    
                case 2:
                    var token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Float
                    token += 30
                    UserDefaults.standard.set(token, forKey: Keys.tokenNumber)
                    
                case 3:
                    UserDefaults.standard.set(false, forKey: Keys.userStatus)
                    
                default:
                    break
                    
                }
                
              
                
                
                
                
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                pageTitle.text = "Unable to complete purchase"
                
                

            default:
                break
                
                
            }
            
        }
        
        
    }
    
  
    
    
    
    
    
    @IBAction func dismissScreen(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    


}
