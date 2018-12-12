//
//  SavedMealsViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 11/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage


class SavedMealsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    @IBOutlet weak var savedMealTable: UITableView!
    
    var mealItem : Results<Meal>?
    let realm = try! Realm()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedMealTable.delegate = self
        savedMealTable.dataSource = self
        
        savedMealTable.register(UINib(nibName: "CustomRecipes", bundle: nil), forCellReuseIdentifier: "CustomRecipesViewCell")
        
        savedMealTable.rowHeight = 100
        
        loadMeals()
        
        // Do any additional setup after loading the view.
    }
    
    //Reload itemsin database
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadMeals()
        
    }
    
    
    //MARK: - Table Datasource methods
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealItem?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRecipesViewCell", for: indexPath) as? CustomRecipesViewCell else{ fatalError("Unexpected cell type")}
        
        if let meal = mealItem{
            
            cell.mealName.text = meal[indexPath.row].title
            
            let imageURL = meal[indexPath.row].image_URL
            
            cell.mealImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "logo"))
            
        }
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (delete, indexpath) in
            
            if let meal = self.mealItem{
                
                let item = meal[indexPath.row]
                
                self.deleteMeal(mealItem: item)
                
            }
            
            self.loadMeals()
            
        }
        
    
        return [delete]
    }
    
    //MARK: - Realm methods
    
    func loadMeals() {
        
        mealItem = realm.objects(Meal.self)
        
        savedMealTable.reloadData()
    }
    
    
    func deleteMeal(mealItem: Meal){
        
        do{
            try realm.write {
                
                realm.delete(mealItem)
            }
        }catch{
            print ("Could not delete item, ERROR, \(error)")
        }
        
    }




}
