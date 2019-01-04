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
    var sortParam : Int?
    var delegateURL : String? {
        
        didSet{
            
            if let url = delegateURL {
                
                getRecipeData(url: url)
                
                print ("got the url")
                
            }
            
        }
        
    }
    
    var recipeBook : [Recipes]? {   //MARK: - Sort and filter ingredients
        
        didSet{
            
            guard let refinedList = recipeBook else{return}
            
            let filteredRecipe = refinedList.filter {$0.source != "Kitchen Daily" && $0.source != "Kraft Foods"}
            
            print (sortParam ?? "No param")
            
            switch sortParam {
            case 1:
                let sortedRecipe = filteredRecipe.sorted(by: {$0.ingredient_arrays.difference() < $1.ingredient_arrays.difference()})
                recipeBook = sortedRecipe
                
            case 2:
                let sortedRecipe = filteredRecipe.sorted(by: {$0.calories < $1.calories})
                recipeBook = sortedRecipe
            
            default:
                break
            }

        }
        
    }
    
    
    var ingredientBook = Ingredients()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        
        self.tableView.register(UINib(nibName: "CustomRecipes", bundle: nil), forCellReuseIdentifier: "CustomRecipesViewCell")
        
        SVProgressHUD.setBackgroundColor(UIColor(red: (50/255.0), green: (251/255.0), blue: (164/255.0), alpha: 0.5))
        SVProgressHUD.setMaximumDismissTimeInterval(15.00)
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
            
            cell.ingredientCompleteness.textColor = ingredientsNeeded.textColour
            
            cell.publisherName.text = "Publisher: \(recipeArray[indexPath.row].source)"
            
            cell.calorieCount.text = "Calories per serving: \(recipeArray[indexPath.row].calories)"
            
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
                
                let yield = food ["yield"].intValue
                let totalCalories = food ["calories"].intValue
                
                recipes.calories = totalCalories/yield
                
                if let recipeLists = food ["ingredientLines"].array{
                    
                    for item in recipeLists{
                        
                        recipes.ingredient_arrays.append(item.stringValue)
                        
                    }
                    
                }
                
                
                recipeHold.append(recipes)
                
            }
                
                //print (label)
            
            
            sortParam = 1
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
    
    //MARK: - Sorting functions
    
    
    
    @IBAction func sortBtn(_ sender: UIBarButtonItem) {
        
        let sortAlert = UIAlertController(title: nil, message: "Sort recipes by:", preferredStyle: .actionSheet)
        
        
        let ingredientSort = UIAlertAction(title: "Ingredients needed (Default)", style: .default) { (action) in
            self.sortParam = 1
            
            self.recipeBook = self.recipeBook?.reversed()
            
            self.tableView.reloadData()
        }
        
        let calorieSort = UIAlertAction(title: "Calories", style: .default) { (action) in
            
            self.sortParam = 2
            
            self.recipeBook = self.recipeBook?.reversed()
            
            self.tableView.reloadData()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            sortAlert.dismiss(animated: true, completion: nil)
        }
        
        sortAlert.addAction(ingredientSort)
        sortAlert.addAction(calorieSort)
        sortAlert.addAction(cancel)
        
        present(sortAlert, animated: true, completion: nil)
        
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
