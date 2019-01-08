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
    @IBOutlet weak var tokenImg: UIBarButtonItem!
    @IBOutlet weak var tokenLabel: UIBarButtonItem!
    
    
    var delegateRecipe : Ingredients?
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientList.delegate = self
        ingredientList.dataSource = self
        tokenImg.image = UIImage(named: "PlatokenB")?.withRenderingMode(.alwaysOriginal)
        
        
        if let recipe = delegateRecipe{  //Load background image + set up button + nav title
            
            let url = URL(string: recipe.image_url)
            mealDisplay.kf.setImage(with: url)
            
            self.navigationItem.title = "\(recipe.label)"
            continueToRecipe.setTitle("Go to recipe on \(recipe.source)", for: .normal)
            continueToRecipe.titleLabel?.textAlignment = NSTextAlignment.center
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as? Double{
            
            tokenLabel.title = "\(Float(token))"

        }

    }
    
    //MARK: - TableView Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return delegateRecipe?.recipeList.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        
        cell.textLabel?.text = delegateRecipe?.recipeList[indexPath.row]
    
        cell.textLabel?.numberOfLines = 3
        
    
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
     //MARK: - Segue
    
    
    @IBAction func recipePageBtn(_ sender: UIButton) {
        
        guard Connectivity.isConnectedToInternet else {return Connectivity.handleNotConnected(view: self)}
        
        let token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Double
        
        if token > 0{
            
            performSegue(withIdentifier: "openRecipePage", sender: self)
            
        }else{
            
            let alert = UIAlertController(title: "Oh no", message: "You don't seem to have enough Platcoins to check out this recipe", preferredStyle: .alert)
            alert.view.tintColor = UIColor(red: 50/255, green: 251/255, blue: 164/255, alpha: 1.0)
            
            let action = UIAlertAction(title: "Got it", style: .cancel) { (cancel) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            print ("not enough tokens")
        }
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? RecipePageController{
            
            destinationVC.mealDetails = delegateRecipe
            destinationVC.identifier = 0
            
            print (destinationVC.mealDetails?.meal_url ?? "No sourceURL here")
        }
        
    }

}



