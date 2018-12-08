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
    

    @IBOutlet weak var recipeWebPage: WKWebView!
    
    var pageURL : String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadURL = pageURL{
            
            let url = URL(string: loadURL)
            
            let request = URLRequest(url: url!)
            
            recipeWebPage.load(request)
            
        }
    
        
        
        
        

        // Do any additional setup after loading the view.
    }
    

   

}
