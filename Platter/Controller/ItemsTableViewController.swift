//
//  ItemsTableViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 04/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class ItemsTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var recipeItems : Results<FridgeStore>?
    let realm = try! Realm()
    let api = F2F_API()
    var searchParameters : String?
    var finalURL : String?
    
    
    @IBOutlet weak var fridgeTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fridgeTableView.dataSource = self
        fridgeTableView.delegate = self
        
        fridgeTableView.register(UINib(nibName: "CustomItems", bundle: nil), forCellReuseIdentifier: "CustomIngredientCell")
        
        loadIngredients()

    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeItems?.count ?? 1
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomIngredientCell", for: indexPath) as? CustomItemsViewCell
        else { fatalError("Uninteded Index Path")}

        if let fridge = recipeItems?[indexPath.row] {
            
            cell.ingredientName?.text = fridge.name
            cell.checkImage?.image = fridge.included ? UIImage(named: "greencheck"):UIImage(named: "nocheck")
            
        }
    
        return cell

    }
    
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do{
            
            try realm.write {
                if let item = recipeItems?[indexPath.row]{
                    
                    item.included = !item.included
                }
            }
        }catch {
            print ("Error encountered")
        }
        
        loadIngredients()
        
    }
    
    //MARK: - Realm methods
    
    
    func save(fridgeIngredient: FridgeStore){
        
        do{
            
            try realm.write {
                
                realm.add(fridgeIngredient)
            }
            
        }catch {
            
            print ("error, item could not be added")
        }
        
    }
    
    func loadIngredients() {
        
        recipeItems = realm.objects(FridgeStore.self)
        
        createParameterArray()
        
        createURL()
        
        fridgeTableView.reloadData()
        
        
    }
    
  
//MARK:- Add new items
    
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add a new item", message: "Add a new ingredient to your fridge", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let fridgeIngredient = FridgeStore()
            fridgeIngredient.name = textFeild.text!
            self.save(fridgeIngredient: fridgeIngredient)
            
            self.loadIngredients()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextFeild) in
            
            alertTextFeild.placeholder = "New ingredient"
            textFeild = alertTextFeild
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Create parameters
    
    func createParameterArray() {
        
        var recipeApiItems = [String]()
        
        if let fridge = recipeItems{
            
            for items in fridge{
                
                
                if items.included{
                    
                    let newItem = items.name
                    
                    recipeApiItems.append(newItem)
                    
                }
            
            }
            
            print (recipeApiItems.joined(separator: ","))
            searchParameters = recipeApiItems.joined(separator: ",")
            
        }else {
            
            print ("no search parameter present")
        }
        
    }
    
    func createURL() {
        
        if let ingredientsToSend = searchParameters{
            
            let newURL = api.baseURL + api.appKey + "&q=" + ingredientsToSend + "&sort=r"
            
            finalURL = newURL.replacingOccurrences(of: " ", with: "%20")
            
            print (finalURL ?? "Nothing to see")
            
        }
        
    }
    
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Call get recipe and pass in URL
        
        if let destinationVC = segue.destination as? SearchResultsController {
            
            destinationVC.delegateURL = finalURL
            
        }
        
    }
  

  

}
