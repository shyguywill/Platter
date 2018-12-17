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


class SearchResultsController: UITableViewController {
    
    let api = F2F_API()

    var delegateURL : String? {
        
        didSet{
            
            if let url = delegateURL {
                
                getRecipeData(url: url)
                
                print ("got the url")
                
            }
            
        }
        
    }
    
    var recipeBook = Recipes()
    var ingredientBook = Ingredients()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
        
        self.tableView.register(UINib(nibName: "CustomRecipes", bundle: nil), forCellReuseIdentifier: "CustomRecipesViewCell")

     
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeBook.label.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRecipesViewCell", for: indexPath) as? CustomRecipesViewCell else{ fatalError("Unexpected cell type")}
        
        let imageURL = recipeBook.image_url[indexPath.row]
        
        cell.mealName.text = recipeBook.label[indexPath.row]
        
        cell.mealImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "logo"))
        

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ingredientBook.recipe_id = recipeBook.recipe_ID[indexPath.row]
        
        ingredientBook.url = recipeBook.url[indexPath.row]
        
        print (ingredientBook.recipe_id)
        
        ingredientBook.image_url = recipeBook.image_url[indexPath.row]
        
        ingredientBook.label = recipeBook.label[indexPath.row]
        
        
        performSegue(withIdentifier: "goToIngredientsPage", sender: self)

    }
    
    
    
    //MARK: - Networking
    
    
    func getRecipeData(url : String){
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                print ("Success got the recipes!")
                let recipeJSON : JSON = JSON(response.result.value!)
                
                self.updateRecipeData(json: recipeJSON)
                
                
                
            }else {
                
                print ("ERROR: \(String(describing:response.result.error))")
                
            }
            
        }
        
        
        
    }
    
    
    //MARK: - JSONParsing
    
    
    func updateRecipeData(json:JSON) {
        
        //Handle data returned
        print ("Attempting to update")
        
        if let recipeData = json ["object"] ["hits"].array {
            
            if recipeData.count != 0{
                
                var label = [String]()
                var image = [String]()
                var source = [String]()
                var url = [String]()
                var recipe_num = [Int]()
                
                print ("got the recipe data")
                
                for meal in 0 ..< recipeData.count{
                    
                    let food = recipeData[meal] ["recipe"]
                    
                    print ("Created food")
                    
                    label.append(food ["label"].stringValue)
                    image.append(food ["image"].stringValue)
                    source.append(food ["source"].stringValue)
                    url.append(food ["url"].stringValue)
                    recipe_num.append(meal)
                    
            
                
                }
                
                print (label)
                
                recipeBook.label = label
                recipeBook.image_url = image
                recipeBook.source = source
                recipeBook.url = url
                recipeBook.recipe_ID = recipe_num
            
            
        }

            tableView.reloadData()


        }else{
            
            print ("Could not create JSON")
            
        }
        

        
    }
    
    
//MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destinationVC = segue.destination as? IngredientsViewController{
            
            destinationVC.delegateRecipe = ingredientBook
            
        }
        
    }
    


}
