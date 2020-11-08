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


class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var continueToRecipe: UIButton!
    @IBOutlet weak var mealDisplay: UIImageView!
    @IBOutlet weak var ingredientList: UITableView!
    
    
    var delegateRecipe : Ingredients?
    var checked = [Bool]()
    
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientList.delegate = self
        ingredientList.dataSource = self
        

        if let recipe = delegateRecipe{  //Load background image + set up button + nav title
            
            let url = URL(string: recipe.image_url)
            mealDisplay.kf.setImage(with: url)
            
            self.navigationItem.title = "\(recipe.label)"
            continueToRecipe.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
//            continueToRecipe.setTitle("Open recipe on \(recipe.source)", for: .normal)
//            continueToRecipe.titleLabel?.textAlignment = NSTextAlignment.center
        }
        
        
    }
    
    
    //MARK: - TableView Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return delegateRecipe?.recipeList.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        
        cell.textLabel?.text = delegateRecipe?.recipeList[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        checked.append(false)
        
        if !checked[indexPath.row] {
            cell.accessoryType = .none
        } else if checked[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        
    
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Check if free user has enough coins to progress

    @IBAction func recipePageBtn(_ sender: UIButton) {
        
        guard Connectivity.isConnectedToInternet else {return Connectivity.handleNotConnected(view: self)}
        
        performSegue(withIdentifier: "openRecipePage", sender: self)
        
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



