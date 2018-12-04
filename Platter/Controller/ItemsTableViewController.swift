//
//  ItemsTableViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 04/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsTableViewController: UITableViewController {
    
    var recipeItems : Results<FridgeStore>?
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CustomItems", bundle: nil), forCellReuseIdentifier: "CustomIngredientCell")
        
        loadIngredients()

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomIngredientCell", for: indexPath) as? CustomItemsViewCell
        else { fatalError("Uninteded Index Path")}

        if let fridge = recipeItems?[indexPath.row] {
            
            cell.ingredientName?.text = fridge.name
            cell.checkImage?.image = fridge.included ? UIImage(named: "greencheck"):UIImage(named: "nocheck")
            
        }

        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do{
            
            try realm.write {
                if let item = recipeItems?[indexPath.row]{
                    
                    item.included = !item.included
                }
            }
        }catch {
            print ("Error encountered")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
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
        
        tableView.reloadData()
        
        
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
    

  

  

}
