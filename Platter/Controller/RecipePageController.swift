//
//  RecipePageController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 08/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import WebKit
import Floaty
import RealmSwift
import SVProgressHUD

class RecipePageController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    let floaty = Floaty()
    
    let realm = try! Realm()
    
    var mealDetails : Ingredients?
    var savedMealDetails : String?
    
    let meal = Meal()
    
    var identifier : Int?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentBlock()
        
        webView.navigationDelegate = self
        
        SVProgressHUD.show()
        
        switch identifier{
            
        case 0:
            
            //Load from ingredients page
            floatySetUp()
        
            if let loadURL = mealDetails?.meal_url{
            
                let url = URL(string: loadURL)
            
                let request = URLRequest(url: url!)
            
                webView.load(request)
            
            }
            
        case 1:
            
            //Load from saved meals page
            
            if let loadURL = savedMealDetails{
                
                let url = URL(string: loadURL)
                
                let request = URLRequest(url: url!)
                
                webView.load(request)
                
            }
            
        default:
            
            break
        }
      
    }
    
    //MARK: - Dismiss progressHUD
    
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss()
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        SVProgressHUD.dismiss()
    }
    
    
    //MARK: - Set up floating save meals button
    
    func floatySetUp() {
        
        floaty.buttonColor = UIColor(red: (50/255.0), green: (251/255.0), blue: (164/255.0), alpha: 1.0)
        
        floaty.addItem("Save Meal", icon: UIImage(named: "unliked")) { (likeButton) in
            
        
            if let details = self.mealDetails{
                
                
                if self.meal.saved == false{
                    
                    let meal = Meal()
                    
                    meal.meal_url = details.meal_url
                    meal.image_url = details.image_url
                    meal.title = details.label
                    meal.saved = !meal.saved
                    meal.publisher = details.source
                    self.meal.saved = !self.meal.saved
                    
                    
                    Platter.save(saveItem: meal)
                    
                    likeButton.icon = UIImage(named: "liked")
                    likeButton.title = "Saved"
                    //likeButton.isUserInteractionEnabled = false
                    
                    
                }else{
                        
                    let item = self.realm.objects(Meal.self)
                        
                    let meal = item[(item.count - 1)]
                        
                    Platter.delete(deleteItem: meal)
                    
                    
                    likeButton.icon = UIImage(named: "unliked")
                    likeButton.title = "Save Meal"
                    
                    
                    self.meal.saved = !self.meal.saved
                    
                }
                
            }
    
        }
        
        self.view.addSubview(floaty)
        
    }
    
    
    //MARK: - Set up content blocking 
    
    let json = """
[
    {
        "trigger": {
            "if-domain": ".*"
        },
        "action": {
            "type": "css-display-none",
            "selector": ".overlay"
        }
    },
    {
        "trigger": {
            "url-filter": "://googleads\\\\.g\\\\.doubleclick\\\\.net.*"
        },
        "action": {
            "type": "block"
        }
    }
]
"""
    
    
    
    
    func contentBlock() {
        
        WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "ContentBlockingRules",encodedContentRuleList: json)
            { (contentRuleList, error) in
                guard let contentRuleList = contentRuleList,
                    error == nil else {
                        return
                }
                
                let configuration = WKWebViewConfiguration()
                configuration.userContentController.add(contentRuleList)
                
                self.webView = WKWebView(frame: self.view.bounds,
                                         configuration: configuration)
            }
    
                
        }
    
    //MARK: - Done button
    
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "❤️", message: "Did you love it? Why not share it?", preferredStyle: .actionSheet)
        
        let firstOption = UIAlertAction(title: "Share on Facebook", style: .default) { (done) in
            
            let fbAlert = UIAlertController(title: nil, message: "This function will be built shortly", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Done", style: .default, handler: { (button) in
                self.navigationController?.popToRootViewController(animated: true)
                self.clean()
            })
            
            fbAlert.addAction(cancel)
            
            self.present(fbAlert, animated: true, completion: nil)
        }
        
        let secondOption = UIAlertAction(title: "Copy link", style: .default) { (done) in
            
            let fbAlert = UIAlertController(title: nil, message: "This function will be built shortly", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Done", style: .default, handler: { (button) in
                self.navigationController?.popToRootViewController(animated: true)
                self.clean()
            })
            
            fbAlert.addAction(cancel)
            
            self.present(fbAlert, animated: true, completion: nil)
        }
        
        let done = UIAlertAction(title: "No thanks", style: .default) { (done) in
            
            self.navigationController?.popToRootViewController(animated: true)
            self.clean()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        
        alert.addAction(firstOption)
        alert.addAction(secondOption)
        alert.addAction(done)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        
        //self.webView.reload()
        
        self.viewDidLoad()
        self.viewWillAppear(true)
        
    }
    
    //MARK: - Clear cookies and web data
    
    
    func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
    }
    
        
    }

   




