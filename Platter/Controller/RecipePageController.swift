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
    
    var mealDetails : Ingredients? //Recipe details recieved from ingredient screen
    var savedMealDetails : String? //Recipe URL received from saved meals tab
    
    let meal = Meal()
    
    var identifier : Int? //Identifies if details are coming from recipe page or saved meals tab
    
    var viewIdentifier = 0 //Monitors how many times viewDidLoad for Floaty
    
    var pageIdentifier = 0 // Monitors how many times URL did load for first time navigation alert
    
    var FBShareMonitor = 0 // Monitors how many times share button has been pressed
    
    let userStatus = UserStatus()
    
    var fbShareLabl : String{
        
        var title = "Share on Facebook"
        
        if userStatus.isFreeUser(){
            
            title = "Share on Facebook (+0.20💰)"
        }
        
        return title
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewIdentifier += 1
        
        contentBlock()
        
        webView.navigationDelegate = self
        
        SVProgressHUD.show()
        
        switch identifier{
            
        case 0:
            //Load from ingredients page
            
            if viewIdentifier == 1{
                floatySetUp()
                
                if userStatus.isFreeUser(){ //*** Increase time to 30 ***
                    var _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(useToken), userInfo: nil, repeats: false)
                }
                
            }
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if self.isMovingFromParent{
            SVProgressHUD.dismiss()
            clean()
        }
        
    }
    
    //MARK: - Token Timer
    
    @objc func useToken() {
        
        if var token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as? Float{
            
            if token >= 1{
                
                token -= 1
                
                UserDefaults.standard.set(token, forKey: Keys.tokenNumber)
                
                print ("token used")
            }
                
                
            }
        
    }
    
    
    //MARK: - Dismiss progressHUD
    
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss()
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        pageIdentifier += 1
        
        if pageIdentifier == 2{
            firstLaunchNav()
        }
        
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
    
    //MARK: - Detect Navigation on first luanch
    
    func firstLaunchNav() {
        
        let firstTime = FirstLaunch(userDefaults: .standard, key: Keys.recipePage)
        
        if firstTime.isFirstLaunch{
            
            let alert = UIAlertController(title: "Recipe page", message: "Feel free to go wandering, when you do, just press the Return button (next to share) to get back your recipe.", preferredStyle: .alert)
            
            alert.view.tintColor = UIColor(red: 50/255, green: 251/255, blue: 164/255, alpha: 1.0)
            
            let action = UIAlertAction(title: "Got it", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    //MARK: - Set up content blocking 

    func contentBlock() {
        
        if let jsonFilePath = Bundle.main.path(forResource: "adaway.json", ofType: nil){
            
            WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "ContentBlockingRules", encodedContentRuleList: jsonFilePath)  { (contentRuleList, error) in
                    guard let contentRuleList = contentRuleList, error == nil else { return }
                    let configuration = WKWebViewConfiguration()
                    configuration.userContentController.add(contentRuleList)
                    
                    self.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
                }
            }
        }
    
    //MARK: - Share button
    
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "❤️", message: "Did you love it? Why not share it?", preferredStyle: .actionSheet)
        
        let facebook = UIAlertAction(title: fbShareLabl, style: .default) { (button) in
            
            guard self.FBShareMonitor == 0 else{return} //Free users can only share once
            
            if let sharedMeal = self.mealDetails{
                
                let content = FBSDKShareLinkContent()
                content.contentURL = URL(string: sharedMeal.meal_url)
                
                let hashtag = FBSDKHashtag()
                hashtag.stringRepresentation = "#Platter"
                
                content.hashtag = hashtag
                
                FBSDKShareDialog.show(from: self, with: content, delegate: nil)

            }
            
            if self.userStatus.isFreeUser(){
                self.FBShareMonitor = 1
                var token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Float
                token += 0.2
                UserDefaults.standard.set(token, forKey: Keys.tokenNumber)
                
            }
            self.clean()
            
        }
        
        let copyLink = UIAlertAction(title: "Copy link", style: .default) { (done) in
            
            if let sharedMeal = self.mealDetails{
                
                UIPasteboard.general.string = sharedMeal.meal_url
                
            }
            //Alert to confirm?
            self.clean()
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        
        alert.addAction(facebook)
        alert.addAction(copyLink)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Return button
    
    
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

   




