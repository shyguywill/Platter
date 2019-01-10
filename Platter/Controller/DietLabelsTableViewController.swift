//
//  DietLabelsTableViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 09/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import RealmSwift

class DietLabelsTableViewController: UITableViewController {
    
    let dietArray = [Diet(title: "High-Protein"),Diet(title: "Low-Carb"),Diet(title: "Low-Fat"),Diet(title: "Gluten-free"),Diet(title: "Vegan"),Diet(title: "Vegetarian"),Diet(title: "Pescatarian")]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.register(UINib(nibName: "CustomItems", bundle: nil), forCellReuseIdentifier: "CustomIngredientCell")
        
        tableView.tableFooterView = UIView()
        
  
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dietArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomIngredientCell", for: indexPath) as? CustomItemsViewCell else { fatalError("Uninteded Index Path")}
        
        print ("got the right cells")
        
        cell.checkImage.image = dietArray[indexPath.row].selected ? UIImage(named: "greencheck"):UIImage(named: "nocheck")
        cell.ingredientName.text = dietArray[indexPath.row].title
        
    
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        dietArray[indexPath.row].selected = !dietArray[indexPath.row].selected
        tableView.reloadData()
    
    }
    
    




}
