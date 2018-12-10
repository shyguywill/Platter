//
//  RecipePageController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 08/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import WebKit

class RecipePageController: UIViewController {
    

    
    @IBOutlet var webView: WKWebView!
    
    var pageURL : String?
    
    var webview: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentBlock()
        
        if let loadURL = pageURL{
            
            let url = URL(string: loadURL)
            
            let request = URLRequest(url: url!)
            
            webView.load(request)
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
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

   




