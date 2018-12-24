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
import SVProgressHUD


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
        
        tableView.rowHeight = 130
        
        self.tableView.register(UINib(nibName: "CustomRecipes", bundle: nil), forCellReuseIdentifier: "CustomRecipesViewCell")
        
        SVProgressHUD.setBackgroundColor(UIColor(red: (50/255.0), green: (251/255.0), blue: (164/255.0), alpha: 0.5))
        SVProgressHUD.show()

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeBook.label.count

    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRecipesViewCell", for: indexPath) as? CustomRecipesViewCell else{ fatalError("Unexpected cell type")}
        
        if recipeBook.source[indexPath.row] != "Kitchen Daily"{
            
            let imageURL = recipeBook.image_url[indexPath.row]
            
            cell.mealName.text = recipeBook.label[indexPath.row]
            
            cell.mealImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "logo"))
            
            let ingredientArray = recipeBook.ingredient_arrays[indexPath.row]
            
            cell.ingredientCompleteness.text = "\(ingredientArray.difference()) ingredients needed"
            
            cell.publisherName.text = "Publisher: \(recipeBook.source[indexPath.row])"
            
        }
        
        return cell

    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ingredientBook.meal_url = recipeBook.meal_url[indexPath.row]
        
        ingredientBook.image_url = recipeBook.image_url[indexPath.row]
        
        ingredientBook.label = recipeBook.label[indexPath.row]
        
        ingredientBook.recipeList = recipeBook.ingredient_arrays[indexPath.row]
        
        ingredientBook.source = recipeBook.source[indexPath.row]
        
        
        performSegue(withIdentifier: "goToIngredientsPage", sender: self)

    }
    
    
    
    //MARK: - Networking + closure to obtain recipes
    
    
    func getRecipeData(url : String){
        
        var newArray = [[String]]()
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                print ("Success got the recipes!")
                let recipeJSON : JSON = JSON(response.result.value!)
                
                self.updateRecipeData(json: recipeJSON) { recipe in
                    
                    var array = [String]()
                    
                    if let ingredients = recipe ["ingredientLines"].array{
                        
                        for item in ingredients{
                            
                            array.append(item.stringValue)
                            
                        }
                        
                        newArray.append(array)
                        
                        self.recipeBook.ingredient_arrays = newArray
                        
                    }

                    
                }
                
                
                
                
            }else {
                
                print ("ERROR: \(String(describing:response.result.error))")
                
            }
            
        }
        
        
        
    }
    
    
    //MARK: - JSONParsing
    
    
    func updateRecipeData(json:JSON, closure:(JSON) -> ()) {
        
        //Handle data returned
        print ("Attempting to update")
        
        if let recipeData = json ["hits"].array {
            
            if recipeData.count != 0{
                
                var label = [String]()
                var image = [String]()
                var source = [String]()
                var url = [String]()
                
                
                print ("got the recipe data")
                
                for meal in 0 ..< recipeData.count{
                    
                    let food = recipeData[meal] ["recipe"]
                    
                    label.append(food ["label"].stringValue)
                    image.append(food ["image"].stringValue)
                    source.append(food ["source"].stringValue)
                    url.append(food ["url"].stringValue)
                    
                    
                    closure(food)
                
                }
                
                
                
                //print (label)
                
                recipeBook.label = label
                recipeBook.image_url = image
                recipeBook.source = source
                recipeBook.meal_url = url
                
            
            
        }

            tableView.reloadData()
            SVProgressHUD.dismiss()


        }else{
            
            print ("Could not create JSON")
            
        }
        

        
    }
    
    
//MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let url = delegateURL{
            
            ingredientBook.finalGetURL = url
        }
        
        
        if let destinationVC = segue.destination as? IngredientsViewController{
            
            destinationVC.delegateRecipe = ingredientBook
            
        }
        
    }
    


}


//MARK: - Create function to compare ingredients

extension Array where Element == String{
    
    func difference() -> Int {
        
        let thisArray = self.joined(separator: " ")
        
        var arrayCount = self.count
        
        let parameters = Search.searchParamters
            
        for item in parameters{
                
            if thisArray.contains(item){
                    
                arrayCount -= 1
                
            }
                
        }
        
        return arrayCount
        
    }
    
    
}
