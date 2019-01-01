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
    
    var recipeBook : [Recipes]? {
        
        didSet{
            
            if let refinedList = recipeBook{
                
                let sortedRecipe = refinedList.sorted(by: {$0.ingredient_arrays.difference() < $1.ingredient_arrays.difference()})
                
                let filteredRecipe = sortedRecipe.filter {$0.source != "Kitchen Daily" && $0.source != "Kraft Foods"}
                
                recipeBook = filteredRecipe
                
                //better place to call tableview reload?
                
            }
            
        }
        
    }
    
    
    var ingredientBook = Ingredients()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 130
        
        self.tableView.register(UINib(nibName: "CustomRecipes", bundle: nil), forCellReuseIdentifier: "CustomRecipesViewCell")
        
        SVProgressHUD.setBackgroundColor(UIColor(red: (50/255.0), green: (251/255.0), blue: (164/255.0), alpha: 0.5))
        SVProgressHUD.setMaximumDismissTimeInterval(30.0)
        SVProgressHUD.show()

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeBook?.count ?? 0
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRecipesViewCell", for: indexPath) as? CustomRecipesViewCell else{ fatalError("Unexpected cell type")}
        
        
        
        if let recipeArray = recipeBook{
            
            let imageURL = recipeArray[indexPath.row].image_url
            
            cell.mealName.text = recipeArray[indexPath.row].label
            
            cell.mealImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "logo"))
            
            //Create ingredients missing label
            
            let ingredientArray = recipeArray[indexPath.row].ingredient_arrays
            
            let ingredientsNeeded = MissingIngredientsLabel(numberMissing: ingredientArray.difference())
            
            cell.ingredientCompleteness.text = ingredientsNeeded.missingIngredientLabel
            
            cell.publisherName.text = "Publisher: \(recipeArray[indexPath.row].source)"
            
        }
        
        return cell

    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let recipeArray = recipeBook{
            
            ingredientBook.meal_url = recipeArray[indexPath.row].meal_url
            
            ingredientBook.image_url = recipeArray[indexPath.row].image_url
            
            ingredientBook.label = recipeArray[indexPath.row].label
            
            ingredientBook.recipeList = recipeArray[indexPath.row].ingredient_arrays
            
            ingredientBook.source = recipeArray[indexPath.row].source
            
        }
        
        performSegue(withIdentifier: "goToIngredientsPage", sender: self)

    }
    
    
    
    //MARK: - Networking + closure to obtain recipes
    
    
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
        
        let mealCount = json ["count"].intValue
        
        guard mealCount >= 3 else { //Make sure there are 3 or more recipes returned
            
            SVProgressHUD.dismiss()
            
            let alert = UIAlertController(title: "Uh oh", message: "Please try a different combination of, or less ingredients", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Got it", style: .default) { (cancel) in
                
                print ("Entered cancel closure")
                
                _ = self.navigationController?.popViewController(animated: true)
                
            }
            
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
            
            print ("No recipes found")
            
            return
        }
        
        if let recipeData = json ["hits"].array {
            
            
            var recipeHold = [Recipes]()
            
            print ("got the recipe data")
                
            for meal in 0 ..< recipeData.count{
                
                var recipes = Recipes()
                
                let food = recipeData[meal] ["recipe"]
                
                recipes.label = food ["label"].stringValue
                recipes.image_url = food ["image"].stringValue
                recipes.source = food ["source"].stringValue
                recipes.meal_url = food ["url"].stringValue
                
                if let recipeLists = food ["ingredientLines"].array{
                    
                    for item in recipeLists{
                        
                        recipes.ingredient_arrays.append(item.stringValue)
                        
                    }
                    
                }
                
                
                recipeHold.append(recipes)
                
            }
                
                //print (label)
            
            
            
            recipeBook = recipeHold
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
        
        
        var arrayCount = self.count
        
        let stringedArray = self.joined(separator: " ")
        
        let parameters = Search.searchParamters
            
        for item in parameters{
            
            if stringedArray.lowercased().contains(item.lowercased()){
                    
                arrayCount -= 1
                
                
            }
                
        }
        
        if arrayCount < 0 {
            
            arrayCount = 0
        }
        
        return arrayCount
        
    }
    
    
}
