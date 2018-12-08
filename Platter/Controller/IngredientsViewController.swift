//
//  IngredientsViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 08/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var continueToRecipe: UIButton!
    @IBOutlet weak var mealDisplay: UIImageView!
    @IBOutlet weak var ingredientList: UITableView!
    
    var ingredientsArray = [String]()
    
    var delegateRecipe : Ingredients? {
        
        didSet{
            
            if let recipe = delegateRecipe{
                
                //mealDisplay.sd_setImage(with: URL(string: recipe.image_url), placeholderImage: UIImage(named: "logo"))
                
                getIngredientData(url: recipe.finalGetURL)
                
                
            
            }
            
            
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientList.delegate = self
        ingredientList.dataSource = self
        
    }
    
    //MARK: - TableView Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return ingredientsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        
        cell.textLabel?.text = ingredientsArray[indexPath.row]
        
    
        return cell
        
        
        
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    //MARK: - Networking
    
    func getIngredientData(url : String){
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                print ("Success got the recipes!")
                let ingredientJSON : JSON = JSON(response.result.value!)
                
                self.updateIngredientData(json: ingredientJSON)
                
               
                
                
                
            }else {
                
                print ("ERROR: \(String(describing:response.result.error))")
                
            }
            
        }
        
        
        
    }
    
    
    
    
    
    //MARK: - JSONParsing
    
    
    func updateIngredientData(json : JSON){
        
        if let ingredients = json ["recipe"] ["ingredients"].array{
            
            for item in 0 ... (ingredients.count - 1) {
                
                ingredientsArray.append(ingredients[item].stringValue)
                
            }
            
            ingredientList.reloadData()
            
        }
        
        
        
        
    }
    
    
    
    
    

    
    
    



}