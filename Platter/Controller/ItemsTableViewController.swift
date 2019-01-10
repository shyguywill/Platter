//
//  ItemsTableViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 04/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import RealmSwift


class ItemsTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var recipeItems : Results<Pantry>?
    let realm = try! Realm()
    let api = Edm_API()
    var searchParameters : String?
    var finalURL : String?
    var diet : String?
    var editPantry : Int?
    
    
    @IBOutlet weak var fridgeTableView: UITableView!
    @IBOutlet weak var plattrBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fridgeTableView.rowHeight = 50
        
        fridgeTableView.dataSource = self
        fridgeTableView.delegate = self
        
        fridgeTableView.register(UINib(nibName: "CustomItems", bundle: nil), forCellReuseIdentifier: "CustomIngredientCell")
        
        loadIngredients()
        
        firstLaunch()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if editPantry == 1{
            
            plattrBtn.isEnabled = false
            plattrBtn.isHidden = true
        }
        
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
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .default, title: "Delete") { (delete, indexpath) in

            if let pantry = self.recipeItems{

                let item = pantry[indexPath.row]
                
                Platter.delete(deleteItem: item)
            
            }
            
            self.loadIngredients()

        }
        
        return [delete]

    }
    
    //MARK: - Realm methods
    
    func loadIngredients() {
        
        recipeItems = realm.objects(Pantry.self)
        
        createParameterArray()
        
        createURL()
        
        fridgeTableView.reloadData()
        
        
    }
    
    //MARK: - First launch method
    
    func firstLaunch() {
        
        let firstTime = FirstLaunch(userDefaults: .standard, key: Keys.ingredntPage)
        
        if firstTime.isFirstLaunch{
            
            let alert = UIAlertController(title: "Let's get started", message: "Add ingredients and condiments to your Pantry with the '+' button, then select which to include in your search.", preferredStyle: .alert)
            
            let done = UIAlertAction(title: "Got it", style: .default) { (done) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.view.tintColor = UIColor(red: 50/255, green: 251/255, blue: 164/255, alpha: 1.0)
            
            alert.addAction(done)
            
            present(alert, animated: true, completion: nil)
        
        }
        
    }
    
    //MARK: - Platter me button
    
    @IBAction func platterBtn(_ sender: UIButton) {
        
        guard Connectivity.isConnectedToInternet else{ return Connectivity.handleNotConnected(view: self)}
        
        performSegue(withIdentifier: "platterMe", sender: self)
  
    }
    
//MARK:- Add new items
    
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add a new item", message: "Add a new ingredient to your pantry", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor(red: 50/255, green: 251/255, blue: 164/255, alpha: 1.0)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let fridgeIngredient = Pantry()
            
            fridgeIngredient.name = textFeild.text!
            
            Platter.save(saveItem: fridgeIngredient)
            
            self.loadIngredients()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        
        alert.addAction(cancel)
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextFeild) in
            
            alertTextFeild.placeholder = "New ingredient"
            alertTextFeild.autocorrectionType = UITextAutocorrectionType.yes
            alertTextFeild.autocapitalizationType = UITextAutocapitalizationType.sentences
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
            plattrBtn.isEnabled = !recipeApiItems.isEmpty //Disable button if no recipes are selected
            print (recipeApiItems.joined(separator: ","))
            searchParameters = recipeApiItems.joined(separator: ",")
            Search.searchParamters = recipeApiItems
            
            
        }else {
            
            print ("no search parameter present")
        }
        
    }
    
    func createURL() {
        
        if let ingredientsToSend = searchParameters{
            
            let newURL = api.baseURL + ingredientsToSend + "&app_id=" + api.appID + "&app_key=" + api.appKey + "&from=0&to=100" + Search.diet
            
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
