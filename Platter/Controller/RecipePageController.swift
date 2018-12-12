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

class RecipePageController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    let floaty = Floaty()
    
    let realm = try! Realm()
    
    var mealDetails : Ingredients?
    
    let meal = Meal()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatySetUp()
    
        contentBlock()
        
        if let loadURL = mealDetails?.source_url{
            
            let url = URL(string: loadURL)
            
            let request = URLRequest(url: url!)
            
            webView.load(request)
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Set up floating save meals button
    
    func floatySetUp() {
        
        floaty.buttonColor = UIColor(red: (50/255.0), green: (251/255.0), blue: (164/255.0), alpha: 1.0)
        
        floaty.addItem("Save Meal", icon: UIImage(named: "unliked")) { (likeButton) in
            
        
            if let details = self.mealDetails{
                
                
                if self.meal.saved == false{
                    
                    let meal = Meal()
                    
                    meal.source_URL = details.source_url
                    meal.image_URL = details.image_url
                    meal.title = details.title
                    meal.saved = !meal.saved
                    self.meal.saved = !self.meal.saved
                    
                    
                    self.save(mealItem: meal)
                    
                    likeButton.icon = UIImage(named: "liked")
                    likeButton.title = "Saved"
                    //likeButton.isUserInteractionEnabled = false
                    
                    
                }else{
                        
                    let item = self.realm.objects(Meal.self)
                        
                    let meal = item[(item.count - 1)]
                        
                    self.deleteMeal(mealItem: meal)
                    
                    
                    likeButton.icon = UIImage(named: "unliked")
                    likeButton.title = "Save Meal"
                    
                    
                    self.meal.saved = !self.meal.saved
                    
                }
                
            }
    
        }
        
        self.view.addSubview(floaty)
        
    }
    
    
    //MARK: - Realm methods
    
    
    
    func save(mealItem: Meal){
        
        do{
            try realm.write {
                
                realm.add(mealItem)
            }
            
        }catch{
            
            print ("There was an error \(Error.self)")
            
        }
    }
    
    
     func deleteMeal(mealItem: Meal){
        
        do{
            try realm.write {
                
                realm.delete(mealItem)
            }
        }catch{
            print ("Could not delete item, ERROR, \(error)")
        }
        
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
    
    
    
    
    func contentBlock () {
        
        WKContentRuleListStore.default()
            .compileContentRuleList(forIdentifier: "ContentBlockingRules",
                                    encodedContentRuleList: json)
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
        
    }

   




