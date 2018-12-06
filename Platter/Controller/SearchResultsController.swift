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
                
                print ("got the url")
                
            }
            
        }
        
    }
    
    var recipeBook = Recipes()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        self.tableView.register(UINib(nibName: "CustomRecipes", bundle: nil), forCellReuseIdentifier: "CustomRecipesViewCell")

     
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeBook.title.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRecipesViewCell", for: indexPath) as? CustomRecipesViewCell else{ fatalError("Unexpected cell type")}
        
        let imageURL = recipeBook.image_url[indexPath.row]
        
        cell.mealName.text = recipeBook.title[indexPath.row]
        
        cell.mealImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "AppIcon"))
        
        return cell
        
        

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //next page

    }
    
    
    
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
            
            if recipeData.count != 0 {
                
                var publisher = [String]()
                var title = [String]()
                var source_url = [String]()
                var image_url = [String]()
                var recipe_id = [String]()
                var publisher_url = [String]()
                var social_rank = [Int]()
                
            
                for meal in 0 ... (recipeData.count - 1){
                    
                    let food = recipeData[meal]
                    
                    title.append(food["title"].stringValue)
                    publisher.append(food["publisher"].stringValue)
                    source_url.append(food["source_url"].stringValue)
                    image_url.append(food["image_url"].stringValue)
                    recipe_id.append(food["recipe_id"].stringValue)
                    publisher_url.append(food["publisher_url"].stringValue)
                    social_rank.append(food["social_rank"].intValue)
                    
                }
                
                //print (title)
                
                recipeBook.title = title
                recipeBook.image_url = image_url
                
                //fill in the rest later
                // recipeBook initialised because only 2 parameters are being used at the moment
                
                
                
            }
            
            tableView.reloadData()
                
                
            }
            

        
    }
    
    
    
    


}
