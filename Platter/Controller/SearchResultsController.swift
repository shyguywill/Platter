//
//  SearchResultsController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 05/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import RealmSwift

class SearchResultsController: UITableViewController {

    var delegateURL : String? {
        
        didSet{
            
            if let url = delegateURL {
                
                getRecipeData(url: url)
                
            }
            
        }
        
    }
    
    var recipeBook = Recipes()
    
    var foodArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CustomRecipes", bundle: nil), forCellReuseIdentifier: "CustomRecipesViewCell")

     
    }

    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
    
    
    
    
    //MARK: - Networking
    
    
    func getRecipeData(url : String){
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                print ("Success got the recipes!")
                let recipeJSON : JSON = JSON(response.result.value!)
                
                self.updaterecipedata(json: recipeJSON)
                
                
                
            }else {
                
                print ("ERROR: \(String(describing:response.result.error))")
                
            }
            
        }
        
        
        
    }
    
    
    //MARK: - JSONParsing
    
    
    func updaterecipedata(json:JSON) {
        
        //Handle data returned
        if let recipeData = json ["recipes"].array{
            
            for meal in 0 ... (recipeData.count - 1){
                
                let food = recipeData[meal]
                
                foodArray.append(food["title"].stringValue)
                recipeBook.recipeList.append(food["title"].stringValue)
                
            }
            
            print (recipeBook.recipeList)
            
            
            
            
        }
        
    }
    
    
    
    


}
