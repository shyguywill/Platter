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
import Kingfisher
import SVProgressHUD

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var continueToRecipe: UIButton!
    @IBOutlet weak var mealDisplay: UIImageView!
    @IBOutlet weak var ingredientList: UITableView!
    
    
    var delegateRecipe : Ingredients?
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientList.delegate = self
        ingredientList.dataSource = self
        
        
        
        
        
        if let recipe = delegateRecipe{  //Load background image + set up button + nav title
            
            let url = URL(string: recipe.image_url)
            mealDisplay.kf.setImage(with: url)
            
            self.navigationItem.title = "\(recipe.label)"
            continueToRecipe.setTitle("Continue to recipe on \(recipe.source)", for: .normal)
            
        }
        
        
    }
    
    //MARK: - TableView Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return delegateRecipe?.recipeList.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        
        cell.textLabel?.text = delegateRecipe?.recipeList[indexPath.row]
        
    
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

    
    //MARK: - Segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? RecipePageController{
            
            destinationVC.mealDetails = delegateRecipe
            destinationVC.identifier = 0
            
            print (destinationVC.mealDetails?.meal_url ?? "No sourceURL here")
        }
        
    }

}



