//
//  SideMenuViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 07/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
    
    let options = ["Dietary preference","Pantry","Platcoins"]
    let optionsArray = [["None","High-Protein","Low-Carb","Vegan","Vegetarian"],["Edit Pantry"],["Restore Purchases"]]
    
    var lastSelection : IndexPath! //Enforces selection of only one cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return options[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return optionsArray[section].count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.textColor = UIColor(red: 37/255, green: 40/255, blue: 126/255, alpha: 1.0)
        cell.textLabel?.text = optionsArray[indexPath.section][indexPath.row]
        
        if indexPath.section == 0{
            cell.accessoryType = loadSavedCell(cell: indexPath.row)
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = tableView.indexPathForSelectedRow?.section else{return}
            
        if section == 0{
                
            if self.lastSelection != nil {
                tableView.cellForRow(at: self.lastSelection)?.accessoryType = .none
            }
                
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

            self.lastSelection = indexPath
                
            let path = indexPath.row
                
            print (path)
                
            UserDefaults.standard.set(path, forKey: Keys.mealOption)
                
            tableView.reloadData()
        }
        
        if section == 1{
            
            self.dismiss(animated: true, completion: nil)
            
            performSegue(withIdentifier: "editPantry", sender: self)
        }
            
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ItemsTableViewController{
            
            destinationVC.editPantry = 1
        }
    }
    
    //MARK: - Set cell accesory type 
    
    
    func loadSavedCell(cell: Int) -> UITableViewCell.AccessoryType{
        
        var selected = UITableViewCell.AccessoryType.none
        
        if let savedCell = UserDefaults.standard.object(forKey: Keys.mealOption) as? Int{
            
            if savedCell == cell{
                
                selected = UITableViewCell.AccessoryType.checkmark
            }
            
        }
        
        return selected
      
        
    }
    

}

extension UIAlertController{
    
    func setColour() -> UIColor{
        
        let platterGreen = UIColor(red: 50/255, green: 251/255, blue: 164/255, alpha: 1.0)
        
        return platterGreen
        
    }
    

}
