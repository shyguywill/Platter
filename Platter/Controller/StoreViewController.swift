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
    @IBOutlet weak var purchaseTableView: UITableView!
    
    
    static var purchaseIdentifier : Int?
    static var product : [SKProduct]?
    let productID : Set = ["com.theplatterapp.Platter.10Tokens","com.theplatterapp.Platter.30Tokens","com.theplatterapp.Platter.turnOffTokens"]
    let productList = ["Get 10 Platcoins","Get 30 Platcoins","Get Unlimited Platcoins"]
    let pictureList = ["PlatokenB","30Tokens","InfinitePlat"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageTitle.text = "Loading..."
        
        purchaseTableView.rowHeight = 100
        purchaseTableView.separatorStyle = .none
        
        purchaseTableView.delegate = self
        purchaseTableView.dataSource = self
        purchaseTableView.register(UINib(nibName: "CustomStore", bundle: nil), forCellReuseIdentifier: "CustomStoreViewCell")
        
        purchaseTableView.tableFooterView = UIView()
        purchaseTableView.allowsSelection = false
        
        
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
        


        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func restore(_ sender: UIButton) {
        
        print ("restoring")
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func getPurchaseInfo() {
        
        if SKPaymentQueue.canMakePayments(){
            
            let request = SKProductsRequest(productIdentifiers: Set(self.productID))
            request.delegate = self
            request.start()
            
            
        }else{
            pageTitle.text = "Enable in app Purchaces"
        }
        
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        if (products.count < 3) {
            
            pageTitle.text = "Products not found"
        
        }else{
            
            StoreViewController.product = products
            
            pageTitle.text = "Unlock Platcoins"
            purchaseTableView.reloadData()

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
                
                switch StoreViewController.purchaseIdentifier{
                    
                case 0:
                    
                    var token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Float
                    token += 10
                    UserDefaults.standard.set(token, forKey: Keys.tokenNumber)
                    
                case 1:
                    var token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Float
                    token += 30
                    UserDefaults.standard.set(token, forKey: Keys.tokenNumber)
                    
                case 2:
                    UserDefaults.standard.set(false, forKey: Keys.userStatus)
                    
                default:
                    break
                    
                }
                
            case SKPaymentTransactionState.restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                pageTitle.text = "Welcome back"
                
                UserDefaults.standard.set(false, forKey: Keys.userStatus)
                
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                pageTitle.text = "Purchase unfulfilled"
                
                

            default:
                break
                
                
            }
            
        }
        
        
    }
    
  
    
    
    
    
    
    @IBAction func dismissScreen(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    


}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStoreViewCell", for: indexPath) as? StoreItemsViewCell else {fatalError("Could not establish cell")}
        
        cell.coinImage.image = UIImage(named: pictureList[indexPath.section])
        cell.packageDescription.text = productList[indexPath.section]
        cell.buyBtn.tag = indexPath.section
        cell.buyBtn.isEnabled = false
        
        print ("Loading table")
        
        if let btnTitle = StoreViewController.product{
            cell.buyBtn.setTitle("\(btnTitle[indexPath.section].price)", for: .normal)
            cell.buyBtn.isEnabled = true
        }
        
            
        
        
        if indexPath.section == 0{
            
            cell.backgroundColor = UIColor(red: 37/255, green: 40/255, blue: 126/255, alpha: 1.0)
            cell.packageDescription.textColor = UIColor.white
        }else if indexPath.section == 1{
            
            cell.backgroundColor = UIColor.blue
            cell.packageDescription.textColor = UIColor.white
            
        }else{
            
            cell.backgroundColor = UIColor(red: 50/255, green: 251/255, blue: 164/255, alpha: 1.0)
            cell.buyBtn.layer.borderWidth = 0.1
            
        }
        
        cell.buyBtn.layer.cornerRadius = 8
        cell.buyBtn.clipsToBounds = true
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true

        
        
        return cell
        
    }
    
}



